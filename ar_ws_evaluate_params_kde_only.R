#!/usr/bin/env Rscript
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
suppressMessages({
  library(spatstat, quietly = TRUE)
  library(splancs, quietly = TRUE)
  library(rgeos)
  library(data.table, warn.conflicts = FALSE, quietly = TRUE)
  library(maptools)
})

#from random.org
set.seed(60251935)

if (grepl('comp', Sys.info()["nodename"]) & grepl('backup', getwd())) {
  setwd('/backup/portland')
} else if (grepl('comp', Sys.info()["nodename"]) & !grepl('backup', getwd())) {
  setwd('/home/ubuntu/scratch/portland')
}

#add/remove ! below to turn testing on/off
args = commandArgs(trailingOnly = TRUE)
if (!length(args)) {
  delx=600;dely=600;eta=1;lt=14;theta=0
  features=250;kde.bw=500;kde.lags=1;kde.win = 3
  horizon='1w';crime.type='burglary'#;alpha = 0
  cat("**********************\n",
      "* TEST PARAMETERS ON *\n",
      "**********************\n")
} else {
  # each argument read in as a string in a character vector;
  # would rather have them as a list. basically do
  # that by converting them to a form read.table
  # understands and then attaching from a data.frame
  args = read.table(text = paste(args, collapse = '\t'),
                    stringsAsFactors = FALSE)
  names(args) =
    c('delx', 'dely', #alpha,
      'eta', 'lt', 'theta', 'features', 'kde.bw', 
      'kde.lags', 'kde.win', 'crime.type', 'horizon')
  attach(args)
}

if (file.exists('ar-completed.csv')) {
  completed = as.data.frame(fread("ar-completed.csv"))
  if(nrow(completed[completed$crime == crime.type & 
                    completed$period == horizon & 
                    completed$delx == delx & 
                    completed$dely == dely & 
                    completed$eta == eta & 
                    completed$lt == lt & 
                    completed$theta == theta & 
                    completed$k == features & 
                    completed$kde.bw == kde.bw & 
                    completed$kde.lags == kde.lags & 
                    completed$kde.win == kde.win,]) > 0) {
    stop("already ran this one!")
  }
}

incl_mos = c(10L, 11L, 12L, 1L, 2L, 3L)

aa = delx*dely #forecasted area
lx = eta*250
ly = eta*250

crime.file = switch(crime.type,
                    all = "crimes_all.csv",
                    street = "crimes_str.csv",
                    burglary = "crimes_bur.csv",
                    vehicle = "crimes_veh.csv")

crimes = fread(crime.file)
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

# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>=
# CREATE DATA TABLE OF CRIMES ----
# 1) aggregate at lag.window level for included periods
# 2) aggregate at forecasting horizon level for included periods
# 3) merge previous results
# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>=

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

# how long is one period for this horizon?
pd_length = switch(horizon, 
                   '1w' = 7L, '2w' = 14L, '1m' = 31,
                   '2m' = 61L, '3m' = 92L) 
# how many periods are there in one year for this horizon?
one_year = switch(horizon, 
                  '1w' = 52L, '2w' = 26L, '1m' = 12L,
                  '2m' = 6L, '3m' = 4L)
# how many total periods are there in the data?
n_pds = 5L*one_year

crimes[ , occ_date_int := unclass(occ_date)]
unq_crimes = crimes[ , unique(occ_date_int)]

march117 = unclass(as.IDate('2017-03-01'))
#all period starts
start = march117 - (seq_len(n_pds) - 1L) * pd_length
#eliminate irrelevant (summer) data
start = start[month(as.IDate(start, origin = '1970-01-01')) %in% incl_mos & 
                start <= march117 - one_year*pd_length]
#all period ends
end = start + pd_length - 1L
#for feeding to foverlaps
windows = data.table(start, end, key = 'start,end')

crime_start_map = data.table(occ_date_int = unq_crimes)
crime_start_map[ , start_date := 
                   foverlaps(data.table(start = occ_date_int, 
                                        end = occ_date_int),
                             windows)$start]

crimes[crime_start_map, start_date := i.start_date,
       on = 'occ_date_int']

X = crimes[!is.na(start_date), as.data.table(pixellate(ppp(
  x = x_coordina, y = y_coordina,
  xrange = xrng, yrange = yrng, check = FALSE),
  #reorder using GridTopology - im mapping
  eps = c(x = delx, dely)))[idx.new],
  #subset to eliminate never-crime cells
  keyby = start_date][ , I := rowid(start_date)][I %in% incl_ids]

for (ii in 1:4) {
  test_start = march117 - ii * one_year*pd_length
  X[start_date <= test_start, 
    paste0('train_', 17 - ii) := start_date < test_start]
}

# create sp object of crimes
to.spdf = function(dt) {
  SpatialPointsDataFrame(
    coords = dt[ , cbind(x_coordina, y_coordina)],
    data = dt[ , -c('x_coordina', 'y_coordina')],
    proj4string = CRS("+init=epsg:2913"))
}
crimes.sp = to.spdf(crimes)
crimes.sp@data = setDT(crimes.sp@data)
#for faster indexing
setkey(crimes.sp@data, occ_date_int)

compute.kde <- function(pts, start, lag.no) {
  #subset using data.table for speed (?)
  idx = pts@data[occ_date_int %between% (start - kde.win*lag.no + c(0, kde.win - 1L)), which = TRUE]
  #if no crimes found, just return 0
  #  (spkernel2d handles this with varying degrees of success)
  if (!length(idx)) return(rep(0, length(incl_ids)))
  kde = spkernel2d(pts = pts[idx, ],
                   #quartic kernel used by default
                   poly = portland, h0 = kde.bw, grd = grdtop)[incl_ids]
}

# **TO DO: force one-year (one_year) lags into this
start_lag = CJ(start = start, lag = seq_len(kde.lags))

RHS = start_lag[, c(I = list(incl_ids),
                    lapply(setNames(lag, paste0('lag', lag)), compute.kde, 
                           pts = crimes.sp, start = .BY$start)),
                by = start]

# #investigate seasonality:
# R = cor(RHS[ , grep('lag', names(RHS)), with = FALSE])
# plot(R['lag1', ])

X = X[RHS, on = c(start_date = 'start', 'I')]

alpha_variations = seq(0, 1, length.out = 20)
train_variations = grep('^train', names(X), value = TRUE)

#when we're at the minimum forecast area, we must round up
#  to be sure we don't undershoot; when at the max,
#  we must round down; otherwise, just round
# **TO DO: if we predict any boundary cells and are using the minimum
#          forecast area, WE'LL FALL BELOW IT WHEN WE CLIP TO PORTLAND **
which.round = function(x)
  if (x > 0) {if (x < 1) round else floor} else ceiling

scores =
  CJ(train_set = train_variations,
     delx = delx, dely = dely,
     alpha = alpha_variations,
     theta = theta, kde.bw = kde.bw,
     kde.win = kde.win, pei = 0, pai = 0)

setkey(scores, train_set, alpha)

#loop over using each year's holdout test set to calculate PEI/PAI
for (train in train_variations) {
  cat(train, '\n')
  test_idx = !X[[train]]
  
  #Calculate PAI denominators here since it is the
  #  same for all variations of tuning parameters,
  #  given the input parameters (delx, etc.)
  NN = X[test_idx, sum(value)]
  
  X[X[test_idx, .(tot.pred = sum(lag1)), keyby = I
      # \/ should have done / should do
      #][ , .(I, rank = frank(-tot.pred, ties.method = 'random'))],
      ][order(-tot.pred), .(I, rank = .I)],
    rank := i.rank, on = 'I']
  
  X[X[test_idx, .(tot.crimes = sum(value)), by = I
      ][order(-tot.crimes), .(I, true_rank = .I)],
    true_rank := i.true_rank, on = 'I']
  
  ##** TO DO : this loop can probably be vectorized better**
  for (AA in alpha_variations) {
    #6969600 ft^2 = .25 mi^2 (minimum forecast area);
    #triple this is maximum forecast area
    n.cells = as.integer(which.round(AA)(6969600*(1+2*AA)/aa))
    #n.cells = as.integer(ceiling(6969600/aa))
    
    #how well did we do? lower-case n in the PEI/PAI calculation
    nn = X[rank <= n.cells & test_idx, sum(value)]
    N_star = X[true_rank <= n.cells & test_idx, sum(value)]
    
    scores[.(train, AA), c('pei', 'pai') :=
             #pre-calculated the total area of portland
             .(nn/N_star, pai = (nn/NN)/(aa*n.cells/4117777129))]
  }
  #reset ranking for next run
  X[ , rank := NULL]
}

# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
# WRITE RESULTS FILE AND TIMINGS
# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

if (!exists("job_id")) job_id = sample(100, 1)
ff = paste0("scores/", 'ar_ws_kde_only_my_',
            crime.type, "_", horizon, job_id, ".csv")
fwrite(scores, ff, append = file.exists(ff))
