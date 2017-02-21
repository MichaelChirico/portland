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

# baselines for testing: 
delx=346;dely=776;alpha=0.549;eta=.905;lt=4.153;theta=0
features=345;kde.bw=424.32;kde.lags=6
crime.type='all';horizon='1w'
cat("**********************\n",
    "* TEST PARAMETERS ON *\n",
    "**********************\n")

aa = delx*dely #forecasted area
lx = eta*delx
ly = eta*dely
#What weeks cover the recent past data
#  and the furthest "future" date to forecast
## training period ends:
###  (week_no = 0 is March 1 - March 7, 2017)
week_0 = 52L
## note: perhaps confusingly, "left" endpoint is
##   later in time (since we count down weeks
##   to the forecasting period)
recent = week_0 + 
  c(switch(horizon, '1w' = 0, '2w' = -1L,
           '1m' = -4L, '2m' = -8L, '3m' = -12L), 26L)

#one "year" prior (+/- 2 weeks) includes which weeks?
lag.range = week_0 + 
  c(switch(horizon, '1w' = 54L, '2w' = 53L,
           '1m' = 50L, '2m' = 46L, '3m' = 42L), 80L)

get.crime.file = function(ct) {
  switch(ct, all = "crimes_all.csv",
         street = "crimes_str.csv",
         burglary = "crimes_bur.csv",
         vehicle = "crimes_veh.csv")
}

crime.file = get.crime.file(crime.type) 

crimes = fread(crime.file)
crimes[ , occ_date := as.IDate(occ_date)]
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

#boundary coordinates of portland
portland = 
  with(fread('data/portland_coords.csv'),
       rotate(x, y, theta, point0))

#record range here, so that
#  we have the same range 
#  after we subset below
#use full boundary range to be sure
#  we eventually cover the output polygon
xrng = range(portland[ , 1L])
yrng = range(portland[ , 2L])

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
    eps = c(delx, dely)))[idx.new]
    #find cells that ever have a crime
  )[value > 0, which = TRUE]

# create sp object of crimes
prj = CRS("+init=epsg:2913")
to.spdf = function(dt) {
  SpatialPointsDataFrame(
    coords = dt[ , cbind(x_coordina, y_coordina)],
    data = dt[ , -c('x_coordina', 'y_coordina')],
    proj4string = prj)
}
crimes.sp = to.spdf(crimes)

# trying to learn using only recent data 
#  and one-year lag for now
crimes = crimes[(week_no %between% lag.range) | (week_no %between% recent)]

# plot boundary
# par(mfrow=c(1,1))
# p = Polygon(rbind(portland, portland[1, ]))
# plot(SpatialPolygons(list(Polygons(list(p),c('1')))))

# ============================================================================
# CREATE DATA TABLE OF CRIMES
# aggregate at week-cell level
# ============================================================================

crimes.grid.dt = 
  crimes[week_no %between% recent, 
         as.data.table(pixellate(ppp(
           x = x_coordina, y = y_coordina,
           xrange = xrng, yrange = yrng, check = FALSE),
           #reorder using GridTopology - im mapping
           eps = c(delx, dely)))[idx.new],
         #subset to eliminate never-crime cells
         by = week_no][ , I := rowid(week_no)][I %in% incl_ids]

#can use this to split into train & test
crimes.grid.dt[ , train := week_no > week_0]

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

#always use months 12:(kde.lags + 1)
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
  fread('top_callgroups_by_crime.csv')[crime == crime.type, cg]

if (length(callgroup.top)) {
  crimes.cgroup = lapply(callgroup.top, function(cg) 
    crimes.sp[crimes.sp$call_group_type == cg, ])
  
  kdes.sub = setDT(sapply(crimes.cgroup, function(pts) 
    compute.kde.list(pts, months = 13L)))
  
  setnames(kdes.sub, paste0('cg.kde', seq_len(ncol(kdes.sub))))
  
  # combine normal kdes and sub-kdes
  kdes = cbind(kdes, kdes.sub)
}

# ============================================================================
# SUBCATEGORIES - CALL PRIORITIES
# ============================================================================

# select CASE_DESC cases as boolean vectors
cd.cases = with(crimes.sp@data,
                data.frame(
                  cd.kde1 = case_desc_type == 1L,
                  cd.kde2 = case_desc_type == 2L,
                  cd.kde3 = case_desc_type == 3L)
                )
#eliminate those which are not represented
cd.cases = cd.cases[sapply(cd.cases, any)]

# compute kdes for each CASE_DESC case selected
if (length(cd.cases)) {
   cd.kdes = setDT(lapply(cd.cases, function(cd) {
     spkernel2d(pts = crimes.sp[cd & crimes.sp$month_no %between% c(13L, 19L),],
                poly = portland, h0 = kde.bw, grd = grdtop)
    }))  
   kdes = cbind(kdes, cd.kdes)
}

# ============================================================================
# CROSS-CRIME KDES
# 1) load csv data for other crimes
# 2) turn into sp objects
# 3) compute KDEs
# ============================================================================

categories = c('all', 'street', 'burglary', 'vehicle')
other.crimes = setdiff(categories, crime.type)
other.crimes.files = sapply(other.crimes, get.crime.file)
other.crimes.dt = lapply(other.crimes.files, fread)
other.crimes.spdf = sapply(other.crimes.dt, to.spdf)
other.crimes.kdes = setDT(sapply(other.crimes.spdf, compute.kde.list))
setnames(other.crimes.kdes, gsub('V', 'xkde', names(other.crimes.kdes)))

kdes = cbind(kdes, other.crimes.kdes)

# add cell id
kdes[ , I := .I]

# append kdes to crimes data
crimes.grid.dt = kdes[crimes.grid.dt, on = 'I']

# ============================================================================
# YEAR-LAGGED KDES
# ============================================================================

# compute one year lag kdes for each cell-week
crimes.grid.dt[ , lg.kde := {
  kde = compute.lag(crimes.sp, .BY$week_no)
  idx = data.table(kde, I = seq_len(length(kde)))[.SD, on = 'I', which = TRUE]
  kde[idx]
}, by = week_no]

# ============================================================================
# POLICE DISTRICT DUMMY
# 1) load police districts shapefile
# 2) transfrom grid to SpatialPolygons
# 3) spatial overlay of the two objects using centroids of each cell
# ============================================================================
portland.pd = readShapePoly("./data/Portland_Police_Districts.shp", 
                            proj4string = prj)
  
# create SpatialPOlygonsDataFrame with grid
grd.sp = as.SpatialPolygons.GridTopology(grdtop, proj4string = prj)
poly.rownames = sapply(grd.sp@polygons, function(x) slot(x, 'ID'))
poly.df = data.frame(I = seq_len(prod(grdtop@cells.dim)), 
                     row.names = poly.rownames)
grd.spdf = SpatialPolygonsDataFrame(
  grd.sp,
  data = poly.df, match.ID = FALSE
)

# grd.sgdf = SpatialGridDataFrame(
#   grid = grdtop,
#   data = over(
#     gCentroid(grd.sp, byid = TRUE), portland.pd)
#   )
# grd.sgdf$I = 1:nrow(grd.sgdf)

# note: using centroids for the overlay means that
# some cells in the boundary of the city will have
# their centroids outside the boundary. To not get
# NA values for those we do a second round overlay
# for those cells without using centroids.
cell.districts = setDT(over(gCentroid(grd.spdf, byid = TRUE), portland.pd))[ , I := .I]
id.nas = cell.districts[is.na(DISTRICT), I]
cell.unmatched = grd.spdf[grd.spdf$I %in% id.nas, ]
cell.districts2 = setDT(over(cell.unmatched, portland.pd))[ , I := id.nas]
setkey(cell.districts, I)
cell.districts[cell.districts2$I, DISTRICT := cell.districts2$DISTRICT]

# merge with feautures
crimes.grid.dt[cell.districts, DISTRICT := i.DISTRICT, on = 'I']

# make up value for remaining NAs in DISTRICT (all in airport)
crimes.grid.dt[is.na(DISTRICT), DISTRICT := factor(0)]

# check NAs in DISTRICT variable
# par(mfrow=c(1,1), mar=c(3,3,3,3))
# ii = crimes.grid.dt[is.na(DISTRICT), I]
# print(paste('Number of NAs =', length(ii)))
# plot(grd.sgdf[grd.sgdf$I %in% ii, 'I'])
# plot(portland.pd, add=T)
# plot(grd.sgdf[grd.sgdf$DISTRICT==890,])
# crimes.grid.dt[is.na(DISTRICT), ]
# plot(grd.sgdf[grd.sgdf$I %in% crimes.grid.dt[, unique(I)], 'I'])

# ============================================================================
# PROJECTION
# ============================================================================

#project -- these are the omega * xs
proj = crimes.grid.dt[ , cbind(x, y, week_no)] %*% 
  (matrix(rt(3L*features, df = 2.5), nrow = 3L)/c(lx, ly, lt))

#convert to data.table to use fwrite
nms = setNames(nm = names(crimes.grid.dt))
incl.kde = grep("^kde", nms, value = TRUE)
incl.cg = grep("^cg.", nms, value = TRUE)
incl.cd = grep("^cd.", nms, value = TRUE)
incl.xkde = grep(paste('xkde', collapse = '|'), nms, value = TRUE)

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
      list(xk_namespace = '|xkde'),
      lapply(incl.xkde, coln_to_vw),
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

#6969600 ft^2 = .25 mi^2 (minimum forecast area);
#triple this is maximum forecast area
n.cells = as.integer(which.round(alpha)(6969600*(1+2*alpha)/aa))

#Calculate PEI & PAI denominators here since they are the
#  same for all variations of tuning parameters,
#  given the input parameters (delx, etc.)
N_star = crimes.grid.dt[ , .(tot.crimes = sum(value)), by = I
                         ][order(-tot.crimes)[1L:n.cells],
                           sum(tot.crimes)]
NN = crimes.grid.dt[ , sum(value)]


ns = c('kdes', 'cgkde', 'cdkde', 'pd', 'lgkde', 'xkde', 'rff')
tuning_variations = CJ(ig = ns,
                       l1 = c(1e-5, 1e-4, 1e-3,1e-2,1e-1),
                       l2=c(1e-5, 1e-4, 1e-3,1e-2,1e-1))
n_var = nrow(tuning_variations)

scores = copy(tuning_variations)[ , c('pei', 'pai') := NA_real_]

which.round = function(x)
  if (x > 0) {if (x < 1) round else floor} else ceiling

n.cells = as.integer(which.round(alpha)(6969600*(1+2*alpha)/aa))

N_star = crimes.grid.dt[ , .(tot.crimes = sum(value)), by = I
                         ][order(-tot.crimes)[1L:n.cells],
                           sum(tot.crimes)]
NN = crimes.grid.dt[ , sum(value)]

for (ii in seq_len(nrow(tuning_variations))) {
  model = tempfile(tmpdir = tdir, pattern = "model")
  with(tuning_variations[ii],
       system(paste(path_to_vw, '--ignore', ig,
               '--loss_function poisson --l1', l1, '--l2', l2,
               '--learning_rate', lambda,
               '--decay_learning_rate', delta,
               '--initial_t', T0, '--power_t', pp, train.vw,
               '--cache_file', cache, '--passes 200 -f', model),
         ignore.stderr = TRUE))
  system(paste(path_to_vw, '-t -i', model, '-p', pred.vw,
               test.vw, '--loss_function poisson'),
         ignore.stderr = TRUE)

  preds =
    fread(pred.vw, sep = " ", header = FALSE, col.names = c("pred", "I_wk"))
  preds[ , c("I", "week_no", "I_wk") :=
           c(lapply(tstrsplit(I_wk, split = "_"), as.integer),
             list(NULL))]

  crimes.grid.dt[preds, pred.count := exp(i.pred), on = c("I", "week_no")]

  hotspot.ids =
    crimes.grid.dt[ , .(tot.pred = sum(pred.count)), by = I
                    ][order(-tot.pred)[1L:n.cells], I]
  crimes.grid.dt[ , hotspot := I %in% hotspot.ids]

  nn = crimes.grid.dt[(hotspot), sum(value)]

  scores[ii, c('pei', 'pai') :=
           .(pei = nn/N_star,
             pai = (nn/NN)/(aa*n.cells/4117777129))]
}

scores[ , .SD[which.max(pei)], by = ig]
