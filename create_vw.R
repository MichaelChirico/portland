#!/usr/bin/env Rscript
# Forecasting Crime in Portland
# **     GPP Featurization      **
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
job_id = Sys.getenv("SLURM_JOB_ID")

t0 = proc.time()["elapsed"]
suppressMessages({
  #library(rgdal)
  library(spatstat, quietly = TRUE)
  library(splancs, quietly = TRUE)
  library(rgeos)
  #data.table after spatstat to
  #  access data.table::shift more easily
  library(data.table, warn.conflicts = FALSE, quietly = TRUE)
  library(foreach)
  library(maptools)
})

#from random.org
set.seed(60251935)

#inner parameters
args = commandArgs(trailingOnly = TRUE)
delx = as.integer(args[1L])
dely = as.integer(args[2L])
alpha = as.numeric(args[3L])
eta = as.numeric(args[4L])
lt = as.numeric(args[5L])
features = as.integer(args[6L])
kde.bw = as.numeric(args[7L])
kde.lags = as.integer(args[8L])

#outer parameters
crime.type = args[9L]
horizon = args[10L]

# baselines for testing:
#delx=dely=600;alpha=0;eta=1.5;lt=4
#features=10;kde.bw=1000;kde.lags=6
#horizon='2m';crime.type='all'
#cat("**********************\n",
#    "* TEST PARAMETERS ON *\n",
#    "**********************\n")

aa = delx*dely #forecasted area
lx = eta*delx
ly = eta*dely
end.date = 
  as.IDate(switch(
    horizon, '1w' = '2016-03-06', '2w' = '2016-03-13',
    '1m' = '2016-03-31', '2m' = '2016-04-30', '3m' = '2016-05-21'
  ))

crime.file = switch(crime.type,
                    all = "crimes_all.csv",
                    street = "crimes_str.csv",
                    burglary = "crimes_bur.csv",
                    vehicle = "crimes_veh.csv")

crimes = fread(crime.file)
crimes[ , occ_date := as.IDate(occ_date)]
# trying to learn using only recent data for now
crimes = crimes[occ_date >= '2015-09-01']

#record range here, so that
#  we have the same range 
#  after we subset below
xrng = crimes[ , range(x_coordina)]
yrng = crimes[ , range(y_coordina)]

# ============================================================================
# GRID TOPOLOGY
# Used to compute KDEs
# Also create idx to rearrange order of pixellate objects so they conform with
# GT objects
# ============================================================================
# from pixel image create GridTopology
pix <- crimes[occ_date <= end.date,
              pixellate(
                ppp(x=x_coordina, y=y_coordina, 
                    xrange=xrng, yrange=yrng, check=FALSE),
                eps=c(x=delx, dely)
                )]
grdtop <- as(as.SpatialGridDataFrame.im(pix), "GridTopology")

# create sp object of crimes
prj = CRS("+init=epsg:2913")
crimes.sp = with(crimes,
                 SpatialPointsDataFrame(
                    coords = cbind(x_coordina, y_coordina),
                    data = crimes[, -c('x_coordina','y_coordina'), with=FALSE],
                    proj4string = prj))

# load  portland boundary
# crimes.sp <- readOGR(dsn='data/combined', layer=crime.shapefile, verbose=FALSE)
portland.bdy <- gBuffer(
  #need rgdal; use readShapePoly for now
  #readOGR(dsn='data', layer='portland_boundary', verbose=FALSE), width = 500
  readShapePoly("data/portland_boundary", proj4string = prj), width = 500
)
portland.bdy.coords <- portland.bdy@polygons[[1L]]@Polygons[[1L]]@coords

getGTindices <- function(gt) {
  # Obtain indices to rearange data from image (eg. result frim pixellate)
  # so that it conforms with data from GridTopology objects (eg. results
  # from using spkernel2d).
  # Input: gt is a grid topology.
  # Returns an index.
  dimx <- gt@cells.dim[1L]
  dimy <- gt@cells.dim[2L]
  c(matrix(1L:(dimx*dimy), ncol = dimy, byrow = TRUE)[ , dimy:1L])
}

# index to rearange rows in pixellate objects
idx.new <- getGTindices(grdtop)

# ============================================================================
# CREATE DATA TABLE OF CRIMES
# aggregate at week-cell level
# ============================================================================

#Per here, these are always sorted by x,y:
#  https://github.com/spatstat/spatstat/issues/37
incl_ids = 
  with(crimes, setDT(as.data.frame(pixellate(ppp(
    #pixellate counts dots over each cell,
    #  and appears to do so pretty quickly
    x = x_coordina, y = y_coordina,
    xrange = xrng, yrange = yrng, check = FALSE),
    #this must be done within-loop
    #  since it depends on delx & dely
    eps = c(delx, dely)))[idx.new, ])
    #find cells that ever have a crime
  )[value > 0, which = TRUE]

crimes.grid.dt = 
  crimes[occ_date <= end.date, 
         as.data.table(pixellate(ppp(
           x = x_coordina, y = y_coordina,
           xrange = xrng, yrange = yrng, check = FALSE),
           eps = c(x = delx, dely)))[idx.new,],
         #subset to eliminate never-crime cells
         by = week_no][ , I := rowid(week_no)][I %in% incl_ids]

#can use this to split into train & test
crimes.grid.dt[ , train := week_no > 0L]

# ============================================================================
# KDEs
# ============================================================================

compute.kde <- function(pts, month) 
  spkernel2d(pts=pts[pts$month_no == month, ],
             poly=portland.bdy.coords,
             h0=kde.bw, grd=grdtop, kernel='quartic')

compute.kde.list <- function (pts, months = seq_len(kde.lags)) 
  # compute kde for each month, on a random pick of days.
  # return data.table, each col stores results for one month
  lapply(setNames(months, paste0('kde', months)),
         function(month) compute.kde(pts, month))

kdes = setDT(compute.kde.list(crimes.sp))

# # check for NAs
# kdes[, I:=.I]
# sgdf <- SpatialGridDataFrame(grid = grdtop, kdes)
# x = as.data.table(sgdf)[crimes.grid.dt, on='I'] # sanity check
# x[, .(x,s1,y,s2)]
# xna = x[is.na(kde1),]
# plot(sgdf[sgdf$I %in% xna$I, 'I'])
# plot(portland.bdy, add=T)
# xx = x[!is.na(kde1)]

# ============================================================================
# SUBCATEGORIES - CALLGROUPS
# Compute KDE for last mont for top three callgroups
# ============================================================================

# pick largest call groups
callgroup.top = 
  crimes[, .N, by=CALL_GROUP
         #all but 'all' have 2 or fewer call groups;
         #  include at most N-1 of them to avoid collinearity
         ][order(-N), if (.N > 1) CALL_GROUP[1L:min(3L, .N - 1L)]]
if (!is.null(callgroup.top)) {
  crimes.cgroup = lapply(callgroup.top, function(cg) 
    crimes.sp[crimes.sp$CALL_GROUP == cg,])
  kdes.sub = setDT(sapply(crimes.cgroup, function(pts) 
    compute.kde.list(pts, months=1L)))
  setnames(kdes.sub, paste0('cg.kde', 1L:ncol(kdes.sub)))
  
  # combine normal kdes and sub-kdes
  kdes = cbind(kdes, kdes.sub)
}

# add cell id
kdes[, I := .I]

# append kdes
crimes.grid.dt <- kdes[crimes.grid.dt, on='I']

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
phi.dt =
  crimes.grid.dt[ , c(list(v = value, l = paste0(I, "_", week_no, "|")), 
                      lapply(incl, function(vn) { 
                        V = get(vn)
                        val = V * 10^(abs(round(mean(log10(V[V>0])))))
                        if (any(is.nan(val)))
                            stop('NaNs detected! Current parameters:',
                                 paste(args, collapse = '/'))
                        #scale up by roughly the median order of KDE magnitude
                        sprintf("%s:%.5f", vn, val)
                      }))]

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

# add namespaces
phi.dt[, `:=`(l = paste0(l,'kdes'),
           cos1 = paste('|rff', cos1))]


# ============================================================================
# WRITE VW FILES
# ============================================================================

#temporary files
tdir = "/data/localhost/not-backed-up/flaxman"

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
#can eliminate all the testing data now that it's written
crimes.grid.dt = crimes.grid.dt[(!train)]
rm(phi.dt)


#initialize parameter records table
scores = NULL
#data.table(delx, dely, alpha, eta, lt, k = features,
#                    l1 = numeric(n_var), l2 = numeric(n_var),
#                    lambda = numeric(n_var), delta = numeric(n_var),
#                    t0 = numeric(n_var), p = numeric(n_var),
#                    kde.bw, kde.n = 'all', kde.lags,
#                    pei = numeric(n_var), pai = numeric(n_var))

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

for(l1 in c(1e-6, 1e-5, 1e-4, 1e-3, 5e-3, 1e-2, 5e-2, 1e-1, 5e-1,0 )) {
    for(l2 in c(1e-6, 1e-5, 1e-4, 1e-3, 5e-3, 1e-2, 5e-2, 1e-1, 5e-1, 0)) {
  model = tempfile(tmpdir = tdir, pattern = "model")
  #train with VW
       system(paste('./vw --ignore r --loss_function poisson --l1', l1, '--l2', l2,
                    train.vw,
                    '--cache_file', cache, '--passes 200 -f', model),
              ignore.stderr = F)
  #training data now stored in cache format,
  #  so can delete original (don't need to, but this is a useful
  #  check to force an error if s.t. wrong with cache)
  if (file.exists(train.vw)) invisible(file.remove(train.vw))
  #test with VW
  system(paste('./vw --ignore r -t -i', model, '-p', pred.vw,
               test.vw, '--loss_function poisson'),
         ignore.stderr = F)
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
  
  scores = rbind(scores,
           data.frame(l1=l1,l2=l2,pei = nn/N_star, 
                  #pre-calculated the total area of portland
                  pai = (nn/NN)/(aa*n.cells/4117777129)))
}
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
tot.crimes = crimes.grid.dt[ , sum(value)]
hotspot.crimes = crimes.grid.dt[I %in% hotspot.ids.kde, sum(value)]
pai.kde = (hotspot.crimes/tot.crimes)/(aa*n.cells/4117777129)

pei.kde = hotspot.crimes/crimes.grid.dt[ , .(tot.crimes = sum(value)), by = I
               ][order(-tot.crimes)[1L:n.cells],
                 sum(tot.crimes)]

# ============================================================================
# WRITE RESULTS FILE AND TIMINGS
# ============================================================================

ff = paste0("scores/", crime.type, "_", horizon, "_", job_id, ".csv")

fwrite(scores, ff, append = file.exists(ff))

t1 = proc.time()["elapsed"]
ft = paste0("timings/", crime.type, "_", horizon, "_", job_id, ".csv")
if (!file.exists(ft)) 
  cat("delx,dely,alpha,eta,lt,k,kde.bw,kde.lags,time\n", sep = "", file = ft)
params = paste(delx, dely, alpha, eta, lt, features, 
               kde.bw, kde.lags, t1 - t0, sep = ",")
cat(params, "\n", sep = "", append = TRUE, file = ft)

# ============================================================================
# WRITE KDE BASELINE RESULTS
# ============================================================================

if (!dir.exists("/data/ziz/flaxman/kde_baselines/")) dir.create("/data/ziz/flaxman/kde_baselines/")

fk = paste0("/data/ziz/flaxman/kde_baselines/", crime.type, "_", horizon, "_", job_id, ".csv")
if (!file.exists(fk)) 
  cat("delx,dely,alpha,kde.bw,kde.lags,horizon,crime.type, pei,pai\n", 
      sep = "", file = fk)
params = paste(delx, dely, alpha, kde.bw, kde.lags, horizon, crime.type,
               round(pei.kde, 3), round(pai.kde, 3) ,sep = ",")
cat(params, "\n", sep = "", append = TRUE, file = fk)
