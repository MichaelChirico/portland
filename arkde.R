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

#each argument read in as a string in a character vector;
#  would rather have them as a list. basically do
#  that by converting them to a form read.table
#  understands and then attaching from a data.frame
# args = read.table(text = paste(commandArgs(trailingOnly = TRUE), 
#                                collapse = '\t'),
#                   stringsAsFactors = FALSE)
# names(args) = 
#   c('delx', 'dely', 'alpha', 'eta', 'lt', 'theta',
#     'features', 'kde.bw', 'kde.lags', 'crime.type', 'horizon')
# attach(args)

# baselines for testing: 
delx=dely=600;alpha=0;eta=1;lt=1;theta=0
features=2;kde.bw=400;kde.lags=3;kde.win = 7
horizon='2w';crime.type='all'
cat("**********************\n",
    "* TEST PARAMETERS ON *\n",
    "**********************\n")

aa = delx*dely #forecasted area
lx = eta*delx
ly = eta*dely
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
setnames(crimes, 'week_no', 't')
crimes[ , occ_date := as.IDate(occ_date)]

# ============================================================================
# ROTATION
# ============================================================================

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

# ============================================================================
# CREATE GRID
# ============================================================================

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

# ============================================================================
# CREATE DATA TABLE OF CRIMES
# 1) aggregate at lag.window level for included periods
# 2) aggregate at forecasting horizon level for included periods
# 3) merge previous results
# ============================================================================

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

# set of dates for LHS
march1s = crimes[month(occ_date)==3 & mday(occ_date)==1, unique(occ_date)]
march1s = rev(c(march1s, as.IDate('2017-03-01')))
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

# ============================================================================
# KDE LAGS
# ============================================================================

# generate lag ids
ldays = lag.days(kde.win, kde.lags)
for (lag in seq_along(ldays)){
  crimes[day_no %in% ldays[[lag]], lag_no := lag]
}

# create spatial points
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

kde = crimes[!is.na(lag_no), .(value = compute.kde(to.spdf(.SD))), by = .(occ_year, lag_no)]
setkey(kde, occ_year, lag_no)
kde[, I := rowid(occ_year, lag_no)]
# plot(SpatialGridDataFrame(grdtop, kde[.(2016, 3), 'kde']))

lag_names = paste('kde', 1:kde.lags, sep = '.')
for (llag in seq_along(lag_names)){
  X[, lag_names[[llag]] := kde[.(.BY$HH, llag), value], by=HH]
}
# plot(SpatialGridDataFrame(grdtop, X[HH==2013, 'kde.3']))

# remove cells outside border
X = X[!is.na(kde.1)]

spdf = SpatialGridDataFrame(grdtop, X[HH==2016, .(kde.1, I)])
X[is.na(kde.1), mean(!is.na(kde.3))]
nas = X[HH==2016 & is.na(kde.1), I]
X[I %in% nas, mean(is.na(kde.1))]
plot(spdf[, , 'kde.1'])
plot(spdf[spdf$I %in% nas,'I'])
mean(is.na(spdf[spdf$I %in% nas, ,'kde.1']$kde.1))


# ============================================================================
# PROJECTION
# ============================================================================

#project -- these are the omega * xs
proj = X[ , cbind(x, y, week_no)] %*% 
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

X[, length(unique(I))]




