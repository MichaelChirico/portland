#!/usr/bin/env Rscript
# Forecasting Crime in Portland
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
library(spatstat)
library(splancs)
library(rgeos)
library(rgdal)
library(data.table)
library(foreach)
library(maptools)
library(zoo)

source('utils.R')

#make sure we use the same seed
#  as evaluation_params.R
set.seed(60251935)

args = 
  read.table(text = paste(commandArgs(trailingOnly = TRUE), collapse = '\t'),
             sep = '\t', stringsAsFactors = FALSE)
names(args) = c('delx', 'dely', 'alpha', 'eta', 'lt', 'theta',
                'features', 'kde.bw', 'kde.lags', 'l1', 'l2',
                'crime.type', 'horizon', 'start')
attach(args)

# baselines for testing:
delx=250;dely=250;alpha=.95;eta=3;lt=7;theta=0
features=2;kde.bw=250;kde.lags=6;kde.win=10;l1=0;l2=0
crime.type='burglary';horizon='1w';start=20170308
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

crime.file = switch(crime.type,
                    all = "crimes_all.csv",
                    street = "crimes_str.csv",
                    burglary = "crimes_bur.csv",
                    vehicle = "crimes_veh.csv")

crimes = fread(crime.file)
crimes[ , occ_date := as.IDate(occ_date)]

point0 = crimes[ , c(min(x_coordina), min(y_coordina))]
crimes[ , paste0(c('x', 'y'), '_coordina') :=
          as.data.table(rotate(x_coordina, y_coordina, theta, point0))]

portland_r = 
  with(fread('data/portland_coords.csv'),
       rotate(x, y, theta, point0))

xrng = range(portland_r[ , 1L])
yrng = range(portland_r[ , 2L])

grdtop <- as(as.SpatialGridDataFrame.im(
  pixellate(ppp(xrange=xrng, yrange=yrng), eps=c(delx, dely))), "GridTopology")
grdSPDF = SpatialPolygonsDataFrame(
  as.SpatialPolygons.GridTopology(grdtop, proj4string = prj),
  data = data.frame(I = seq_len(prod(grdtop@cells.dim)),
                    row.names = sprintf('g%d', seq_len(prod(grdtop@cells.dim)))), 
  match.ID = FALSE
)

idx.new <- getGTindices(grdtop)

incl_ids =
  with(crimes[occ_date < start], as.data.table(pixellate(ppp(
    x = x_coordina, y = y_coordina,
    xrange = xrng, yrange = yrng, check = FALSE),
    eps = c(delx, dely)))[idx.new, ]
  )[value > 0, which = TRUE]

#join some missing crimes from unseen dates
fake_crimes = 
  data.table(week_no = c(seq_rng(lag.range),
                         seq_rng(recent)))
crimes = crimes[fake_crimes, on = 'week_no']
#crimes.sp throws a hissy fit if fed NA coordinates
real_crimes = crimes[!is.na(x_coordina), which = TRUE]

#while we don't have the full data set, we're missing
#  data from the end of February -- to avoid this
#  mucking up the test process, we'll pad the
#  current data with each cell's ancestor
pad = crimes[is.na(x_coordina) & week_no > 0, 
             week_no + 52L]

crimes.sp =
  SpatialPointsDataFrame(
    coords = crimes[(real_crimes), cbind(x_coordina, y_coordina)],
    data = crimes[(real_crimes), -c('x_coordina', 'y_coordina')],
    proj4string = prj
  )

crimes.grid.dt =
  crimes[week_no %between% recent, 
         as.data.table(pixellate(ppp(
           x = x_coordina, y = y_coordina,
           xrange = xrng, yrange = yrng, check = FALSE),
           eps = c(delx, dely)))[idx.new],
         by = week_no][ , I := rowid(week_no)][I %in% incl_ids]

#if we have full data, this step will do nothing
crimes.pad = 
  crimes[week_no %in% pad,
         as.data.table(pixellate(ppp(
           x = x_coordina, y = y_coordina,
           xrange = xrng, yrange = yrng, check = FALSE),
           eps = c(delx, dely)))[idx.new],
         by = .(week_no = week_no - 52L)
         ][ , I := rowid(week_no)][I %in% incl_ids]
crimes.grid.dt[crimes.pad, value := i.value, on = c('week_no', 'I')]

compute.kde <- function(pts, month)
  spkernel2d(pts = pts[pts$month_no == month, ],
             poly = portland_r, h0 = kde.bw, grd = grdtop)

compute.lag = function(pts, week_no)
  spkernel2d(pts = pts[pts$week_no %between%
                         (week_no + c(50L, 54L)), ],
             poly = portland_r, h0 = kde.bw, grd = grdtop)

compute.kde.list <- function (pts, months = seq_len(kde.lags) + 12L)
  lapply(setNames(months, paste0('kde', months)),
         function(month) compute.kde(pts, month))

kdes = setDT(compute.kde.list(crimes.sp))

## **TO DO: deal with this properly
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

kdes[ , I := .I]

crimes.grid.dt = kdes[crimes.grid.dt, on = 'I']

crimes.grid.dt[ , lg.kde := {
  kde = compute.lag(crimes.sp, .BY$week_no)
  idx = data.table(kde, I = seq_len(length(kde)))[.SD, on = 'I', which = TRUE]
  kde[idx]
}, by = week_no]

crimes.grid.dt[ , train := week_no > week_0]

proj = crimes.grid.dt[ , cbind(x, y, week_no)] %*%
  (matrix(rt(3L*features, df = 2.5), nrow = 3L)/c(lx, ly, lt))

nms = setNames(nm = names(crimes.grid.dt))
incl.kde = grep("^kde", nms, value = TRUE)
incl.cg = grep("^cg.", nms, value = TRUE)

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
cache = paste0(train.vw, '.cache')
pred.vw = tempfile(tmpdir = tdir, pattern = "predict")
fwrite(phi.dt[crimes.grid.dt$train], train.vw,
       sep = " ", quote = FALSE, col.names = FALSE,
       showProgress = FALSE)
fwrite(phi.dt[!crimes.grid.dt$train], test.vw,
       sep = " ", quote = FALSE, col.names = FALSE,
       showProgress = FALSE)

crimes.grid.dt = crimes.grid.dt[(!train)]
rm(phi.dt)

n.cells = as.integer(which.round(alpha)(6969600*(1+2*alpha)/aa))

model = tempfile(tmpdir = tdir, pattern = "model")
system(paste(path_to_vw, '--loss_function poisson --l1', l1, '--l2', l2,
             train.vw, '--cache_file', cache, '--passes 200 -f', model))
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

#define hotspots on grid's SPDF
#  +() to force integer per guidelines
grdSPDF$hotspot = +(grdSPDF$I %in% hotspot.ids)

#reverse rotation -- rotated points to
#  fit grid, now rotate grid to fit
#  original orientation of points
#  ** rotate expects angles in degrees CLOCKWISE**
grdSPDF = elide(grdSPDF, rotate = 180/pi * theta,
                center = point0)

#load clipping polygon -- Police Districts shapefile
police_districts = 
  readShapeSpatial('data/Portland_Police_Districts.shp', 
                   proj4string = prj)

portland = gBuffer(gUnaryUnion(police_districts),
                   width = 1e6*.Machine$double.eps)

#clip to polygon; sadly gIntersection
#  drops data, so need the gIntersects step to
#  prevent this from happening
grdSPDF = 
  SpatialPolygonsDataFrame(
    gIntersection(grdSPDF, portland, byid = TRUE),
    data = grdSPDF@data[gIntersects(grdSPDF, portland, byid = TRUE), ],
    match.ID = FALSE
  )
proj4string(grdSPDF) = prj

#add area per contest guidelines
grdSPDF$area = gArea(grdSPDF, byid = TRUE)

out.horizon = switch(horizon, '1w' = '1WK', '2w' = '2WK',
                     '1m' = '1MO', '2m' = '2MO', '3m' = '3MO')
out.crime.type = switch(crime.type, 'all' = 'ACFS', 'street' = 'SC',
                        'burglary' = 'Burg', 'vehicle' = 'TOA')
out.dir = paste0('submission/', out.crime.type, '/', out.horizon)
out.fn = paste0('TEAM_CFLP_', toupper(out.crime.type), '_', out.horizon)
writeOGR(grdSPDF, dsn = out.dir, layer = out.fn, 
         driver = 'ESRI Shapefile', overwrite_layer = TRUE)
