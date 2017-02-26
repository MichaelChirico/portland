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
  library(maptools)
})

#from random.org
set.seed(60251935)

if (grepl('comp', Sys.info()["nodename"]) & grepl('backup', getwd())) {
  setwd('/backup/portland')
} else if (grepl('comp', Sys.info()["nodename"]) & !grepl('backup', getwd())) {
  setwd('/home/ubuntu/scratch/portland')
}


# each argument read in as a string in a character vector;
 # would rather have them as a list. basically do
 # that by converting them to a form read.table
 # understands and then attaching from a data.frame
args = read.table(text = paste(commandArgs(trailingOnly = TRUE),
                               collapse = '\t'),
                  stringsAsFactors = FALSE)
names(args) =
  c('delx', 'dely', 'eta', 'lt', 'theta',
    'features', 'kde.bw', 'kde.lags', 'kde.win', 'crime.type', 'horizon')
attach(args)

# # baselines for testing:
delx=600;dely=600;eta=1;lt=1;theta=0
features=5;kde.bw=125;kde.lags=2;kde.win = 2
horizon='3m';crime.type='burglary'
cat("**********************\n",
    "* TEST PARAMETERS ON *\n",
    "**********************\n")

#turn me on/off to control LHS trimming
trimLHS = TRUE
if (trimLHS) 
  incl_mos = c(10L, 11L, 12L, 1L, 2L, 3L,
               if (horizon %in% c('2m', '3m')) 4L,
               if (horizon == '3m') 5L)

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

# aggregate, cell counts
pd_length = switch(horizon, 
                   '1w' = 7L, '2w' = 14L, '1m' = 31,
                   '2m' = 61L, '3m' = 92L) 
one_year = switch(horizon, 
                  '1w' = 52L, '2w' = 26L, '1m' = 12L,
                  '2m' = 6L, '3m' = 4L)
n_pds = 4L*one_year

crimes[ , occ_date_int := unclass(occ_date)]
unq_crimes = crimes[ , unique(occ_date_int)]

march117 = unclass(as.IDate('2017-03-01'))
start = march117 - one_year*pd_length - (seq_len(n_pds) - 1L) * pd_length
end = start + pd_length - 1L
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

if (trimLHS) {
  X = X[month(as.IDate(start_date, origin = '1970-01-01')) %in% incl_mos]
  start = X[ , unique(start_date)]
}

X[ , train := start_date < march117 - one_year*pd_length]

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

# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
# PROJECTION ----
# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

#project -- these are the omega * xs
proj = X[ , cbind(x, y, start_date)] %*% 
  (matrix(rt(3L*features, df = 2.5), nrow = 3L)/c(lx, ly, lt))

#convert to data.table to use fwrite
incl = setNames(nm = names(X))
incl.kde = grep("^lag", incl, value = TRUE)

# check for NAs in the features
stopifnot(all(!is.na(X)))

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
           l = paste0(I, "_", start_date, "|kdes")), 
      lapply(incl.kde, coln_to_vw),
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
filename = paste('arws',crime.type,horizon,delx,dely,eta,lt,theta,features,kde.bw,kde.lags,kde.win,sep = '_')
filename = paste(filename, job_id, sep='_')
train.vw = paste(paste0(tdir,'/train'), filename, sep='_')
test.vw = paste(paste0(tdir,'/test'), filename, sep='_')
# train.vw = tempfile(tmpdir = tdir, pattern = "train")
# test.vw = tempfile(tmpdir = tdir, pattern = "test")
#simply append .cache suffix to make it easier
#  to track association when debugging
cache = paste0(train.vw, '.cache')
# pred.vw = tempfile(tmpdir = tdir, pattern = "predict")
pred.vw = paste(paste0(tdir,'/pred'), filename, sep='_')
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
  data.table(l1 = c(1e-6, 1e-4, 1e-3, 5e-3, rep(1e-5, 11L)),
             l2 = c(rep(1e-4, 4L), 1e-6, 5e-6,
                    1e-5, 5e-5, 5e-4, rep(1e-4, 6L)),
             pp = c(rep(.5, 9L), .25, .33, .5,
                    .66, .75, 1))
n_var = nrow(tuning_variations)

#initialize parameter records table
scores = data.table(delx, dely, eta, lt, theta, k = features,
                    l1 = numeric(n_var), l2 = numeric(n_var),
                    p = numeric(n_var), kde.bw, kde.n = 'all', 
                    kde.lags, kde.win,
                    pei = numeric(n_var), pai = numeric(n_var))

#6969600 ft^2 = .25 mi^2 (minimum forecast area);
#triple this is maximum forecast area
n.cells = as.integer(ceiling(6969600/aa))

#Calculate PEI & PAI denominators here since they are the
#  same for all variations of tuning parameters,
#  given the input parameters (delx, etc.)
N_star = X[ , .(tot.crimes = sum(value)), by = I
            ][order(-tot.crimes)[1L:n.cells],
              sum(tot.crimes)]
NN = X[ , sum(value)]

# initialize dt to store prediction of each tuning_variation
preds.dt = data.table(I=X[, unique(I)])

for (ii in seq_len(nrow(tuning_variations))) {
  # print(ii)
  model = tempfile(tmpdir = tdir, pattern = "model")
  #train with VW
  call.vw = with(tuning_variations[ii],
                 paste(path_to_vw, '--loss_function poisson --l1', l1, 
                       '--l2', l2, '--power_t', pp, train.vw,
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
    fread(pred.vw, sep = " ", header = FALSE, col.names = c("pred", "I_start"))
  invisible(file.remove(pred.vw))
  #wrote 2-variable label with _ to fit VW guidelines;
  #  now split back to constituents so we can join
  preds[ , c("I", "start_date", "I_start") :=
           c(lapply(tstrsplit(I_start, split = "_"), as.integer),
             list(NULL))]
  
  preds.dt[preds, (paste0('tun',ii)) := exp(i.pred), on='I']
  
  X[preds, pred.count := exp(i.pred), on = c("I", "start_date")]
  # rm(preds)
  
  hotspot.ids =
    X[ , .(tot.pred = sum(pred.count)), by = I
       ][order(-tot.pred)[1L:n.cells], I]
  X[ , hotspot := I %in% hotspot.ids]
  
  #how well did we do? lower-case n in the PEI/PAI calculation
  nn = X[(hotspot), sum(value)]
  
  scores[ii, c('l1', 'l2', 'p', 'pei', 'pai') :=
           c(tuning_variations[ii],
             list(pei = nn/N_star,
                  #pre-calculated the total area of portland
                  pai = (nn/NN)/(aa*n.cells/4117777129)))]
}
invisible(file.remove(cache, test.vw))

# sgdf = SpatialGridDataFrame(grdtop, 
#    data = kde[.(2016,1)])
# plot(sgdf[sgdf$I %in% hotspot.ids,,'value'])

# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
# COMPUTE MSE  ====
# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

# merge actual counts with predictions
preds.dt[X, value := i.value, on='I']

# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
# PRINT SCORES TO STDOUT  ====
# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

best_scores = unlist(scores[order(-pai)[1]], use.names = FALSE)
best_scores = paste(best_scores, collapse = '/')
best_scores = paste0('[[[',best_scores,']]]')
print(best_scores)

# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
# WRITE RESULTS FILE AND TIMINGS
# <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

ff = paste0("scores/", 'ar_',crime.type, "_", horizon, job_id, ".csv")
fwrite(scores, ff, append = file.exists(ff))

t1 = proc.time()["elapsed"]
ft = paste0("timings/", crime.type, "_", horizon, job_id, ".csv")
if (!file.exists(ft))
  cat("delx,dely,eta,lt,theta,k,kde.bw,kde.lags,kde.win,time\n", sep = "", file = ft)
params = paste(delx, dely, eta, lt, theta, features,
               kde.bw, kde.lags, kde.win, t1 - t0, sep = ",")
cat(params, "\n", sep = "", append = TRUE, file = ft)


