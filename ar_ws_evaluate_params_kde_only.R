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

#add/remove ! below to turn testing on/off
args = commandArgs(trailingOnly = TRUE)
if (!length(args)) {
  delx=600;dely=600;kde.bw=3000;
  horizon='1w';crime.type='burglary'
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
    c('delx', 'dely', 'kde.bw', 
      'crime.type', 'horizon')
  attach(args)
}

aa = delx*dely #forecasted area

crime.file = switch(crime.type,
                    all = "crimes_all.csv",
                    street = "crimes_str.csv",
                    burglary = "crimes_bur.csv",
                    vehicle = "crimes_veh.csv")

crimes = fread(crime.file)
crimes[ , occ_date := as.IDate(occ_date)]
crimes[ , occ_date_int := unclass(occ_date)]

#boundary coordinates of portland
portland = 
  as.matrix(fread('data/portland_coords.csv'))

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
grdSP = as.SpatialPolygons.GridTopology(grdtop)

# index to rearrange rows in pixellate objects
idx.new <- getGTindices(grdtop)

# how long is one period for this horizon?
march117 = unclass(as.IDate('2017-03-01'))
start = march117 - 
  switch(horizon, 
         '1w' = 7L, '2w' = 14L, '1m' = 31,
         '2m' = 61L, '3m' = 92L) 

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

compute.kde <- function(pts) {
  #subset using data.table for speed (?)
  idx = pts@data[occ_date_int %between% c(start, march117 - 1L), which = TRUE]
  #if no crimes found, just return 0
  #  (spkernel2d handles this with varying degrees of success)
  spkernel2d(pts = pts[idx, ], poly = portland,
             h0 = kde.bw, grd = grdtop)
}

grdSP$kde = compute.kde(crimes.sp)
grdSP$kde_rank = frank(-grdSP$kde, ties.method = 'random')
