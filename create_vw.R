#!/usr/bin/env Rscript
# Forecasting Crime in Portland
# **     GPP Featurization      **
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
# cat("Setup...\t")
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
l1 = as.numeric(args[7L])
l2 = as.numeric(args[8L])
lambda = as.numeric(args[9L])
delta = as.numeric(args[10L])
t0.vw = as.numeric(args[11L])
pp = as.numeric(args[12L])
kde.bw = as.numeric(args[13L])
kde.n = as.integer(args[14L])
kde.lags = as.integer(args[15L])

#outer parameters
horizon = args[16L]
crime.type = args[17L]

#baselines for testing:
# delx=dely=600;alpha=0;eta=1.5;lt=4
# features=100;l1=1e-5;l2=1e-4;lambda=.5
# delta=1;t0.vw=0;pp=.5;
# kde.bw=1000;kde.n=7;kde.lags=6
# horizon='2m';crime.type='all'
# cat("**********************\n",
#     "* TEST PARAMETERS ON *\n",
#     "**********************\n")

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

# t1 = proc.time()["elapsed"]
# cat(sprintf("%3.0fs", t1 - t0), "\n")
# cat("Pixellate&Delete Cells...\t")
# t0 = proc.time()["elapsed"]
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

compute.kde <- function(pts) 
  spkernel2d(pts=pts, poly=portland.bdy.coords,
             h0=kde.bw, grd=grdtop, kernel='quartic')

pts.selection <- function (pts, month)
  # pick random days from given month. Return sp object.
  pts[with(pts@data, (idx <- month_no == month) & 
             day_no %in% sample(unique(day_no[idx]), kde.n)), ]

compute.kde.list <- function (pts, months = seq_len(kde.lags)) {
  # compute kde for each month, on a random pick of days.
  # return data.table, each col stores results for one month
  lapply(setNames(months, paste0('kde', months)),
         function(month) compute.kde(pts.selection(pts, month)))
}

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
# t1 = proc.time()["elapsed"]
# cat(sprintf("%3.0fs", t1 - t0), "\n")
# cat("Project...\t")
# t0 = proc.time()["elapsed"]
proj = crimes.grid.dt[ , cbind(x, y, week_no)] %*% 
  (matrix(rt(3L*features, df = 2.5), nrow = 3L)/c(lx, ly, lt))

# t1 = proc.time()["elapsed"]
# cat(sprintf("%3.0fs", t1 - t0), "\n")
# cat("Featurize cos...\t")
# t0 = proc.time()["elapsed"]

#convert to data.table to use fwrite
incl = setNames(
  nm = setdiff(names(crimes.grid.dt), 
               c("I", "week_no", "x", "y", "value", "train"))
)
phi.dt =
  crimes.grid.dt[ , c(list(v = value, l = paste0(I, "_", week_no, "|")), 
                      lapply(incl, function(vn) { 
                        V = get(vn)
                        oom = abs(round(mean(log10(V[V>0]))))
                        #scale up by roughly the median order of KDE magnitude
                        sprintf("%s:%.5f", vn, V*10^oom)
                      }))]

if (features > 500L) alloc.col(phi.dt, 3L*features)
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

# t1 = proc.time()["elapsed"]
# cat(sprintf("%3.0fs", t1 - t0), "\n")
# cat("VW Output...\n")
# t0 = proc.time()["elapsed"]

#temporary files
tdir = "delete_me"
train.vw = tempfile(tmpdir = tdir)
test.vw = tempfile(tmpdir = tdir)
cache = tempfile(tmpdir = tdir)
model = tempfile(tmpdir = tdir)
pred.vw = tempfile(tmpdir = tdir)

# cat("Training file:", train.vw,
#     "\nTesting file:", test.vw,
#     "\nCache:", cache,
#     "\nModel:", model,
#     "\nPredictions:", pred.vw, "\n")

fwrite(phi.dt[crimes.grid.dt$train], train.vw, 
       sep = " ", quote = FALSE, col.names = FALSE, 
       showProgress = FALSE)
fwrite(phi.dt[!crimes.grid.dt$train], test.vw, 
       sep = " ", quote = FALSE, col.names = FALSE,
       showProgress = FALSE)
rm(phi.dt)

## **TO DO: eliminate the cache purge once the system's
##          up and running properly**
if (file.exists(cache)) system(paste('rm', cache))
#train with VW
# t1 = proc.time()["elapsed"]
# cat("\n****************************\n",
#     "VW Output...\t", sprintf("%3.0fs", t1 - t0), "\n")
# cat("VW Training...\n")
# t0 = proc.time()["elapsed"]
system(paste('vw --loss_function poisson --l1', l1, '--l2', l2, 
             '--learning_rate', lambda,
             '--decay_learning_rate', delta,
             '--initial_t', t0.vw, '--power_t', pp, train.vw,
             '--cache_file', cache, '--passes 200 -f', model),
       ignore.stderr = TRUE)
invisible(file.remove(train.vw))
#test with VW
# t1 = proc.time()["elapsed"]
# cat("\n****************************\n",
#     "VW Training...\t", sprintf("%3.0fs", t1 - t0), "\n")
# cat("Test&Score&Delete...\t")
# t0 = proc.time()["elapsed"]

system(paste('vw -t -i', model, '-p', pred.vw, 
             test.vw, '--loss_function poisson'),
       ignore.stderr = TRUE)
invisible(file.remove(model, test.vw))

preds = fread(pred.vw, sep = " ", header = FALSE, col.names = c("pred", "I_wk"))
#wrote 2-variable label with _ to fit VW guidelines;
#  now split back to constituents so we can join
preds[ , c("I", "week_no", "I_wk") := 
         c(lapply(tstrsplit(I_wk, split = "_"), as.integer),
           list(NULL))]

crimes.grid.dt[preds, pred.count := exp(i.pred), on = c("I", "week_no")]
rm(preds)

#when we're at the minimum forecast area, we must round up
#  to be sure we don't undershoot; when at the max,
#  we must round down; otherwise, just round
# **TO DO: if we predict any boundary cells and are using the minimum
#          forecast area, WE'LL FALL BELOW IT WHEN WE CLIP TO PORTLAND **
which.round = function(x)
  if (x > 0) {if (x < 1) round else floor} else ceiling

n.cells = as.integer(which.round(alpha)(6969600*(1+2*alpha)/aa))

hotspot.ids =
  crimes.grid.dt[(!train), .(tot.pred = sum(pred.count)), by = I
                 ][order(-tot.pred)[1L:n.cells], I]
crimes.grid.dt[(!train), hotspot := I %in% hotspot.ids]

#how well did we do? lower-case n in the PEI/PAI calculation
nn = crimes.grid.dt[(hotspot), sum(value)]

pei = nn/crimes.grid.dt[(!train), .(tot.crimes = sum(value)), by = I
                        ][order(-tot.crimes)[1L:n.cells],
                          sum(tot.crimes)]
#rather than load the portland shapefile just to calculate
#  the total area, pre-do that here
pai = (nn/crimes.grid.dt[(!train), sum(value)])/(aa*n.cells/4117777129)

ff = paste0("scores/", crime.type, "_", horizon, ".csv")

if (!file.exists(ff)) 
  cat("delx,dely,alpha,eta,lt,k,l1,l2,",
      "lambda,delta,t0,p,kde.bw,kde.n,kde.lags,pei,pai\n", 
      sep = "", file = ff)

params = paste(delx, dely, alpha, eta, lt, features, l1, l2,
               lambda, delta, t0.vw, pp, kde.bw, 
               kde.n, kde.lags, pei, pai, sep = ",")
cat(params, "\n", sep = "", append = TRUE, file = ff)
invisible(file.remove(cache, pred.vw))

t1 = proc.time()["elapsed"]
ft = paste0("timings/", crime.type, "_", horizon, ".csv")
if (!file.exists(ft)) 
  cat("delx,dely,alpha,eta,lt,k,l1,l2,",
      "lambda,delta,t0,p,kde.bw,kde.n,kde.lags,time\n", sep = "", file = ft)
params = paste(delx, dely, alpha, eta, lt, features, l1, l2,
               lambda, delta, t0.vw, pp, kde.bw,
               kde.n, kde.lags, t1 - t0, sep = ",")
cat(params, "\n", sep = "", append = TRUE, file = ft)
# cat(sprintf("%3.0fs", t1 - t0), "\n")
