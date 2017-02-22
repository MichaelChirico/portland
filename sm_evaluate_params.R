#!/usr/bin/env Rscript
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
t0 = proc.time()["elapsed"]
suppressMessages({
  library(spatstat, quietly = TRUE)
  library(splancs, quietly = TRUE)
  library(rgeos)
  library(data.table, warn.conflicts = FALSE, quietly = TRUE)
  library(foreach)
  library(maptools)
})

#from random.org
set.seed(60251935)

# each argument read in as a string in a character vector;
 # would rather have them as a list. basically do
 # that by converting them to a form read.table
 # understands and then attaching from a data.frame
args = read.table(text = paste(commandArgs(trailingOnly = TRUE),
                               collapse = '\t'),
                  stringsAsFactors = FALSE)
names(args) =
  c('delx', 'dely', 'alpha', 'eta', 'lt', 'theta',
    'features', 'kde.bw', 'kde.lags', 'kde.win', 'crime.type', 'horizon')
attach(args)

# # baselines for testing:
# delx=250;dely=250;alpha=0;eta=2.72;lt=2.42;theta=0
# features=10;kde.bw=313;kde.lags=15;kde.win = 7
# horizon='1m';crime.type='burglary'
# cat("**********************\n",
#     "* TEST PARAMETERS ON *\n",
#     "**********************\n")

aa = delx*dely #forecasted area
lx = eta*250
ly = eta*250
#What weeks cover the recent past data
#  and the furthest "future" date to forecast
## training t ends:
###  (HH = 2017 is forecasting period of March 2017)
HH0 = 2016
week_0 = 105 # 52L
date_0 = as.IDate('2015-03-01') # start of training data
## note: perhaps confusingly, "left" endpoint is
##   later in time (since we count down weeks
##   to the forecasting t)
recent = week_0 + 
  c(switch(horizon, '1w' = 0, '2w' = -1L,
           '1m' = -4L, '2m' = -8L, '3m' = -12L), 26L)

#one "year" prior (+/- 2 weeks) includes which weeks?
lag.range = week_0 + 
  c(switch(horizon, '1w' = 54L, '2w' = 53L,
           '1m' = 50L, '2m' = 46L, '3m' = 42L), 80L)

crime.file = switch(crime.type,
                    all = "crimes_all.csv",
                    street = "crimes_str.csv",
                    burglary = "crimes_bur.csv",
                    vehicle = "crimes_veh.csv")

crimes = fread(crime.file)
# setnames(crimes, 'week_no', 't')
crimes[ , occ_date := as.IDate(occ_date)]

# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>=
# ROTATION ----
# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>=

#rotation formula, relative to a point (x_0, y_0) that's not origin:
#  [x_0, y_0] + R * [x - x_0, y - y_0]
#  (i.e., rotate the distances from (x_0, y_0) about that point,
#   then offset again by (x_0, y_0))
#  Equivalently (implemented below):
#  (I - R)[x_0, y_0] + R[x, y]
rotate = function(x, y, theta, origin)
  matrix(origin, nrow = length(x), 
         ncol = 2L, byrow = TRUE) %*% (diag(2L) - RT(theta)) + 
  cbind(x, y) %*% RT(theta)
#use the transpose of the rotation matrix to multiply against
#  column vectors of coordinates
RT = function(theta) matrix(c(cos(theta), -sin(theta), 
                              sin(theta), cos(theta)), 
                            nrow = 2L, ncol = 2L)

point0 = crimes[ , c(min(x_coordina), min(y_coordina))]
crimes[ , paste0(c('x', 'y'), '_coordina') :=
          as.data.table(rotate(x_coordina, y_coordina, theta, point0))]

#record range here, so that
#  we have the same range 
#  after we subset below
xrng = crimes[ , range(x_coordina)]
yrng = crimes[ , range(y_coordina)]

# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>=
# CREATE GRID ----
# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>=

getGTindices <- function(gt) {
  # Obtain indices to rearange data from image (eg. result frim pixellate)
  # so that it conforms with data from GridTopology objects (eg. results
  # from using spkernel2d).
  # Input: gt is a grid topology.
  # Returns an index.
  dimx <- gt@cells.dim[1L]
  dimy <- gt@cells.dim[2L]
  c(matrix(seq_len(dimx*dimy), ncol = dimy, byrow = TRUE)[ , dimy:1L])
}

# from create GridTopology corresponding to pixel image used for crime counts
grdtop <- as(as.SpatialGridDataFrame.im(
  pixellate(ppp(xrange=xrng, yrange=yrng), eps=c(delx, dely))), "GridTopology")

# index to rearrange rows in pixellate objects
idx.new <- getGTindices(grdtop)

#Before subsetting, get indices of ever-crime cells
## Per here, these are always sorted by x,y:
##   https://github.com/spatstat/spatstat/issues/37

incl_ids = 
  with(crimes, as.data.table(pixellate(ppp(
    #pixellate counts dots over each cell,
    #  and appears to do so pretty quickly
    x = x_coordina, y = y_coordina,
    xrange = xrng, yrange = yrng, check = FALSE),
    #this must be done within-loop
    #  since it depends on delx & dely
    eps = c(delx, dely)))[idx.new, ]
    #find cells that ever have a crime
  )[value > 0, which = TRUE]

#boundary coordinates of portland
portland = 
  with(fread('data/portland_coords.csv'),
       rotate(x, y, theta, point0))

# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>=
# CREATE DATA TABLE OF CRIMES ----
# 1) aggregate at lag.window level for included periods
# 2) aggregate at forecasting horizon level for included periods
# 3) merge previous results
# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>=

# set of dates for LHS
# march1s = crimes[month(occ_date)==3 & mday(occ_date)==1, unique(occ_date)]
# march1s = rev(c(march1s, as.IDate('2017-03-01')))
march1s = as.IDate(paste0(2012:2017, '-03-01'))

H.rng = switch(horizon, '1w' = lapply(march1s, function (date) date + c(0,6)),
               '2w' = lapply(march1s, function (date) date + c(0,13)),
               '1m' = lapply(march1s, function (date) date + c(0,30)),
               '2m' = lapply(march1s, function (date) date + c(0,60)),
               '3m' = lapply(march1s, function (date) date + c(0,91)))

# create LHS period indicator (will need to aggregate)
for (ii in seq_along(H.rng)){
  crimes[occ_date %between% H.rng[[ii]], HH := 2017 - ii + 1]
}

# aggregate, cell counts
X = crimes[!is.na(HH)][, 
                       as.data.table(pixellate(ppp(
                         x = x_coordina, y = y_coordina,
                         xrange = xrng, yrange = yrng, check = FALSE),
                         #reorder using GridTopology - im mapping
                         eps = c(x = delx, dely)))[idx.new],
                       #subset to eliminate never-crime cells
                       by = HH][ , I := rowid(HH)]#[I %in% incl_ids]

#can use this to split into train & test
X[ , train := HH < HH0]

# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
# KDE LAGS ----
# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

lag.days = function (nb.days, lags){
  # returns a list of integer ranges with the day numbers
  # that each lag will include.
  lapply(1:lags, function(x) 1:nb.days + nb.days*(x-1))
}

lag.dates = function (date, nb.days, lags){
  # returns a list of length lags with respect to date
  # with the dates that each lag contains.
  lapply(lag.days(nb.days, lags), function (lw) date - lw )
}

# find day_no (distance from March 1st 2017) for each March 1st in the data
# march1.dayno = crimes[occ_date %in% march1s, unique(day_no)]
march1.dayno = sapply(march1s, 
       function (date) difftime(as.IDate('2017-03-01'), date, units='days'))

# generate lag ids
ldays = lag.days(kde.win, kde.lags)
for (lag in seq_along(ldays)){
  # list of days in relation to day_no (day_no=0 <=> March 1st 2017)
  lag.day_no.list = unlist(lapply(march1.dayno, function (dayno) dayno + ldays[[lag]]))
  crimes[day_no %in% lag.day_no.list, lag_no := lag]
}

# create sp object of crimes
to.spdf = function(dt) {
  SpatialPointsDataFrame(
    coords = dt[ , cbind(x_coordina, y_coordina)],
    data = dt[ , -c('x_coordina', 'y_coordina')],
    proj4string = CRS("+init=epsg:2913"))
}
crimes.sp = to.spdf(crimes)

compute.kde <- function(pts) {
  kde = spkernel2d(pts = pts,
                   #quartic kernel used by default
                   poly = portland, h0 = kde.bw, grd = grdtop)
  # turn into expected count
  kde * nrow(pts)
}
# crimes[fyear==2016, range(occ_date)]

kde = crimes[!is.na(lag_no), .(value = compute.kde(to.spdf(.SD))), by = .(fyear, lag_no)]
setkey(kde, fyear, lag_no)
kde[, I := rowid(fyear, lag_no)]
# plot(SpatialGridDataFrame(grdtop, kde[.(2016, 5), 'value']))
# add kdes to data
lag_names = paste0('kde', 1:kde.lags)
for (llag in seq_along(lag_names)){
  X[, lag_names[[llag]] := kde[.(.BY$HH, llag), value], by=HH]
}

# remove cells outside border
X = X[!is.na(kde1)]
# plot(SpatialGridDataFrame(grdtop, X[kde[lag_no==6], on=c('I', HH='fyear')][HH==2013, 'kde3']))

# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
# PROJECTION ----
# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

#project -- these are the omega * xs
proj = X[ , cbind(x, y, HH)] %*% 
  (matrix(rt(3L*features, df = 2.5), nrow = 3L)/c(lx, ly, lt))

#convert to data.table to use fwrite
incl = setNames(
  nm = setdiff(names(X), 
               c("I", "HH", "x", "y", "value", "train"))
)
incl.kde = grep("^kde", incl, value = TRUE)

# check for NAs in the features
stopifnot(!any(is.na(X)))

phi.dt =
  X[ , {
    #some nonsense about how get works in j --
    #  if we define coln_to_vw in global environment,
    #  lapply(incl.kde, coln_to_vw) fails because
    #  get doesn't find the variables.
    #  Probably some workaround, but w/e
    coln_to_vw = function(vn) { 
      V = get(vn)
      #scale up to minimize wasted 0s
      val = V * 10^(abs(round(mean(log10(V[V>0])))))
      if (any(is.nan(val)))
        stop('NaNs detected! Current parameters:',
             paste(args, collapse = '/'))
      sprintf("%s:%.5f", vn, val)
    }
    c(list(v = value, 
           l = paste0(I, "_", HH, "|kdes")), 
      lapply(incl.kde, coln_to_vw),
      # list(cg_namespace = if (length(incl.cg)) '|cgkde'),
      # lapply(incl.cg, coln_to_vw),
      # list(cd_namespace = '|cdkde'),
      # lapply(incl.cd, coln_to_vw),
      # list(pd_namespace = '|pd',
      #      pd = DISTRICT),
      # list(lag_namespace = '|lgkde',
      #      kdel = coln_to_vw('lg.kde')),
      list(rff_namespace = '|rff'))
  }]

if (features > 500L) invisible(alloc.col(phi.dt, 3L*features))
#create the features
#  previously explored alternative:
#  assign cos/sin projection as matrix:
#  phi = cbind(cos(proj), sin(proj))/sqrt(features)
#  then assign to phi.dt column-wise,
#  but this _appears_ to be slower than implicitly
#  creating this as below by taking sin/cos 
#  simultaneously with assigning to phi.dt.
fkt = 1/sqrt(features)
for (jj in 1L:features) {
  pj = proj[ , jj]
  set(phi.dt, j = paste0(c("cos", "sin"), jj), 
      value = list(sprintf("cos%i:%.5f", jj, fkt*cos(pj)),
                   sprintf("sin%i:%.5f", jj, fkt*sin(pj))))
}
rm(proj)

# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
# WRITE VW FILES ----
# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
# 
#temporary files
source("local_setup.R")
train.vw = tempfile(tmpdir = tdir, pattern = "train")
test.vw = tempfile(tmpdir = tdir, pattern = "test")
#simply append .cache suffix to make it easier
#  to track association when debugging
cache = paste0(train.vw, '.cache')
pred.vw = tempfile(tmpdir = tdir, pattern = "predict")
fwrite(phi.dt[X$train], train.vw,
       sep = " ", quote = FALSE, col.names = FALSE,
       showProgress = FALSE)
fwrite(phi.dt[!X$train], test.vw,
       sep = " ", quote = FALSE, col.names = FALSE,
       showProgress = FALSE)

# #can eliminate all the testing data now that it's written
X = X[(!train)]
# print('**** this should not be zero!')
# X[, .N]
# stop('about to call vw')
rm(phi.dt)

tuning_variations =
  data.table(l1 = c(1e-6, 1e-4, 1e-3, 5e-3, rep(1e-5, 23L)),
             l2 = c(rep(1e-4, 4L), 1e-6, 5e-6,
                    1e-5, 5e-5, 5e-4, rep(1e-4, 18L)),
             lambda = c(rep(.5, 9L), .01, .05,
                        .1, .25, .75, 1, 1.5, rep(.5, 11L)),
             delta = c(rep(1, 16L), .5, 1.5, rep(1, 9L)),
             T0 = c(rep(0, 18L), .5, 1, 1.5, rep(0, 6L)),
             pp = c(rep(.5, 21L), .25, .33, .5,
                    .66, .75, 1))
n_var = nrow(tuning_variations)

#initialize parameter records table
scores = data.table(delx, dely, alpha, eta, lt, theta, k = features,
                    l1 = numeric(n_var), l2 = numeric(n_var),
                    lambda = numeric(n_var), delta = numeric(n_var),
                    t0 = numeric(n_var), p = numeric(n_var),
                    kde.bw, kde.n = 'all', kde.lags, kde.win,
                    pei = numeric(n_var), pai = numeric(n_var))

#when we're at the minimum forecast area, we must round up
#  to be sure we don't undershoot; when at the max,
#  we must round down; otherwise, just round
# **TO DO: if we predict any boundary cells and are using the minimum
#          forecast area, WE'LL FALL BELOW IT WHEN WE CLIP TO PORTLAND **
which.round = function(x)
  if (x > 0) {if (x < 1) round else floor} else ceiling

#6969600 ft^2 = .25 mi^2 (minimum forecast area);
#triple this is maximum forecast area
n.cells = as.integer(which.round(alpha)(6969600*(1+2*alpha)/aa))

#Calculate PEI & PAI denominators here since they are the
#  same for all variations of tuning parameters,
#  given the input parameters (delx, etc.)
N_star = X[ , .(tot.crimes = sum(value)), by = I
            ][order(-tot.crimes)[1L:n.cells],
              sum(tot.crimes)]
NN = X[ , sum(value)]

for (ii in seq_len(nrow(tuning_variations))) {
  model = tempfile(tmpdir = tdir, pattern = "model")
  #train with VW
  call.vw = with(tuning_variations[ii],
       paste(path_to_vw, '--loss_function poisson --l1', l1, '--l2', l2,
                    '--learning_rate', lambda,
                    '--decay_learning_rate', delta,
                    '--initial_t', T0, '--power_t', pp, train.vw,
                    '--cache_file', cache, '--passes 200 -f', model))
  system(call.vw, ignore.stderr = TRUE)
  #training data now stored in cache format,
  #  so can delete original (don't need to, but this is a useful
  #  check to force an error if s.t. wrong with cache)
  if (file.exists(train.vw)) invisible(file.remove(train.vw))
  #test with VW
  system(paste(path_to_vw, '-t -i', model, '-p', pred.vw,
               test.vw, '--loss_function poisson'),
         ignore.stderr = TRUE)
  invisible(file.remove(model))
  
  preds =
    fread(pred.vw, sep = " ", header = FALSE, col.names = c("pred", "I_yr"))
  invisible(file.remove(pred.vw))
  #wrote 2-variable label with _ to fit VW guidelines;
  #  now split back to constituents so we can join
  preds[ , c("I", "HH", "I_yr") :=
           c(lapply(tstrsplit(I_yr, split = "_"), as.integer),
             list(NULL))]
  
  X[preds, pred.count := exp(i.pred), on = c("I", "HH")]
  rm(preds)
  
  hotspot.ids =
    X[ , .(tot.pred = sum(pred.count)), by = I
       ][order(-tot.pred)[1L:n.cells], I]
  X[ , hotspot := I %in% hotspot.ids]
  
  #how well did we do? lower-case n in the PEI/PAI calculation
  nn = X[(hotspot), sum(value)]
  
  scores[ii, c('l1', 'l2', 'lambda', 'delta',
               't0', 'p', 'pei', 'pai') :=
           c(tuning_variations[ii],
             list(pei = nn/N_star,
                  #pre-calculated the total area of portland
                  pai = (nn/NN)/(aa*n.cells/4117777129)))]
}
invisible(file.remove(cache, test.vw))

# sgdf = SpatialGridDataFrame(grdtop, 
#    data = kde[.(2016,1)])
# plot(sgdf[sgdf$I %in% hotspot.ids,,'value'])
# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>=
# WRITE RESULTS FILE AND TIMINGS
# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>=

ff = paste0("scores/", 'sm_',crime.type, "_", horizon, job_id, ".csv")
fwrite(scores, ff, append = file.exists(ff))

t1 = proc.time()["elapsed"]
ft = paste0("timings/", crime.type, "_", horizon, job_id, ".csv")
if (!file.exists(ft))
  cat("delx,dely,alpha,eta,lt,theta,k,kde.bw,kde.lags,time\n", sep = "", file = ft)
params = paste(delx, dely, alpha, eta, lt, theta, features,
               kde.bw, kde.lags, t1 - t0, sep = ",")
cat(params, "\n", sep = "", append = TRUE, file = ft)

