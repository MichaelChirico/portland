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

args = read.table(text = paste(commandArgs(trailingOnly = TRUE), 
                               collapse = '\t'),
                  stringsAsFactors = FALSE)
names(args) = c('delx', 'dely', 'alpha', 'eta', 'lt', 'theta',
                'features', 'kde.bw', 'kde.lags', 'l1', 'l2',
                'lambda', 'delta', 'T0', 'pp',
                'crime.type', 'horizon')
attach(args)

# baselines for testing:
delx=dely=250;alpha=0;eta=1.5;lt=4;theta=pi/36
features=10;kde.bw=250;kde.lags=6;
l1=1e-4;l2=1e-5;lambda=.5;delta=1;T0=0;pp=.5;
horizon='1w';crime.type='all'
cat("**********************\n",
    "* TEST PARAMETERS ON *\n",
    "**********************\n")

aa = delx*dely
lx = eta*delx
ly = eta*dely

week_0 = 0L
lag.range = week_0 + 
  c(switch(horizon, '1w' = 54L, '2w' = 53L,
           '1m' = 50L, '2m' = 46L, '3m' = 42L), 80L)

recent = week_0 + 
  c(switch(horizon, '1w' = 0, '2w' = -1L,
           '1m' = -4L, '2m' = -8L, '3m' = -12L), 26L)

prj = CRS("+init=epsg:2913")

crime.file = switch(crime.type,
                    all = "crimes_all.csv",
                    street = "crimes_str.csv",
                    burglary = "crimes_bur.csv",
                    vehicle = "crimes_veh.csv")

crimes = fread(crime.file)
crimes[ , occ_date := as.IDate(occ_date)]

rotate = function(x, y, theta, origin)
  matrix(origin, nrow = length(x), 
         ncol = 2L, byrow = TRUE) %*% (diag(2L) - RT(theta)) + 
  cbind(x, y) %*% RT(theta)
RT = function(theta) matrix(c(cos(theta), -sin(theta),
                              sin(theta), cos(theta)),
                            nrow = 2L, ncol = 2L)

point0 = crimes[ , c(min(x_coordina), min(y_coordina))]
crimes[ , paste0(c('x', 'y'), '_coordina') :=
          as.data.table(rotate(x_coordina, y_coordina, theta, point0))]

xrng = crimes[ , range(x_coordina)]
yrng = crimes[ , range(y_coordina)]

getGTindices <- function(gt) {
  dimx <- gt@cells.dim[1L]
  dimy <- gt@cells.dim[2L]
  c(matrix(seq_len(dimx*dimy), ncol = dimy, byrow = TRUE)[ , dimy:1L])
}

grdtop <- as(as.SpatialGridDataFrame.im(
  pixellate(ppp(xrange=xrng, yrange=yrng), eps=c(delx, dely))), "GridTopology")
grdSPDF = as.SpatialPolygons.GridTopology(grdtop, proj4string = prj)

idx.new <- getGTindices(grdtop)

incl_ids =
  with(crimes, as.data.table(pixellate(ppp(
    x = x_coordina, y = y_coordina,
    xrange = xrng, yrange = yrng, check = FALSE),
    eps = c(delx, dely)))[idx.new, ]
  )[value > 0, which = TRUE]

#join some missing crimes from unseen dates
seq_rng = function(rng) seq.int(rng[1L], rng[2L])
fake_crimes = 
  data.table(week_no = c(seq_rng(lag.range),
                         seq_rng(recent)))
crimes = crimes[fake_crimes, on = 'week_no']
#crimes.sp throws a hissy fit if fed NA coordinates
real_crimes = crimes[!is.na(x_coordina), which = TRUE]

crimes.sp =
  SpatialPointsDataFrame(
    coords = crimes[(real_crimes), cbind(x_coordina, y_coordina)],
    data = crimes[(real_crimes), -c('x_coordina', 'y_coordina')],
    proj4string = prj
  )

portland = 
  with(fread('data/portland_coords.csv'),
       rotate(x, y, theta, point0))

#See https://github.com/spatstat/spatstat/issues/44
#  and https://github.com/spatstat/spatstat/issues/45
fix_empty = function(DT) DT[ , value := as.integer(value)][]
crimes.grid.dt =
  crimes[week_no %between% recent, 
         fix_empty(as.data.table(pixellate(
           #for faux weeks, ppp will fail
           #  if all x are missing
           if (all(is.na(x_coordina)))
             ppp(xrange = xrng, yrange = yrng, check = FALSE)
           else 
             ppp(x = x_coordina, y = y_coordina,
                 xrange = xrng, yrange = yrng, check = FALSE),
           eps = c(delx, dely))))[idx.new],
         by = week_no][ , I := rowid(week_no)][I %in% incl_ids]

compute.kde <- function(pts, month)
  spkernel2d(pts = pts[pts$month_no == month, ],
             poly = portland, h0 = kde.bw, grd = grdtop)

compute.lag = function(pts, week_no)
  spkernel2d(pts = pts[pts$week_no %between%
                         (week_no + c(50L, 54L)), ],
             poly = portland, h0 = kde.bw, grd = grdtop)

compute.kde.list <- function (pts, months = seq_len(kde.lags) + 12L)
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
    compute.kde.list(pts, months=13L)))
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

crimes.grid.dt[ , train := week_no > week_0]

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
test.vw = tempfile(tmpdir = tdir, pattern = "test")
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

hotspot.ids =
  crimes.grid.dt[ , .(tot.pred = sum(pred.count)), by = I
                  ][order(-tot.pred)[1L:n.cells], I]
crimes.grid.dt[ , hotspot := I %in% hotspot.ids]
