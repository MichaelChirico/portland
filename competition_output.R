#!/usr/bin/env Rscript
# Forecasting Crime in Portland
# ******** Submission Conversion *********
# * For a given set of hyperparameters,  *
# * create training data and fit Poisson *
# * regression with VW on 2017 (&recent) *
# * data, then assign hotspot indicator  *
# * to each of the grid cells, convert   *
# * it to a shapefile, clip to Portland  *
# * boundary, and write out. See         *
# * evaluate_params.R for more comments  *
# ****************************************
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
library(spatstat)
library(splancs)
library(rgeos)
library(data.table)
library(foreach)
library(maptools)
library(zoo)

#make sure we use the same seed
#  as evaluation_params.R
set.seed(60251935)

args = commandArgs(trailingOnly = TRUE)
delx = as.integer(args[1L])
dely = as.integer(args[2L])
alpha = as.numeric(args[3L])
eta = as.numeric(args[4L])
lt = as.numeric(args[5L])
theta = as.numeric(args[6L])
features = as.integer(args[7L])
kde.bw = as.numeric(args[8L])
kde.lags = as.integer(args[9L])
l1 = as.numeric(args[10L])
l2 = as.numeric(args[11L])
lambda = as.numeric(args[12L])
delta = as.numeric(args[13L])
T0 = as.numeric(args[14L])
pp = as.numeric(args[15L])
crime.type = args[16L]
horizon = args[17L]

# baselines for testing:
# delx=dely=250;alpha=0;eta=1.5;lt=4;theta=pi/36
# features=10;kde.bw=250;kde.lags=6
# horizon='1w';crime.type='all'
# cat("**********************\n",
#     "* TEST PARAMETERS ON *\n",
#     "**********************\n")

aa = delx*dely
lx = eta*delx
ly = eta*dely

lag.range = 
  as.IDate(
    c('2015-08-17',
    switch(horizon, 
           '1w' = '2016-04-14', '2w' = '2016-04-14',
           '1m' = '2016-04-14', '2m' = '2016-05-14', '3m' = '2016-06-14'
    )))

crime.file = switch(crime.type,
                    all = "crimes_all.csv",
                    street = "crimes_str.csv",
                    burglary = "crimes_bur.csv",
                    vehicle = "crimes_veh.csv")

crimes = fread(crime.file)
crimes[ , occ_date := as.IDate(occ_date)]

rotate = function(points, theta, origin)
  matrix(origin, nrow = nrow(points), 
         ncol = 2L, byrow = TRUE) %*% (diag(2L) - RT(theta)) + 
  points %*% RT(theta)
RT = function(theta) matrix(c(cos(theta), -sin(theta), 
                              sin(theta), cos(theta)), 
                            nrow = 2L, ncol = 2L)

point0 = crimes[ , c(min(x_coordina), min(y_coordina))]
crimes[ , paste0(c('x', 'y'), '_coordina') :=
          as.data.table(rotate(cbind(x_coordina, y_coordina),
                               theta, point0))]

xrng = crimes[ , range(x_coordina)]
yrng = crimes[ , range(y_coordina)]

getGTindices <- function(gt) {
  dimx <- gt@cells.dim[1L]
  dimy <- gt@cells.dim[2L]
  c(matrix(seq_len(dimx*dimy), ncol = dimy, byrow = TRUE)[ , dimy:1L])
}

grdtop <- as(as.SpatialGridDataFrame.im(
  pixellate(ppp(xrange=xrng, yrange=yrng), eps=c(delx, dely))), "GridTopology")

idx.new <- getGTindices(grdtop)

incl_ids = 
  with(crimes, as.data.table(pixellate(ppp(
    x = x_coordina, y = y_coordina,
    xrange = xrng, yrange = yrng, check = FALSE),
    eps = c(delx, dely)))[idx.new, ]
  )[value > 0, which = TRUE]

crimes = crimes[(occ_date %between% lag.range) | (occ_date >= '2016-09-01')]

crimes.sp = 
  SpatialPointsDataFrame(
    coords = crimes[ , cbind(x_coordina, y_coordina)],
    data = crimes[ , -c('x_coordina', 'y_coordina')],
    proj4string = CRS("+init=epsg:2913")
  )

portland = 
  rotate(do.call(cbind, fread('data/portland_coords.csv')), theta, point0)

crimes.grid.dt = 
  crimes[occ_date >= '2016-09-01', 
         as.data.table(pixellate(ppp(
           x = x_coordina, y = y_coordina,
           xrange = xrng, yrange = yrng, check = FALSE),
           eps = c(x = delx, dely)))[idx.new],
         by = week_no][ , I := rowid(week_no)][I %in% incl_ids]

compute.kde <- function(pts, month) 
  spkernel2d(pts = pts[pts$month_no == month, ],
             poly = portland, h0 = kde.bw, grd = grdtop)

compute.lag = function(pts, week_no)
  spkernel2d(pts = pts[pts$week_no %between% 
                         (week_no + c(50L, 54L)), ],
             poly = portland, h0 = kde.bw, grd = grdtop)

compute.kde.list <- function (pts, months = seq_len(kde.lags)) 
  lapply(setNames(months, paste0('kde', months)),
         function(month) compute.kde(pts, month))

kdes = setDT(compute.kde.list(crimes.sp))

## **TO DO: deal with this properly
callgroup.top = 
  crimes[, .N, by=CALL_GROUP
         ][order(-N), if (.N > 1) CALL_GROUP[seq_len(min(3L, .N - 1L))]]
if (!is.null(callgroup.top)) {
  crimes.cgroup = lapply(callgroup.top, function(cg) 
    crimes.sp[crimes.sp$CALL_GROUP == cg,])
  kdes.sub = setDT(sapply(crimes.cgroup, function(pts) 
    compute.kde.list(pts, months=1L)))
  setnames(kdes.sub, paste0('cg.kde', 1L:ncol(kdes.sub)))
  kdes = cbind(kdes, kdes.sub)
}

kdes[, I := .I]

crimes.grid.dt = kdes[crimes.grid.dt, on = 'I']

crimes.grid.dt[ , lg.kde := {
  kde = compute.lag(crimes.sp, .BY$week_no)
  idx = data.table(kde, I = seq_len(length(kde)))[.SD, on = 'I', which = TRUE]
  kde[idx]
}, by = week_no]

#add some fake crimes for future dates
## calculated the integer values of these dates by hand
##   to save space
new_weeks = seq.int(-65L, -52L)
crimes.grid.dt = 
  crimes.grid.dt[CJ(I = I, week_no = c(unique(week_no), new_weeks), 
                    unique = TRUE), on = c('I', 'week_no')]
crimes.grid.dt[ , train := !is.na(kde1)]
#used cell ID to create dummy rows; now
#  use cell ID to reincorporate x/y data
crimes.grid.dt[ , c('x', 'y') := .SD[!is.na(kde1)][1L, .(x, y)], by = I]

proj = crimes.grid.dt[ , cbind(x, y, week_no)] %*% 
  (matrix(rt(3L*features, df = 2.5), nrow = 3L)/c(lx, ly, lt))

incl = setNames(
  nm = setdiff(names(crimes.grid.dt), 
               c("I", "week_no", "x", "y", "value", "train"))
)
incl.kde = grep("^kde", incl, value = TRUE)
incl.cg = grep("^cg.", incl, value = TRUE)

phi.dt =
  crimes.grid.dt[ , {
    coln_to_vw = function(vn) { 
      V = get(vn)
      val = V * 10^(abs(round(mean(log10(V[V>0])))))
      sprintf("%s:%.5f", vn, val)
    }
    c(list(v = value, 
           l = paste0(I, "_", week_no, "|kdes")), 
      lapply(incl.kde, coln_to_vw),
      list(cg_namespace = if (length(incl.cg)) '|cgkde'),
      lapply(incl.cg, coln_to_vw),
      list(lag_namespace = '|lgkde',
           kdel = coln_to_vw('lg.kde')),
      list(rff_namespace = '|rff'))
  }]

if (features > 500L) invisible(alloc.col(phi.dt, 3L*features))
fkt = 1/sqrt(features)
for (jj in 1L:features) {
  pj = proj[ , jj]
  set(phi.dt, j = paste0(c("cos", "sin"), jj), 
      value = list(sprintf("cos%i:%.5f", jj, fkt*cos(pj)),
                   sprintf("sin%i:%.5f", jj, fkt*sin(pj))))
}
rm(proj)

source("local_setup.R")
train.vw = tempfile(tmpdir = tdir, pattern = "train")
pred.vw = tempfile(tmpdir = tdir, pattern = "predict")
fwrite(phi.dt[crimes.grid.dt$train], train.vw,
       sep = " ", quote = FALSE, col.names = FALSE,
       showProgress = FALSE)
fwrite(phi.dt[!crimes.grid.dt$train], test.vw,
       sep = " ", quote = FALSE, col.names = FALSE,
       showProgress = FALSE)

crimes.grid.dt = crimes.grid.dt[(!train)]
rm(phi.dt)

which.round = function(x)
  if (x > 0) {if (x < 1) round else floor} else ceiling

n.cells = as.integer(which.round(alpha)(6969600*(1+2*alpha)/aa))

model = tempfile(tmpdir = tdir, pattern = "model")
system(paste(path_to_vw, '--loss_function poisson --l1', l1, '--l2', l2,
             '--learning_rate', lambda,
             '--decay_learning_rate', delta,
             '--initial_t', T0, '--power_t', pp, train.vw,
             '--passes 200 -f', model))
invisible(file.remove(train.vw))
system(paste(path_to_vw, '-t -i', model, '-p', pred.vw,
             test.vw, '--loss_function poisson'))
invisible(file.remove(model, test.vw))

preds =
  fread(pred.vw, sep = " ", header = FALSE, col.names = c("pred", "I_wk"))
invisible(file.remove(pred.vw))
preds[ , c("I", "week_no", "I_wk") :=
         c(lapply(tstrsplit(I_wk, split = "_"), as.integer),
           list(NULL))]

crimes.grid.dt[preds, pred.count := exp(i.pred), on = c("I", "week_no")]
rm(preds)
