# Forecasting Crime in Portland
# ** Data Pre-Processing **
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira

set.seed(922574) #from random.org
rm(list = ls(all = TRUE))
gc()

#Development version 1.9.7 -- try
#  install.packages("data.table", type = "source",
#                   repos = "http://Rdatatable.github.io")
library(data.table)
#Michael Chirico's package of convenience functions;
#  devtools::install_github("MichaelChirico/funchir")
library(funchir)
#for web scraping
library(rvest) 
#for reading .dbf files
library(foreign)
#for loading and manipulating geospatial objects
library(maptools)
library(rgeos)
library(spatstat)
library(GISTools)
library(sp)
library(raster)

#Create an R Project in your local directory, and all of
#  these relative paths will work out of the box
wds = c(data = "./data")

# ============================================================================
# USEFUL FUNCTIONS
# ============================================================================

to.map <- function(df, crs="+init=epsg:2913", pct=1){
  prj = CRS("+init=epsg:2913")
  map = with(df,
             SpatialPointsDataFrame(
               coords=cbind(x_coordina, y_coordina),
               data = df[, -c('x_coordina','y_coordina'), with=FALSE],
               proj4string = prj
             ))
  N = NROW(map)
  map <- map[sample(N, pct*N),]
  map
}

to.data.table <- function(sp){
  coords <- coordinates(sp)
  as.data.table(sp@data)[ , c("x_coordina", "y_coordina") := 
                            .(coords[ , 1L], coords[ , 2L])][]
}


# ============================================================================ 
# LOAD DATA AND CREATE GEO DATAFRAMES
# ============================================================================

#Crime shapefiles' data
crimes = rbindlist(lapply(lapply(list.files(
  wds["data"], pattern = "^NIJ.*\\.dbf", full.names = TRUE),
  #as.is = TRUE is equivalent to stringsAsFactors = FALSE
  read.dbf, as.is = TRUE), setDT)
  #also, some missing data snuck in on one line
)[!is.na(occ_date)]

setnames(crimes, tolower(names(crimes)))
crimes[ , occ_date := as.IDate(occ_date)]

setnames(crimes, tolower(names(crimes)))
crimes[ , occ_date := as.IDate(occ_date)]
crimes[ , occ_year := quick_year(occ_date)]
crimes[ , occ_wday := quick_wday(occ_date)]
crimes[ , occ_quarter := quarter(occ_date)]
crimes[ , occ_month := month(occ_date)]
#First-of-the-month containing occ_date
crimes[ , occ_mo_1st := occ_date - mday(occ_date) + 1L]
#Wednesday of the week containing occ_date
crimes[ , occ_wed := occ_date - occ_wday + 4L]

#From cross-referencing the project page,
#  spatialreference.org, and prj2epsg.org,
#  determined the following common CRS for
#  all project-associated shapefiles

prj = CRS("+init=epsg:2913")
# prj <- CRS("+proj=longlat +datum=WGS84")
# crimes.map = with(crimes,
#                   SpatialPointsDataFrame(
#                     coords=cbind(x_coordina, y_coordina),
#                     data = crimes[, -c('x_coordina','y_coordina'), with=FALSE],
#                     proj4string = prj
#                   ))

crimes.map <- to.map(crimes, pct=1)

# @knitr kdesetup
# Working on a more manageable subsample of crimes for now
# N = NROW(crimes.map)
# crimes.map = crimes.map[sample(N, 0.1*N),]

portland <- readShapePoly("./data/Portland_Police_Districts.shp", 
                          proj4string = prj)

portland.bdy <- gUnaryUnion(portland)

# Spatial join -- find the district associated with each crime
crimes.map@data[ , c("district", "precinct")] = 
  (crimes.map %over% portland)[ , c("DISTRICT", "PRECINCT")]

# Some observations outside the police district boundaries presented
crimes.map = crimes.map[!is.na(crimes.map$precinct), ]

# ============================================================================
# GRID
# ============================================================================

bb <- bbox(portland)
cell.sizex <- 600
cell.sizey <- 600
cell.dimx <- round((bb[1,2] - bb[1,1])/cell.sizex)
cell.dimy <- round((bb[2,2] - bb[2,1])/cell.sizey)

grd.grdtop <- GridTopology(cellcentre.offset = c(bb[1,1], bb[2,1]),
                           cellsize = c(cell.sizex, cell.sizey),
                           cells.dim = c(cell.dimx, cell.dimy))

# turn grid to SpatialPolygonsDataFrame:
nb.cells = cell.dimx * cell.dimy
grd.layer <- SpatialPolygonsDataFrame(as.SpatialPolygons.GridTopology(grd.grdtop),
                                      data = data.frame(c(1:nb.cells)),
                                      match.ID = FALSE)
names(grd.layer) <- "ID"
proj4string(grd.layer) <- proj4string(crimes.map)

# intersect grid with boundaries of Portland:

# Should work but doesn't:
grd <- gIntersection(grd.layer, portland.bdy, byid = TRUE)

# alternative from http://stackoverflow.com/questions/15881455/how-to-clip-worldmap-with-polygon-in-r
# grd.index <- gIntersects(grd.layer, portland.bdy, byid = TRUE)
# grd <- grd.layer[which(grd.index), ]

grd.bdy <- gUnaryUnion(grd)
areas <- poly.areas(grd)
areas.total <- gArea(grd)

# turn grid to SpatialPointsDataFrame with data=id
tmp <- strsplit(names(grd), " ")
grd.id <- sapply(tmp, "[[", 1)
grd.id <- data.frame(data.frame(grd.id))
grd <- SpatialPolygonsDataFrame(grd, data = grd.id, match.ID = FALSE)

par(mfrow=c(1,1))
plot(grd)
plot(portland.bdy, add=TRUE)

## get outer bounds of Portland (http://stackoverflow.com/questions/12663263/dissolve-holes-in-polygon-in-r)
outerRings <- Filter(function(f){f@ringDir==1}, portland.bdy@polygons[[1]]@Polygons)
outerBounds <- SpatialPolygons(list(Polygons(outerRings,ID=1)))
portland.chull <- gConvexHull(portland.bdy)

## simplified portlan boundary (got here by trial and error; portland.bdy consist of 5 polys)
portland.bdy.simp <- SpatialPolygons(list(Polygons(list(outerBounds@polygons[[1]]@Polygons[[5]]),ID=1)))
proj4string(portland.bdy.simp) <- CRS(proj4string(crimes.map))

# ============================================================================
# 3D KERNEL
# ============================================================================

library(splancs)

crimes.pts <- coordinates(crimes.map)

# day indicator as integer starting from 1:
crimes <- crimes[order(occ_date)]
crimes[, day := 1 + cumsum(c(0, diff(occ_date)))]

# parameters for kernel3d:
a1 <- slot(grd.grdtop, "cellcentre.offset")[1] - (slot(grd.grdtop, "cellsize")[1])/2
a2 <- a1 + slot(grd.grdtop, "cellsize")[1] * slot(grd.grdtop, "cells.dim")[1]
b1 <- slot(grd.grdtop, "cellcentre.offset")[2] - (slot(grd.grdtop, "cellsize")[2])/2
b2 <- b1 + slot(grd.grdtop, "cellsize")[2] * slot(grd.grdtop, "cells.dim")[2]
nx <- slot(grd.grdtop, "cells.dim")[1]
ny <- slot(grd.grdtop, "cells.dim")[2]

xgr <- seq(a1, a2, length.out = nx)
ygr <- seq(b1, b2, length.out = ny)
zgr <- crimes[occ_month==3 & occ_year==2016, max(day)] # last day march 2016
# zgr <- crimes[occ_month %in% c(2,3) & occ_year==2016, unique(day)]

k3d <- kernel3d(crimes.pts, crimes$day, xgr = xgr, ygr = ygr, zgr = zgr, hxy = 2400, hz = 60)

image(k3d$xgr, k3d$ygr, k3d$v[,,1])
plot(portland.bdy, add=TRUE)

flipHorizontal <- function(x) {
  if (!inherits(x, "SpatialGridDataFrame")) stop("x must be a
                                                 SpatialGridDataFrame")
  grd <- getGridTopology(x)
  idx = 1:prod(grd@cells.dim[1:2])
  m = matrix(idx, grd@cells.dim[2], grd@cells.dim[1], byrow =
               TRUE)[,grd@cells.dim[1]:1]
  idx = as.vector(t(m))
  x@data <- x@data[idx, TRUE, drop = FALSE]
  x
}

flipVertical <- function(x) {
  if (!inherits(x, "SpatialGridDataFrame")) stop("x must be a
                                                 SpatialGridDataFrame")
  grd <- getGridTopology(x)
  idx = 1:prod(grd@cells.dim[1:2])
  m = matrix(idx, grd@cells.dim[2], grd@cells.dim[1], byrow =
               TRUE)[grd@cells.dim[2]:1, ]
  idx = as.vector(t(m))
  x@data <- x@data[idx, TRUE, drop = FALSE]
  x
}

grd.k3d <- SpatialGridDataFrame(grd.grdtop, data=data.frame(kde=as.matrix(k3d$v)))
grd.k3d <- flipVertical(grd.k3d)
ras.k3d <- brick(grd.k3d)
ras.k3d <- crop(ras.k3d, portland.bdy.simp)

spplot(obj = grd.k3d, col.regions=terrain.colors(16), cuts=15, 
       main=list(label="All, Feb 2016",cex=2))
plot(ras.k3d, col.regions=terrain.colors(16), cuts=15)
plot(portland.bdy.simp, add=TRUE)

kernel3d.crime <- function(pts, t, hxy=2400, hz=60, grd.grdtop) {
  # Returns a SpatialGridDataFrame with the kernel estimates as kde:
  # parameters for kernel3d:
  a1 <- slot(grd.grdtop, "cellcentre.offset")[1] - (slot(grd.grdtop, "cellsize")[1])/2
  a2 <- a1 + slot(grd.grdtop, "cellsize")[1] * slot(grd.grdtop, "cells.dim")[1]
  b1 <- slot(grd.grdtop, "cellcentre.offset")[2] - (slot(grd.grdtop, "cellsize")[2])/2
  b2 <- b1 + slot(grd.grdtop, "cellsize")[2] * slot(grd.grdtop, "cells.dim")[2]
  nx <- slot(grd.grdtop, "cells.dim")[1]
  ny <- slot(grd.grdtop, "cells.dim")[2]
  
  xgr <- seq(a1, a2, length.out = nx)
  ygr <- seq(b1, b2, length.out = ny)
  zgr <- crimes[occ_month==3 & occ_year==2016, max(day)] # last day march 2016  
  
  # compute kernel:
  k3d <- kernel3d(pts, t, xgr = xgr, ygr = ygr, zgr = zgr, hxy = hxy, hz = hz)
  grd.k3d <- SpatialGridDataFrame(grd.grdtop, data=data.frame(kde=as.matrix(k3d$v)))
  flipVertical(grd.k3d)
}

# select coordinates for each crime up to march 2016 and time vector:
pts.all <- coordinates(crimes.map[crimes.map$occ_date <= '2016-03-31',])
t.all <- crimes[occ_date <= '2016-03-31', day]
pts.street <- coordinates(crimes.map[crimes.map$occ_date <= '2016-03-31' & crimes.map$category=='STREET CRIMES',])
t.street <- crimes[occ_date <= '2016-03-31' & category=='STREET CRIMES', day]
pts.burglary <- coordinates(crimes.map[crimes.map$occ_date <= '2016-03-31' & crimes.map$category=='BURGLARY',])
t.burglary <- crimes[occ_date <= '2016-03-31' & category=='BURGLARY', day]
pts.vehicle <- coordinates(crimes.map[crimes.map$occ_date <= '2016-03-31' & crimes.map$category=='MOTOR VEHICLE THEFT',])
t.vehicle <- crimes[occ_date <= '2016-03-31' & category=='MOTOR VEHICLE THEFT', day]

# compute kdes:
k3d.all <- kernel3d.crime(pts.all, t.all, grd.grdtop = grd.grdtop)
k3d.burglary <- kernel3d.crime(pts.burglary, t.burglary, grd.grdtop = grd.grdtop)
k3d.street <- kernel3d.crime(pts.street, t.street, grd.grdtop = grd.grdtop)
k3d.vehicle <- kernel3d.crime(pts.vehicle, t.vehicle, grd.grdtop = grd.grdtop)

# turn estimates to intensities:
k3d.all$kde <- k3d.all$kde*length(pts.all)
k3d.burglary$kde <- k3d.burglary$kde*length(pts.burglary)
k3d.street$kde <- k3d.street$kde*length(pts.street)
k3d.vehicle$kde <- k3d.vehicle$kde*length(pts.vehicle)

# unify into single SpatialGridDataFrame:
k3d <- k3d.all
k3d$kde.burglary <- k3d.burglary$kde
k3d$kde.street <- k3d.street$kde
k3d$kde.vehicle <- k3d.vehicle$kde

spplot(k3d, checkEmptyRC=FALSE, col.regions=terrain.colors(16), cuts=15,
       main=paste('KDE 3D'))

# turn to raster:
ras.all <- brick(k3d.all)
ras.burglary <- brick(k3d.burglary)
ras.street <- brick(k3d.street)
ras.vehicle <- brick(k3d.vehicle)

# plot:
pdf2('tex/figures/kde3d.pdf')
par(mfrow=c(2,2), mar=c(4,9,1,6))
plot(ras.burglary)
plot(portland.bdy.simp, add=TRUE)
plot(ras.vehicle)
plot(portland.bdy.simp, add=TRUE)
plot(ras.all)
plot(portland.bdy.simp, add=TRUE)
plot(ras.street)
plot(portland.bdy.simp, add=TRUE)
dev.off2()

