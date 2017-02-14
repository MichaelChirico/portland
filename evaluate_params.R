#!/usr/bin/env Rscript
# Forecasting Crime in Portland
# *** Parameter Evaluation (PEI & PAI) ***
# * For a given set of hyperparameters,  *
# * create test & training data and fit  *
# * Poisson regression with VW on        *
# * training data for a few dozen chosen *
# * alternative VW hyperparameters, then *
# * calculate PEI & PAI on the implied   *
# * optimal prediction; write to output  *
# * the following: PEI, PAI, evaluation  *
# * time, and baseline KDE estimate      *
# ****************************************
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

#each argument read in as a string in a character vector;
#  would rather have them as a list. basically do
#  that by converting them to a form read.table
#  understands and then attaching from a data.frame
args = read.table(text = paste(commandArgs(trailingOnly = TRUE), 
                               collapse = '\t'),
                  stringsAsFactors = FALSE)
names(args) = 
  c('delx', 'dely', 'alpha', 'eta', 'lt', 'theta',
    'features', 'kde.bw', 'kde.lags', 'crime.type', 'horizon')
attach(args)

# baselines for testing:
delx=dely=600;alpha=0;eta=1.5;lt=4;theta=0
features=10;kde.bw=250;kde.lags=6
horizon='1w';crime.type='all'
cat("**********************\n",
    "* TEST PARAMETERS ON *\n",
    "**********************\n")

aa = delx*dely #forecasted area
lx = eta*delx
ly = eta*dely
#What days cover the recent past data
#  and the furthest "future" date to forecast
recent = 
  as.IDate(
    c('2015-09-01',
      switch(
        horizon, '1w' = '2016-03-07', '2w' = '2016-03-14',
        '1m' = '2016-03-31', '2m' = '2016-04-30', '3m' = '2016-05-31'
      )
    ))

#one year prior includes which dates?
lag.range = 
  as.IDate(
    c('2014-08-17',
    switch(horizon, 
           '1w' = '2015-04-14', '2w' = '2015-04-14',
           '1m' = '2015-04-14', '2m' = '2015-05-14', '3m' = '2015-06-14'
    )))

crime.file = switch(crime.type,
                    all = "crimes_all.csv",
                    street = "crimes_str.csv",
                    burglary = "crimes_bur.csv",
                    vehicle = "crimes_veh.csv")

crimes = fread(crime.file)
crimes[ , occ_date := as.IDate(occ_date)]
#rotation formula, relative to a point (x_0, y_0) that's not origin:
#  [x_0, y_0] + R * [x - x_0, y - y_0]
#  (i.e., rotate the distances from (x_0, y_0) about that point,
#   then offset again by (x_0, y_0))
#  Equivalently (implemented below):
#  (I - R)[x_0, y_0] + R[x, y]
rotate = function(points, theta, origin)
  matrix(origin, nrow = nrow(points), 
         ncol = 2L, byrow = TRUE) %*% (diag(2L) - RT(theta)) + 
  points %*% RT(theta)
#use the transpose of the rotation matrix to multiply against
#  column vectors of coordinates
RT = function(theta) matrix(c(cos(theta), -sin(theta), 
                              sin(theta), cos(theta)), 
                            nrow = 2L, ncol = 2L)

point0 = crimes[ , c(min(x_coordina), min(y_coordina))]
crimes[ , paste0(c('x', 'y'), '_coordina') :=
          as.data.table(rotate(cbind(x_coordina, y_coordina),
                               theta, point0))]

#record range here, so that
#  we have the same range 
#  after we subset below
xrng = crimes[ , range(x_coordina)]
yrng = crimes[ , range(y_coordina)]

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

# trying to learn using only recent data 
#  and one-year lag for now
crimes = crimes[(occ_date %between% lag.range) | (occ_date %between% recent)]

# create sp object of crimes
crimes.sp = 
  SpatialPointsDataFrame(
    coords = crimes[ , cbind(x_coordina, y_coordina)],
    data = crimes[ , -c('x_coordina', 'y_coordina')],
    proj4string = CRS("+init=epsg:2913")
  )

#boundary coordinates of portland
portland = 
  rotate(do.call(cbind, fread('data/portland_coords.csv')), theta, point0)

# >>>>>> plot boundary
par(mfrow=c(1,1))
p = Polygon(rbind(portland, portland[1, ]))
plot(SpatialPolygons(list(Polygons(list(p),c('1')))))

# ============================================================================
# CREATE DATA TABLE OF CRIMES
# aggregate at week-cell level
# ============================================================================

crimes.grid.dt = 
  crimes[occ_date %between% recent, 
         as.data.table(pixellate(ppp(
           x = x_coordina, y = y_coordina,
           xrange = xrng, yrange = yrng, check = FALSE),
           #reorder using GridTopology - im mapping
           eps = c(x = delx, dely)))[idx.new],
         #subset to eliminate never-crime cells
         by = week_no][ , I := rowid(week_no)][I %in% incl_ids]

#can use this to split into train & test
crimes.grid.dt[ , train := week_no > 0L]

# ============================================================================
# KDEs
# ============================================================================

compute.kde <- function(pts, month) 
  spkernel2d(pts = pts[pts$month_no == month, ],
             #quartic kernel used by default
             poly = portland, h0 = kde.bw, grd = grdtop)

#input _current_ week number,
#  output KDE for 50-54 weeks _prior_
#  (i.e., one year ago, with 2 week window)
compute.lag = function(pts, week_no)
  spkernel2d(pts = pts[pts$week_no %between% 
                         (week_no + c(50L, 54L)), ],
             poly = portland, h0 = kde.bw, grd = grdtop)

compute.kde.list <- function (pts, months = seq_len(kde.lags) + 12L) 
  # compute kde for each month.
  # return data.table, each col stores results for one month
  lapply(setNames(months, paste0('kde', months)),
         function(month) compute.kde(pts, month))

kdes = setDT(compute.kde.list(crimes.sp))

# ============================================================================
# SUBCATEGORIES - CALLGROUPS
# Compute KDE for last mont for top three callgroups
# ============================================================================

# pick largest call groups
callgroup.top = 
  crimes[, .N, by=CALL_GROUP
         #all but 'all' have 2 or fewer call groups;
         #  include at most N-1 of them to avoid collinearity
         ][order(-N), if (.N > 1) CALL_GROUP[seq_len(min(3L, .N - 1L))]]

if (!is.null(callgroup.top)) {
  crimes.cgroup = lapply(callgroup.top, function(cg) 
    crimes.sp[crimes.sp$CALL_GROUP == cg,])
  
  kdes.sub = setDT(sapply(crimes.cgroup, function(pts) 
    compute.kde.list(pts, months=13L)))
  
  setnames(kdes.sub, paste0('cg.kde', 1L:ncol(kdes.sub)))
  
  # combine normal kdes and sub-kdes
  kdes = cbind(kdes, kdes.sub)
}

# add cell id
kdes[, I := .I]

# ============================================================================
# SUBCATEGORIES - CALL PRIORITIES
# ============================================================================

# select CASE_DESC cases as boolean vectors
cd.cases = with(crimes.sp@data,
                data.frame(
                  cd.kde1 = grepl('COLD', CASE_DESC),
                  cd.kde2 = grepl('PRIORITY', CASE_DESC) & !grepl('*H', CASE_DESC),
                  cd.kde3 = grepl('PRIORITY[[:space:]][*]', CASE_DESC))
                )

# compute kdes for each CASE_DESC case selected
cd.kdes = setDT(lapply(cd.cases, function(cd) {
  spkernel2d(pts = crimes.sp[cd & crimes.sp$month_no %between% c(13L, 19L),],
             poly = portland, h0 = kde.bw, grd = grdtop)
}))

kdes = cbind(kdes, cd.kdes)

# append kdes
crimes.grid.dt = kdes[crimes.grid.dt, on = 'I']

# compute one year lag kdes for each cell-week
crimes.grid.dt[ , lg.kde := {
  kde = compute.lag(crimes.sp, .BY$week_no)
  idx = data.table(kde, I = seq_len(length(kde)))[.SD, on = 'I', which = TRUE]
  kde[idx]
}, by = week_no]

# sgdf = SpatialGridDataFrame(grdtop, kdes[, 'cd.kde3'])
# plot(sgdf)

# ============================================================================
# POLICE DISTRICT DUMMY
# 1) load police districts shapefile
# 2) transfrom grid to SpatialPolygons
# 3) spatial overlay of the two objects using centroids of each cell
# ============================================================================
crs = CRS("+init=epsg:2913")
portland.pd = readShapePoly("./data/Portland_Police_Districts.shp", 
                            proj4string = crs)
grd.sp = as.SpatialPolygons.GridTopology(grdtop, proj4string = crs)

# grd.sgdf = SpatialGridDataFrame(
#   grid = grdtop, 
#   data = over(
#     gCentroid(grd.sp, byid = TRUE), portland.pd)
#   )
# grd.sgdf$I = 1:nrow(grd.sgdf)

cell.districts = data.table(over(gCentroid(grd.sp, byid = TRUE), portland.pd))[, I := .I]

# merge with feautures
crimes.grid.dt = cell.districts[, .(I, DISTRICT)][crimes.grid.dt, on='I']

# >>>>> check NAs in DISTRICT variable
par(mfrow=c(1,1), mar=c(3,3,3,3))
ii = crimes.grid.dt[is.na(DISTRICT), I]
print(paste('Number of NAs =', length(ii)))
plot(grd.sgdf[grd.sgdf$I %in% ii, 'I'])
plot(portland.pd, add=T)
plot(grd.sgdf[grd.sgdf$DISTRICT==890,])
crimes.grid.dt[is.na(DISTRICT), ]
plot(grd.sgdf[grd.sgdf$I %in% crimes.grid.dt[, unique(I)], 'I'])

# ============================================================================
# PROJECTION
# ============================================================================

#project -- these are the omega * xs
proj = crimes.grid.dt[ , cbind(x, y, week_no)] %*% 
  (matrix(rt(3L*features, df = 2.5), nrow = 3L)/c(lx, ly, lt))

#convert to data.table to use fwrite
incl = setNames(
  nm = setdiff(names(crimes.grid.dt), 
               c("I", "week_no", "x", "y", "value", "train"))
)
incl.kde = grep("^kde", incl, value = TRUE)
incl.cg = grep("^cg.", incl, value = TRUE)
incl.cd = grep("^cd.", incl, value = TRUE)

phi.dt =
  crimes.grid.dt[ , {
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
           l = paste0(I, "_", week_no, "|kdes")), 
      lapply(incl.kde, coln_to_vw),
      list(cg_namespace = if (length(incl.cg)) '|cgkde'),
      lapply(incl.cg, coln_to_vw),
      list(cd_namespace = '|cdkde'),
      lapply(incl.cd, coln_to_vw),
      list(pd_namespace = '|pd',
           pd = DISTRICT),
      list(lag_namespace = '|lgkde',
           kdel = coln_to_vw('lg.kde')),
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

# ============================================================================
# WRITE VW FILES
# ============================================================================
# 
#temporary files
source("local_setup.R")
train.vw = tempfile(tmpdir = tdir, pattern = "train")
test.vw = tempfile(tmpdir = tdir, pattern = "test")
#simply append .cache suffix to make it easier
#  to track association when debugging
cache = paste0(train.vw, '.cache')
pred.vw = tempfile(tmpdir = tdir, pattern = "predict")
fwrite(phi.dt[crimes.grid.dt$train], train.vw,
       sep = " ", quote = FALSE, col.names = FALSE,
       showProgress = FALSE)
fwrite(phi.dt[!crimes.grid.dt$train], test.vw,
       sep = " ", quote = FALSE, col.names = FALSE,
       showProgress = FALSE)

# #can eliminate all the testing data now that it's written
crimes.grid.dt = crimes.grid.dt[(!train)]
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
                    kde.bw, kde.n = 'all', kde.lags,
                    pei = numeric(n_var), pai = numeric(n_var))

#when we're at the minimum forecast area, we must round up
#  to be sure we don't undershoot; when at the max,
#  we must round down; otherwise, just round
# **TO DO: if we predict any boundary cells and are using the minimum
#          forecast area, WE'LL FALL BELOW IT WHEN WE CLIP TO PORTLAND **
which.round = function(x)
  if (x > 0) {if (x < 1) round else floor} else ceiling

n.cells = as.integer(which.round(alpha)(6969600*(1+2*alpha)/aa))

#Calculate PEI & PAI denominators here since they are the
#  same for all variations of tuning parameters,
#  given the input parameters (delx, etc.)
N_star = crimes.grid.dt[ , .(tot.crimes = sum(value)), by = I
                         ][order(-tot.crimes)[1L:n.cells],
                           sum(tot.crimes)]
NN = crimes.grid.dt[ , sum(value)]

for (ii in seq_len(nrow(tuning_variations))) {
  model = tempfile(tmpdir = tdir, pattern = "model")
  #train with VW
  with(tuning_variations[ii],
       system(paste(path_to_vw, '--loss_function poisson --l1', l1, '--l2', l2,
                    '--learning_rate', lambda,
                    '--decay_learning_rate', delta,
                    '--initial_t', T0, '--power_t', pp, train.vw,
                    '--cache_file', cache, '--passes 200 -f', model),
              ignore.stderr = TRUE))
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
    fread(pred.vw, sep = " ", header = FALSE, col.names = c("pred", "I_wk"))
  invisible(file.remove(pred.vw))
  #wrote 2-variable label with _ to fit VW guidelines;
  #  now split back to constituents so we can join
  preds[ , c("I", "week_no", "I_wk") :=
           c(lapply(tstrsplit(I_wk, split = "_"), as.integer),
             list(NULL))]

  crimes.grid.dt[preds, pred.count := exp(i.pred), on = c("I", "week_no")]
  rm(preds)

  hotspot.ids =
    crimes.grid.dt[ , .(tot.pred = sum(pred.count)), by = I
                    ][order(-tot.pred)[1L:n.cells], I]
  crimes.grid.dt[ , hotspot := I %in% hotspot.ids]

  #how well did we do? lower-case n in the PEI/PAI calculation
  nn = crimes.grid.dt[(hotspot), sum(value)]

  scores[ii, c('l1', 'l2', 'lambda', 'delta',
               't0', 'p', 'pei', 'pai') :=
           c(tuning_variations[ii],
             list(pei = nn/N_star,
                  #pre-calculated the total area of portland
                  pai = (nn/NN)/(aa*n.cells/4117777129)))]
}
invisible(file.remove(cache, test.vw))

# ============================================================================
# SCORES FOR KDE-ONLY
# ============================================================================
# add test values to kdes

# construct SpatialGridDataFrame
sgdf = SpatialGridDataFrame(grid = grdtop, data = kdes)

# kde hotspots
hotspot.ids.kde = kdes[order(-kde1)][1:n.cells, I]

# plot(sgdf[sgdf$I %in% hotspot.ids.kde,,'kde1'])
# plot(portland.bdy, add=T)

## compute scores
tot.crimes = crimes.grid.dt[(!train) , sum(value)]
hotspot.crimes = crimes.grid.dt[(!train) & I %in% hotspot.ids.kde, sum(value)]
pai.kde = (hotspot.crimes/tot.crimes)/(aa*n.cells/4117777129)

pei.kde = hotspot.crimes/crimes.grid.dt[ , .(tot.crimes = sum(value)), by = I
               ][order(-tot.crimes)[1L:n.cells],
                 sum(tot.crimes)]

# ============================================================================
# WRITE RESULTS FILE AND TIMINGS
# ============================================================================

ff = paste0("scores/", crime.type, "_", horizon, job_id, ".csv")
fwrite(scores, ff, append = file.exists(ff))

t1 = proc.time()["elapsed"]
ft = paste0("timings/", crime.type, "_", horizon, job_id, ".csv")
if (!file.exists(ft))
  cat("delx,dely,alpha,eta,lt,theta,k,kde.bw,kde.lags,time\n", sep = "", file = ft)
params = paste(delx, dely, alpha, eta, lt, theta, features,
               kde.bw, kde.lags, t1 - t0, sep = ",")
cat(params, "\n", sep = "", append = TRUE, file = ft)

# ============================================================================
# WRITE KDE BASELINE RESULTS
# ============================================================================

if (!dir.exists("kde_baselines/")) dir.create("kde_baselines/")

fk = paste0("kde_baselines/", crime.type, "_", horizon, job_id, ".csv")
if (!file.exists(fk)) 
  cat("delx,dely,alpha,theta,kde.bw,kde.lags,horizon,crime.type, pei,pai\n", 
      sep = "", file = fk)
params = paste(delx, dely, alpha, theta, kde.bw, kde.lags, horizon, crime.type,
               round(pei.kde, 3), round(pai.kde, 3) ,sep = ",")
print(params)
cat(params, "\n", sep = "", append = TRUE, file = fk)


