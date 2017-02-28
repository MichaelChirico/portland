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
library(maptools)

#make sure we use the same seed
#  as evaluation_params.R
set.seed(60251935)

#add/remove ! below to turn testing on/off
..testing = 
  !FALSE

if (..testing) {
  # delx=600;dely=600;alpha=0;eta=1;lt=14;theta=0
  # features=250;l1=1e-5;l2=1e-4;
  # kde.bw=500;kde.lags=6;kde.win = 3
  # crime.type='all';horizon='2m'
  args = read.table(text = 'all	3m	531	605	0	3.187105	5.709805	0.508646	225	0	0	443.786032	11	86.66031',
                    sep = '\t', col.names = c('crime.type', 'horizon', 'delx', 'dely',
                                              'alpha', 'eta', 'lt',
                                              'theta', 'features', 'l1', 'l2', 
                                              'kde.bw', 'kde.lags', 'kde.win'),
                    stringsAsFactors = FALSE)
  attach(args)

  cat("**********************\n",
      "* TEST PARAMETERS ON *\n",
      "**********************\n")
} else {
  # each argument read in as a string in a character vector;
  # would rather have them as a list. basically do
  # that by converting them to a form read.table
  # understands and then attaching from a data.frame
  args = read.table(text = paste(commandArgs(trailingOnly = TRUE),
                                 collapse = '\t'),
                    stringsAsFactors = FALSE,
                    col.names = c('delx', 'dely', 'alpha', 'eta', 'lt',
                                  'theta', 'features', 'l1', 'l2', 
                                  'kde.bw', 'kde.lags', 'kde.win', 
                                  'crime.type', 'horizon'))
  attach(args)
}

incl_mos = c(10L, 11L, 12L, 1L, 2L, 3L)

aa = delx*dely
lx = eta*250
ly = eta*250

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

portland_r = 
  with(fread('data/portland_coords.csv'),
       rotate(x, y, theta, point0))

xrng = range(portland_r[ , 1L])
yrng = range(portland_r[ , 2L])

getGTindices <- function(gt) {
  dimx <- gt@cells.dim[1L]
  dimy <- gt@cells.dim[2L]
  c(matrix(seq_len(dimx*dimy), ncol = dimy, byrow = TRUE)[ , dimy:1L])
}

prj = CRS("+init=epsg:2913")
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
  with(crimes, as.data.table(pixellate(ppp(
    x = x_coordina, y = y_coordina,
    xrange = xrng, yrange = yrng, check = FALSE),
    eps = c(delx, dely)))[idx.new, ]
  )[value > 0, which = TRUE]

pd_length = switch(horizon, 
                   '1w' = 7L, '2w' = 14L, '1m' = 31,
                   '2m' = 61L, '3m' = 92L) 
one_year = switch(horizon, 
                  '1w' = 52L, '2w' = 26L, '1m' = 12L,
                  '2m' = 6L, '3m' = 4L)

n_pds = 5L*one_year

crimes[ , occ_date_int := unclass(occ_date)]
unq_crimes = crimes[ , unique(occ_date_int)]

march117 = unclass(as.IDate('2017-03-01'))
start = march117 - (seq_len(n_pds) - 1L) * pd_length
start = start[month(as.IDate(start, origin = '1970-01-01')) %in% incl_mos]
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

crimes.sp =
  SpatialPointsDataFrame(
    coords = crimes[ , cbind(x_coordina, y_coordina)],
    data = crimes[ , -c('x_coordina', 'y_coordina')],
    proj4string = prj
  )

crimes.sp@data = setDT(crimes.sp@data)
#for faster indexing
setkey(crimes.sp@data, occ_date_int)

future = 
  #Add one missing row for each cell corresponding to start date March 1, 2017
  unique(X, by = 'I')[ , c('start_date', 'value') := .(march117, NA_integer_)][]
X = rbind(X, future)

compute.kde <- function(pts, start, lag.no) {
  idx = pts@data[occ_date_int %between% 
                   (start - kde.win*lag.no + c(0, kde.win - 1L)), which = TRUE]
  if (!length(idx)) return(rep(0, length(incl_ids)))
  kde = spkernel2d(pts = pts[idx, ],
                   poly = portland_r, h0 = kde.bw, grd = grdtop)[incl_ids]
}

start_lag = CJ(start = start, lag = seq_len(kde.lags))

RHS = start_lag[, c(I = list(incl_ids),
                    lapply(setNames(lag, paste0('lag', lag)), compute.kde, 
                           pts = crimes.sp, start = .BY$start)),
                by = start]

X = X[RHS, on = c(start_date = 'start', 'I')]

X[ , train := start_date != march117]

proj = X[ , cbind(x, y, start_date)] %*% 
  (matrix(rt(3L*features, df = 2.5), nrow = 3L)/c(lx, ly, lt))

incl = setNames(nm = names(X))
incl.kde = grep("^lag", incl, value = TRUE)

phi.dt =
  X[ , {
    coln_to_vw = function(vn) { 
      V = get(vn)
      #to assure maximum comparability to the data model used
      #  in training, be sure to multiply by the same factor
      trainV = V[start_date <= march117 - one_year*pd_length & V > 0]
      val = V * 10^(abs(round(mean(log10(trainV)))))
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
fkt = 1/sqrt(features)
for (jj in 1L:features) {
  pj = proj[ , jj]
  set(phi.dt, j = paste0(c("cos", "sin"), jj), 
      value = list(sprintf("cos%i:%.5f", jj, fkt*cos(pj)),
                   sprintf("sin%i:%.5f", jj, fkt*sin(pj))))
}
rm(proj)

source("local_setup.R")
which.round = function(x)
  if (x > 0) {if (x < 1) round else floor} else ceiling
n.cells = as.integer(which.round(alpha)(6969600*(1+2*alpha)/aa))

filename = paste('output',crime.type,horizon,sep = '_')
train.vw = paste(paste0(tdir,'/train'), filename, sep='_')
test.vw = paste(paste0(tdir,'/test'), filename, sep='_')
cache = paste0(train.vw, '.cache')
pred.vw = paste(paste0(tdir,'/pred'), filename, sep='_')
fwrite(phi.dt[X$train], train.vw,
       sep = " ", quote = FALSE, col.names = FALSE,
       showProgress = FALSE)
fwrite(phi.dt[!X$train], test.vw,
       sep = " ", quote = FALSE, col.names = FALSE,
       showProgress = FALSE)

model = tempfile(tmpdir = tdir, pattern = "model")

call.vw = paste(path_to_vw, '--loss_function poisson --l1', l1, 
                '--l2', l2, train.vw, '--cache_file', cache, 
                '--passes 200 -f', model)
system(call.vw)
invisible(file.remove(train.vw))

system(paste(path_to_vw, '-t -i', model, '-p', pred.vw,
             test.vw, '--loss_function poisson'))
invisible(file.remove(model))

preds =
  fread(pred.vw, sep = " ", header = FALSE, col.names = c("pred", "I_start"))
invisible(file.remove(pred.vw))

preds[ , c("I", "start_date", "I_start") :=
         c(lapply(tstrsplit(I_start, split = "_"), as.integer),
           list(NULL))]

X[preds, pred.count := exp(i.pred), on = c("I", "start_date")]
rm(preds)

ranks = 
  X[(!train), .(tot.pred = sum(pred.count)), by = I
    ][order(-tot.pred), .(I, rank = .I)]

#define hotspots on grid's SPDF
#  +() to force integer per guidelines
grdSPDF$hotspot = +(grdSPDF$I %in% ranks[rank <= n.cells, I])

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

#be sure shapefiles fit contest guidelines
stopifnot(gArea(grdSPDF[grdSPDF$hotspot == 1, ]) %between%
            c(5280^2/4, 3*5280^2/4))
stopifnot(gArea(grdSPDF) %between%
            c(147.69*5280^2, 147.73*5280^2))

out.horizon = switch(horizon, '1w' = '1WK', '2w' = '2WK',
                     '1m' = '1MO', '2m' = '2MO', '3m' = '3MO')
out.crime.type = switch(crime.type, 'all' = 'ACFS', 'street' = 'SC',
                        'burglary' = 'Burg', 'vehicle' = 'TOA')
out.dir = paste0('submission/', out.crime.type, '/', out.horizon)
out.fn = paste0('TEAM_CFLP_', toupper(out.crime.type), '_', out.horizon)
writeOGR(grdSPDF, dsn = out.dir, layer = out.fn, 
         driver = 'ESRI Shapefile', overwrite_layer = TRUE)
