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
library(rgdal)
library(splancs) # very fast kde, a bit picky in the form of the inputs
#output formatting
library(stargazer)

#Create an R Project in your local directory, and all of
#  these relative paths will work out of the box
wds = c(data = "./data")

# =============================================================================
# USEFUL FUNCTIONS
# ============================================================================

to.map <- function(df, crs="+init=epsg:2913", pct=1){
  prj = CRS(crs)
  map = with(df,
             SpatialPointsDataFrame(
               coords = cbind(x_coordina, y_coordina),
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

# create spatio-temporal counts at weekly frequency from 'from' to 'to'.
  # If no dates are provided it will use the full range in the data.
  # Returns a table with the counts.
tab.counts <- function(dt, variable, from = NULL, to = NULL){
if (is.null(from) || is.null(to)){
    rng = dt[ , range(occ_wed)]
    from <- rng[1L]
    to <- rng[2L]
  }
  dt[occ_wed %between% c(from, to), 
     table(cut(get(variable), 
               breaks = c(0, 1, 2, 5, 10, 100),
               labels = c("0", "1", "2-4", "5-9", "10+"),
               right = FALSE))]
}

# add zeros to array from the right to make it have length len.
pad.zeros <- function(array, len){
  zeros.to.add <- max(0, len - length(array))
  c(array, rep(0, zeros.to.add))
}

# turn a list of tables into a dataframe, one col for each table.
df.table <- function(ls){
  len.ls <- sapply(ls, length)
  len.ls.max <- max(len.ls)
  df <- data.frame(lapply(ls, pad.zeros, len.ls.max))
  colnames(df) <- c('w1','w2','m1','m2','m3')
  df
}

#when taking the log of zero, toss to 0
infto0 = function(x) {x[is.infinite(x)] = 0; x}
#alternative approach: as long as we know all non-zero
#  x are integers, they're at least 1 -- if we re-set
#  0 as .5, the ordering is still set
inftomin = function(x) {x[is.infinite(x)] = log(.5); x}

pai = function(a, n, N, A) (n/N)/(a/A)

# =============================================================================
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

grd = readShapePoly("./data/grids/rec600x600.shp", proj4string = prj)

# =============================================================================
# KDE PLOTS
# ============================================================================
# @knitr kde

# some styling palettes:
norm_palette <- colorRampPalette(c("white","red"))
pal_opaque <- norm_palette(15)
pal_trans <- norm_palette(15)
pal_trans[1L] <- "#FFFFFF00" #was originally "#FFFFFF" 

# define a bandwidth:
# h <- sd(crimes.map$x_coordina)*(2/(3*length(crimes.map)))^(1/6)


# TOTAL CRIMES:
crimes.map.dens <- kde.points(crimes.map, lims=portland)
plot(crimes.map.dens, col=pal_opaque)
masker <- poly.outer(crimes.map.dens, portland, extend=100)
add.masking(masker)
plot(portland, add=TRUE)

# BURGLARY:
crimes.burglary <- crimes.map[crimes.map$category=='BURGLARY',]
crimes.burglary.dens <- kde.points(crimes.burglary, lims=portland)
plot(crimes.burglary.dens, col=pal_opaque, main = "Burglary")
masker <- poly.outer(crimes.burglary.dens, portland, extend=100)
add.masking(masker)
plot(portland, add=TRUE)

# MOTOR VEHICLE THEFT:
crimes.vehicle <- crimes.map[crimes.map$category=='MOTOR VEHICLE THEFT',]
crimes.vehicle.dens <- kde.points(crimes.vehicle, lims=portland)
plot(crimes.vehicle.dens, col=pal_opaque, main = "Car Theft")
masker <- poly.outer(crimes.vehicle.dens, portland, extend=100)
add.masking(masker)
plot(portland, add=TRUE)

# STREET CRIMES:
crimes.street <- crimes.map[crimes.map$category=='STREET CRIMES',]
crimes.street.dens <- kde.points(crimes.street, lims=portland)
plot(crimes.street.dens, col=pal_opaque, main = "Street Crimes")
masker <- poly.outer(crimes.street.dens, portland, extend=100)
add.masking(masker)
plot(portland, add=TRUE)

# OTHER:
crimes.other <- crimes.map[crimes.map$category=='OTHER',]
crimes.other.dens <- kde.points(crimes.other, lims=portland)
plot(crimes.other.dens, col=pal_opaque, main = "Other Crimes")
masker <- poly.outer(crimes.other.dens, portland, extend=100)
add.masking(masker)
plot(portland, add=TRUE)

# =============================================================================
# K-FUNCTIONS
# ============================================================================
# for spatstats functions, need to convert to ppp data format:
# ppp objects are defined by a set of coordinates and a window object, and (optionaly) a vector of marks
# in this case the window is the border of portland and the marks is crime category.
# @knitr kfunction
win <- as.owin(gUnaryUnion(portland, id=NULL))
crimes.ppp <- as.ppp(coordinates(crimes.map), W = win)
marks(crimes.ppp) <- as.factor(crimes.map$category)

par(mfrow=c(1,1))
par(mar = c(4.2,4.2,4.2,4.2))
kf.all <- Lest(crimes.ppp, correction='border') 
# kf.all.env <- envelope(crimes.ppp, Kest, correction='border')
plot(kf.all, main = "All Crimes")
# plot(kf.all.env)

crimes.ppp.burglary <- crimes.ppp[crimes.map$category=='BURGLARY']
kf.burglary <- Kest(crimes.ppp.burglary, correction='border') 
# kf.burglary.env <- envelope(crimes.ppp.burglary, Kest, correction='border')
plot(kf.burglary, main = "Burglary")
# plot(kf.burglary.env)

crimes.ppp.vehicle <- crimes.ppp[crimes.map$category=='MOTOR VEHICLE THEFT']
kf.vehicle <- Kest(crimes.ppp.vehicle, correction='border') 
# kf.vehicle.env <- envelope(crimes.ppp.vehicle, Kest, correction='border')
plot(kf.vehicle, main = "Car Theft")
# plot(kf.vehicle.env)

crimes.ppp.street <- crimes.ppp[crimes.map$category=='STREET CRIMES']
kf.street <- Kest(crimes.ppp.street, correction='border') 
# kf.street.env <- envelope(crimes.ppp.street, Kest, correction='border')
plot(kf.street, main = "Street Crimes")
# plot(kf.street.env)

crimes.ppp.other <- crimes.ppp[crimes.map$category=='OTHER']
kf.other <- Kest(crimes.ppp.other, correction='border') 
# kf.other.env <- envelope(crimes.ppp.other, Kest, correction='border')
plot(kf.other, main = "Other Crimes")
# plot(kf.other.env)

# =============================================================================
# CROSS L-FUNCTIONS
# ============================================================================
# @knitr crossl

ck.burglaryStreet <- Lcross(crimes.ppp, i='BURGLARY', j='STREET CRIMES', correction='border')
plot(ck.burglaryStreet, main = "Burglary & Street Crimes")

ck.burglaryVehicle <- Lcross(crimes.ppp, i='BURGLARY', j='MOTOR VEHICLE THEFT', correction='border')
plot(ck.burglaryVehicle, main = "Burglary & Car Theft")

ck.burglaryOther <- Lcross(crimes.ppp, i='BURGLARY', j='OTHER', correction='border')
plot(ck.burglaryOther, main = "Burglary & Other Crimes")

ck.vehicleStreet <- Lcross(crimes.ppp, i='MOTOR VEHICLE THEFT', j='STREET CRIMES', correction='border')
plot(ck.vehicleStreet, main = "Car Theft & Street Crimes")

ck.vehicleOther <- Lcross(crimes.ppp, i='MOTOR VEHICLE THEFT', j='OTHER', correction='border')
plot(ck.vehicleOther, main = "Car Theft & Other Crimes")

ck.streetOther <- Lcross(crimes.ppp, i='STREET CRIMES', j='OTHER', correction='border')

plot(ck.streetOther, main = "Street Crimes & Other Crimes")
plot(ck.streetOther)

# crimes.count <- poly.counts(crimes.map, grd)

# =============================================================================
# SPATIO-TEMPORAL HISTOGRAMS
# ============================================================================
# 1. assign each crime to a grid cell
# 2. group by weeks and category
# 3. count crimes per cell

# overlay crimes with grid:
idx <- over(crimes.map, grd)
crimes.map$grd.id <- idx$grd.id

# check:
plot(grd[grd$grd.id == crimes.map[1L, ]$grd.id, ])
plot(crimes.map[1L, ], add=TRUE)

# generate counts by week and grid cell:
crimes <- to.data.table(crimes.map)
counts <- crimes[, .(count = .N), by = .(occ_wed, grd.id, category)]
counts <- dcast(counts, occ_wed + grd.id ~ category, fill = 0, value.var = 'count')

# add sum of all crimes per week and grid cell:
setnames(counts, gsub("\\s+", "_", names(counts)))
counts[, all := `BURGLARY` + `MOTOR_VEHICLE_THEFT` + 
         `OTHER` + `STREET_CRIMES`, by = .(occ_wed, grd.id)]

counts = counts[CJ(occ_wed, grd$grd.id, unique = TRUE), 
                lapply(.SD, function(x) {
                  if (any(idx <- is.na(x))) x[idx] = 0
                  x})]

# counts for all categories:
# First week of February:
date.from <- '2016-02-01'
date.to <- '2016-02-08' 

tab.all <- tab.counts(counts, variable = 'all', from = date.from, to = date.to)
tab.burglaries <- tab.counts(counts, variable = 'BURGLARY', from = date.from, to = date.to)
tab.vehicle <- tab.counts(counts, variable = 'MOTOR_VEHICLE_THEFT', from = date.from, to = date.to)
tab.other <- tab.counts(counts, variable = 'OTHER', from = date.from, to = date.to)
tab.street <- tab.counts(counts, variable = 'STREET_CRIMES', from = date.from, to = date.to)



pdf("~/Desktop/spatiohists.pdf")
par(mfrow = c(1,1), mfrow = c(2,2))
barplot(infto0(log10(tab.all)), 
        yaxt = "n", main = "All Crimes", col = "blue")
axis(side = 2L, at = (ys <- 0:ceiling(par('usr')[4L])), 
     labels = prettyNum(10^ys, big.mark = ","), las = 1L)

barplot(infto0(log10(tab.burglaries)),
        yaxt = "n", main = "Burglaries", col = "blue")
axis(side = 2L, at = (ys <- 0:ceiling(par('usr')[4L])),
     labels = prettyNum(10^ys, big.mark = ","), las = 1L)

barplot(infto0(log10(tab.vehicle)), 
        yaxt = "n", main = "Vehicle", col = "blue")
axis(side = 2L, at = (ys <- 0:ceiling(par('usr')[4L])), 
     labels = prettyNum(10^ys, big.mark = ","), las = 1L)

barplot(infto0(log10(tab.street)), 
        yaxt = "n", main = "Street", col = "blue")
axis(side = 2L, at = (ys <- 0:ceiling(par('usr')[4L])), 
     labels = prettyNum(10^ys, big.mark = ","), las = 1L)
dev.off()

# first two weeks of February:
date.from <- '2016-02-01'
date.to <- '2016-02-15' 

tab.all.2 <- tab.counts(counts, variable = 'all', from = date.from, to = date.to)
tab.burglaries.2 <- tab.counts(counts, variable = 'BURGLARY', from = date.from, to = date.to)
tab.vehicle.2 <- tab.counts(counts, variable = 'MOTOR_VEHICLE_THEFT', from = date.from, to = date.to)
tab.other.2 <- tab.counts(counts, variable = 'OTHER', from = date.from, to = date.to)
tab.street.2 <- tab.counts(counts, variable = 'STREET_CRIMES', from = date.from, to = date.to)

# month of February:
date.from <- '2016-02-01'
date.to <- '2016-03-01' 

tab.all.month <- tab.counts(counts, variable = 'all', from = date.from, to = date.to)
tab.burglaries.month <- tab.counts(counts, variable = 'BURGLARY', from = date.from, to = date.to)
tab.vehicle.month <- tab.counts(counts, variable = 'MOTOR_VEHICLE_THEFT', from = date.from, to = date.to)
tab.other.month <- tab.counts(counts, variable = 'OTHER', from = date.from, to = date.to)
tab.street.month <- tab.counts(counts, variable = 'STREET_CRIMES', from = date.from, to = date.to)

# 2 months:
date.from <- '2016-02-01'
date.to <- '2016-04-01' 

tab.all.2month <- tab.counts(counts, variable = 'all', from = date.from, to = date.to)
tab.burglaries.2month <- tab.counts(counts, variable = 'BURGLARY', from = date.from, to = date.to)
tab.vehicle.2month <- tab.counts(counts, variable = 'MOTOR_VEHICLE_THEFT', from = date.from, to = date.to)
tab.other.2month <- tab.counts(counts, variable = 'OTHER', from = date.from, to = date.to)
tab.street.2month <- tab.counts(counts, variable = 'STREET_CRIMES', from = date.from, to = date.to)

# 3 months:
date.from <- '2016-02-01'
date.to <- '2016-05-01' 

tab.all.3month <- tab.counts(counts, variable = 'all', from = date.from, to = date.to)
tab.burglaries.3month <- tab.counts(counts, variable = 'BURGLARY', from = date.from, to = date.to)
tab.vehicle.3month <- tab.counts(counts, variable = 'MOTOR_VEHICLE_THEFT', from = date.from, to = date.to)
tab.other.3month <- tab.counts(counts, variable = 'OTHER', from = date.from, to = date.to)
tab.street.3month <- tab.counts(counts, variable = 'STREET_CRIMES', from = date.from, to = date.to)

## Turn into data frames for presentation:

# create lists of tables:
tab.all.list <- list(tab.all, tab.all.2, tab.all.month, tab.all.2month, tab.all.3month)
tab.burglaries.list <- list(tab.burglaries, tab.burglaries.2, tab.burglaries.month, tab.burglaries.2month, tab.burglaries.3month)
tab.vehicle.list <- list(tab.vehicle, tab.vehicle.2, tab.vehicle.month, tab.vehicle.2month, tab.vehicle.3month)
tab.street.list <- list(tab.street, tab.street.2, tab.street.month, tab.street.2month, tab.street.3month)
tab.other.list <- list(tab.other, tab.other.2, tab.other.month, tab.other.2month, tab.other.3month)

# make dataframes:
df.all <- df.table(tab.all.list)
df.all
df.burglaries <- df.table(tab.burglaries.list)
df.burglaries
df.vehicle <- df.table(tab.vehicle.list)
df.vehicle
df.street <- df.table(tab.street.list)
df.street
df.other <- df.table(tab.other.list)
df.other

# HTML tables:
stargazer(df.all, type = 'html')
stargazer(df.burglaries, type = 'html')
stargazer(df.vehicle, type = 'html')
stargazer(df.street, type = 'html')
stargazer(df.other, type = 'html')


# =============================================================================
# NO CRIME ZONES
# =============================================================================

pdf("~/Desktop/nocrimes.pdf")
par(mfrow = c(2L, 2L))
# all crimes:
crime.cells <- crimes[occ_month %between% c(0L, 3L), unique(grd.id)]
nocrimes <- !(grd$grd.id %in% crime.cells)
plot(grd[nocrimes,], col='red', main='All', lwd=0.1)
plot(grd[!nocrimes,], col='green', add=TRUE, lwd=0.1)

# burglaries:
crime.cells <- crimes[occ_month %between% c(0,3) & category=='BURGLARY', unique(grd.id)]
nocrimes <- !(grd$grd.id %in% crime.cells)
plot(grd[nocrimes,], col='red', main='Burglaries', lwd=0.1)
plot(grd[!nocrimes,], col='green', add=TRUE, lwd=0.1)

# street:
crime.cells <- crimes[occ_month %between% c(0,3) & category=='STREET CRIMES', unique(grd.id)]
nocrimes <- !(grd$grd.id %in% crime.cells)
plot(grd[nocrimes,], col='red', main='Street', lwd=0.1)
plot(grd[!nocrimes,], col='green', add=TRUE, lwd=0.1)

# burglaries:
crime.cells <- crimes[occ_month %between% c(0,3) & category=='MOTOR VEHICLE THEFT', unique(grd.id)]
nocrimes <- !(grd$grd.id %in% crime.cells)
plot(grd[nocrimes,], col='red', main='Vehicle', lwd=0.1)
plot(grd[!nocrimes,], col='green', add=TRUE, lwd=0.1)
dev.off()

crime.cells <- crimes[occ_month %between% c(2,4) & occ_year==2016 & category=='MOTOR VEHICLE THEFT', unique(grd.id)]
grd.burglary <- grd[grd$grd.id %in% crime.cells, ]
plot(portland.bdy, main = "All Cells with a Car Theft between Feb. and Apr. 2016")
plot(grd.burglary, add = TRUE, col = "darkgreen")
gArea(grd.burglary)

# =============================================================================
# KDE ESTIMATES
# =============================================================================

## get outer bounds of Portland (http://stackoverflow.com/questions/12663263)
outerRings <- Filter(function(pol) pol@ringDir==1, 
                     portland.bdy@polygons[[1L]]@Polygons)
outerBounds <- SpatialPolygons(list(Polygons(outerRings, ID=1)))
portland.chull <- gConvexHull(portland.bdy)

## simplified portlan boundary (got here by trial and error;
##   portland.bdy consist of 5 polys)
portland.bdy.simp <- 
  SpatialPolygons(list(Polygons(list(
    outerBounds@polygons[[1]]@Polygons[[5]]),ID=1)))

## GridTopology
grd.grdtop = GridTopology(cellcentre.offset = bbox(portland)[ , 'min'],
                          cellsize = c(600, 600),
                          cells.dim = round(apply(bbox(portland), 1L, diff)/600))

bw = 2400 # band width in feet (I guess)

## compute kernels:

compute.kdes <- function(df, grd.grdtop, bw){
  # compute KDEs for all crime types in df using grid grd. Uses library splancs.
  # note: grd needs to be a GridTopology object
  #       df needs to be a SpatialPointsDataFrame
  
  kde.all <- 
    spkernel2d(pts = df, h0 = bw, grd = grd.grdtop,
               poly = portland.bdy.simp@polygons[[1L]]@Polygons[[1L]]@coords)
  kde.street <-
    spkernel2d(pts = df[df$category=='STREET CRIMES', ],
               h0 = bw, grd = grd.grdtop,
               poly = portland.bdy.simp@polygons[[1L]]@Polygons[[1L]]@coords)
  kde.burglary <- 
    spkernel2d(pts = df[df$category=='BURGLARY', ], 
               poly = portland.bdy.simp@polygons[[1L]]@Polygons[[1L]]@coords, 
               h0 = bw, grd = grd.grdtop)
  kde.vehicle <- 
    spkernel2d(pts = df[df$category=='MOTOR VEHICLE THEFT', ], 
               poly = portland.bdy.simp@polygons[[1L]]@Polygons[[1L]]@coords, 
               h0 = bw, grd = grd.grdtop)
  # for some reason kdes don't sum to 1; I normalize them so that they do
  data.frame(all = kde.all/sum(kde.all, na.rm=TRUE), 
             street = kde.street/sum(kde.street, na.rm=TRUE), 
             burglary = kde.burglary/sum(kde.burglary, na.rm=TRUE), 
             vehicle = kde.vehicle/sum(kde.vehicle, na.rm=TRUE))
}
## temporal selection:
crimes.map.feb16 <-
  crimes.map[crimes.map$occ_year==2016 & crimes.map$occ_month==2, ]

kdes = compute.kdes(df=crimes.map.feb16, grd.grdtop = grd.grdtop, bw=bw)

kernels <- SpatialGridDataFrame(grd.grdtop, data = kdes)

pdf('tex/figures/kde_bycategory.pdf')
spplot(kernels, checkEmptyRC=FALSE, col.regions=terrain.colors(16), cuts=15,
       main=paste('KDE for Feb 2016, bandwidth =', bw, 
                  ', cell size =', 600, 'x', 600, sep = " "))
dev.off()

## plot individually:
spplot(obj = SpatialGridDataFrame(grd.grdtop, data = kdes['all']), 
       col.regions=terrain.colors(16), cuts=15, 
       main=list(label="All, Feb 2016",cex=2))
spplot(obj = SpatialGridDataFrame(grd.grdtop, data = kdes['street']),
       col.regions=terrain.colors(16), cuts=15,
       main=list(label="Street Crimes, Feb 2016",cex=2))
spplot(obj = SpatialGridDataFrame(grd.grdtop, data = kdes['burglary']),
       col.regions=terrain.colors(16), cuts=15,
       main=list(label="Burglaries, Feb 2016",cex=2))
spplot(obj = SpatialGridDataFrame(grd.grdtop, data = kdes['vehicle']),
       col.regions=terrain.colors(16), cuts=15,
       main=list(label="Vehicle Theft, Feb 2016",cex=2))

# =============================================================================
# SCATTER PLOTS
# =============================================================================

# Compute kernels for different forecasting horizons:
## 1st week of Feb
crimes.map.w116 <- 
  crimes.map[crimes.map$occ_wed %between% c("2016-03-02", "2016-03-09"), ]
kdes <- compute.kdes(df=crimes.map.w116, grd.grdtop = grd.grdtop, bw=bw)
kde.all.w116 <- kdes$all
kde.street.w116 <- kdes$street
kde.burglary.w116 <- kdes$burglary
kde.vehicle.w116 <- kdes$vehicle

# scatter plots:
pdf('tex/figures/scatter_kde_1w.pdf')
par(mfrow=c(2,2),
    mar=c(2.4,2.4,3,2.4),
    oma=c(0,0,2,0))
plot(kde.all.feb16, kde.all.w116, main='All')
plot(kde.street.feb16, kde.street.w116, main='Street')
plot(kde.burglary.feb16, kde.burglary.w116, main='Burglaries')
plot(kde.vehicle.feb16, kde.vehicle.w116, main='Vehicle')
title("Density Feb 2016 vs. 1st week of Mar", outer=TRUE)
dev.off()

# 2 weeks of Feb
crimes.map.w216 <- crimes.map[crimes.map$occ_wed %between% c("2016-03-02","2016-03-16"),]
kdes <- compute.kdes(df=crimes.map.w216, grd.grdtop = grd.grdtop, bw=bw)
kde.all.w216 <- kdes$all
kde.street.w216 <- kdes$street
kde.burglary.w216 <- kdes$burglary
kde.vehicle.w216 <- kdes$vehicle

# scatter plots:
par(mfrow=c(2,2),
    mar=c(2.4,2.4,3,2.4),
    oma=c(0,0,2,0))
plot(kde.all.feb16, kde.all.w216, main='All')
plot(kde.street.feb16, kde.street.w216, main='Street')
plot(kde.burglary.feb16, kde.burglary.w216, main='Burglaries')
plot(kde.vehicle.feb16, kde.vehicle.w216, main='Vehicle')
title("Density Feb 2016 vs. 2 weeks of Mar", outer=TRUE)


# 1 Month
crimes.map.m116 <- crimes.map[crimes.map$occ_year==2016 & crimes.map$occ_month==3,]
kdes = compute.kdes(df=crimes.map.m116, grd.grdtop = grd.grdtop, bw=bw)
kde.all.m116 <- kdes$all
kde.street.m116 <- kdes$street
kde.burglary.m116 <- kdes$burglary
kde.vehicle.m116 <- kdes$vehicle

# scatter plots:
par(mfrow=c(2,2),
    mar=c(2.4,2.4,3,2.4),
    oma=c(0,0,2,0))
plot(kde.all.feb16, kde.all.m116, main='All')
plot(kde.street.feb16, kde.street.m116, main='Street')
plot(kde.burglary.feb16, kde.burglary.m116, main='Burglaries')
plot(kde.vehicle.feb16, kde.vehicle.m116, main='Vehicle')
title("Density Feb 2016 vs. Month of March", outer=TRUE)

# 2 Months
crimes.map.m216 <- crimes.map[crimes.map$occ_year==2016 & crimes.map$occ_month %in% c(3,4),]
kdes <- compute.kdes(df=crimes.map.m216, grd.grdtop = grd.grdtop, bw=bw)
kde.all.m216 <- kdes$all
kde.street.m216 <- kdes$street
kde.burglary.m216 <- kdes$burglary
kde.vehicle.m216 <- kdes$vehicle

# scatter plots:
par(mfrow=c(2,2),
    mar=c(2.4,2.4,3,2.4),
    oma=c(0,0,2,0))
plot(kde.all.feb16, kde.all.m216, main='All')
plot(kde.street.feb16, kde.street.m216, main='Street')
plot(kde.burglary.feb16, kde.burglary.m216, main='Burglaries')
plot(kde.vehicle.feb16, kde.vehicle.m216, main='Vehicle')
title("Density Feb 2016 vs. Months of Mar and Apr 2016", outer=TRUE)

# 3 Months
crimes.map.m316 <- crimes.map[crimes.map$occ_year==2016 & crimes.map$occ_month %in% c(3,4,5),]
kdes <- compute.kdes(df=crimes.map.m316, grd.grdtop = grd.grdtop, bw=bw)
kde.all.m316 <- kdes$all
kde.street.m316 <- kdes$street
kde.burglary.m316 <- kdes$burglary
kde.vehicle.m316 <- kdes$vehicle

# scatter plots:
pdf('tex/figures/scatter_kde_3m.pdf')
par(mfrow=c(2,2),
    mar=c(2.4,2.4,3,2.4),
    oma=c(0,0,2,0))
plot(kde.all.feb16, kde.all.m316, main='All')
plot(kde.street.feb16, kde.street.m316, main='Street')
plot(kde.burglary.feb16, kde.burglary.m316, main='Burglaries')
plot(kde.vehicle.feb16, kde.vehicle.m316, main='Vehicle')
title("Density Feb 2016 vs. Months of Mar, Apr and May 2016", outer=TRUE)
dev.off()

# =============================================================================
# SPEARMAN CORRELATIONS
# =============================================================================

spearman = setDF(lapply(setNames(
  nm = c('all', 'street', 'burglary', 'vehicle')),
  function(type) { ge = .GlobalEnv
    sapply(mget(ls(pattern = '^kde.' %+% type %+% '.[mw]', 
                   envir = ge), envir = ge),
           cor, x = get('kde.' %+% type %+% '.feb16', envir = ge), 
           method = 'spearman', use = 'pairwise.complete.obs')}),
  rownames = c('w1','w2','m1','m2','m3'))

stargazer(spearman, float = FALSE, summary=FALSE, type = 'text',
          out='tex/tables/spearman.tex', title = 'Spearman Rank Correlations')

# =============================================================================
# GRID DATAFRAME
# =============================================================================
# append kernel densities to the grd.layer SpatialPoligonsDataFrame
grd.layer@data[kde.nms] <- mget(kde.nms <- ls(pattern = "^kde.*16$"))

# =============================================================================
# FORECASTING WITH feb16 DENSITIES
# =============================================================================
area.min <- 6969600 # in square feet
area.max <- 2.09088e+7 # in square feet
area.cell <- prod(grd.grdtop@cellsize)
min.cells <- ceiling(area.min/area.cell)
max.cells <- floor(area.max/area.cell)

pdf('tex/figures/max_areas.pdf')
par(mfrow=c(2,2), mar=c(1,1,1,1))
rank.all <- head(order(grd.layer$kde.all.feb16, decreasing = TRUE),
                 max.cells)
plot(portland.bdy.simp, main='All')
plot(grd.layer[rank.all, ], add=TRUE, col='red', lwd=0.3)

rank.street <- head(order(grd.layer$kde.street.feb16, decreasing = TRUE),
                    max.cells)
plot(portland.bdy.simp, main='Street')
plot(grd.layer[rank.street, ], add=TRUE, col='red', lwd=0.3)

rank.burglary <- head(order(grd.layer$kde.burglary.feb16, decreasing = TRUE),
                      max.cells)
plot(portland.bdy.simp, main='Burglary')
plot(grd.layer[rank.burglary, ], add=TRUE, col='red', lwd=0.3)

rank.vehicle <- head(order(grd.layer$kde.vehicle.feb16, decreasing = TRUE),
                     max.cells)
plot(portland.bdy.simp, main='Vehicle')
plot(grd.layer[rank.vehicle, ], add=TRUE, col='red', lwd=0.3)

mtext('Maximum Forecasted Areas, cell size 600x600', outer = TRUE, cex = 1)
dev.off()

# =============================================================================
# Investigating Sensitivity of Rankings
# =============================================================================

BB = 100L

df = crimes.map.feb16
boot.ranks.all = table2(unlist(lapply(integer(BB), function(...) 
  head(order(spkernel2d(
    pts = df[sample.int(length(df), replace = TRUE), ], 
    h0 = bw, grd = grd.grdtop, 
    poly = portland.bdy.simp@polygons[[1L]]@Polygons[[1L]]@coords),
    decreasing = TRUE), max.cells))), ord = "dec")

df = crimes.map.feb16[crimes.map.feb16$category == 'STREET CRIMES', ]
boot.ranks.street = table2(unlist(lapply(integer(BB), function(...) 
  head(order(spkernel2d(
    pts = df[sample.int(length(df), replace = TRUE), ], 
    h0 = bw, grd = grd.grdtop, 
    poly = portland.bdy.simp@polygons[[1L]]@Polygons[[1L]]@coords),
    decreasing = TRUE), max.cells))), ord = "dec")

df = crimes.map.feb16[crimes.map.feb16$category == 'BURGLARY', ]
boot.ranks.burglary = table2(unlist(lapply(integer(BB), function(...) 
  head(order(spkernel2d(
    pts = df[sample.int(length(df), replace = TRUE), ], 
    h0 = bw, grd = grd.grdtop, 
    poly = portland.bdy.simp@polygons[[1L]]@Polygons[[1L]]@coords),
    decreasing = TRUE), max.cells))), ord = "dec")
  
df = crimes.map.feb16[crimes.map.feb16$category == 'MOTOR VEHICLE THEFT', ]
boot.ranks.vehicle = table2(unlist(lapply(integer(BB), function(...) 
  head(order(spkernel2d(
    pts = df[sample.int(length(df), replace = TRUE), ], 
    h0 = bw, grd = grd.grdtop, 
    poly = portland.bdy.simp@polygons[[1L]]@Polygons[[1L]]@coords),
    decreasing = TRUE), max.cells))), ord = "dec")
  
## Plotting
pdf2('tex/figures/max_areas_boot.pdf')
par(mfrow = c(2L, 2L), mar = c(1,1,1,1))

rnk = unique(boot.ranks.all)
cols = colorRampPalette(c("red", "white"))(length(rnk))
plot(portland.bdy.simp, main = 'All')
plot(grd.layer[as.integer(names(boot.ranks.all)), ], add=TRUE,
     col = cols[match(boot.ranks.all, rnk)], lwd = 0.3)

rnk = unique(boot.ranks.street)
cols = colorRampPalette(c("red", "white"))(length(rnk))
plot(portland.bdy.simp, main='Street')
plot(grd.layer[as.integer(names(boot.ranks.street)), ], add=TRUE,
     col = cols[match(boot.ranks.street, rnk)], lwd = 0.3)

rnk = unique(boot.ranks.burglary)
cols = colorRampPalette(c("red", "white"))(length(rnk))
plot(portland.bdy.simp, main='Burglary')
plot(grd.layer[as.integer(names(boot.ranks.burglary)), ], add=TRUE,
     col = cols[match(boot.ranks.burglary, rnk)], lwd = 0.3)

rnk = unique(boot.ranks.vehicle)
cols = colorRampPalette(c("red", "white"))(length(rnk))
plot(portland.bdy.simp, main='Vehicles')
plot(grd.layer[as.integer(names(boot.ranks.vehicle)), ], add=TRUE,
     col = cols[match(boot.ranks.vehicle, rnk)], lwd = 0.3)

mtext('Maximum Forecasted Areas, cell size 600x600\n' %+% 
        'Sensitivity Testing via Bootstrap', outer = TRUE)
dev.off2()

# =============================================================================
# ZOOMED IN FORECAST
# ============================================================================

# select crimes in feb16 within bbox of hotspot cells:
rank.all <- order(grd.layer$kde.all.feb16, decreasing = TRUE)
forecast.all <- grd.layer[rank.all,][1:max.cells, ]
forecast.all.bbox <- bbox(forecast.all)
forecast.all.bbox.poly <- as(extent(forecast.all.bbox), 'SpatialPolygons')
forecast.all.bbox.poly.buf <- buffer(forecast.all.bbox.poly, 2000)
proj4string(forecast.all.bbox.poly) <- CRS(proj4string(crimes.map))
select.all <- gIntersection(crimes.map[crimes.map$occ_year==2016 & crimes.map$occ_month == 2, ], 
                            forecast.all.bbox.poly.buf)

# create SpatialGridDataFrame with data from grd.layer (kdes) in order to create a raster layer:
grd.grddf <- SpatialGridDataFrame(grd.grdtop, data = grd.layer@data, 
                                  proj4string = CRS(proj4string(crimes.map)))
grd.ras <- raster(grd.grddf)
grd.ras[] <- grd.layer$kde.all.feb16
grd.ras <- crop(grd.ras, forecast.all.bbox.poly.buf)

pdf2('tex/figures/hotspot_all.pdf')
c(mfrow=c(1,1), mar=c(3,3,3,3))
plot(grd.ras)
plot(forecast.all.bbox.poly.buf, add=TRUE)
plot(forecast.all, add=TRUE, border='red', lwd=2)
plot(select.all, add=TRUE)
title('Hotspot for All Crimes, Feb 2016', outer = FALSE)
dev.off2()

# ============================================================================
# STREET MAPS
# ============================================================================

streets <- readOGR("./data/PortlandStreets/", layer='streets_pdx')
streets <- spTransform(streets, CRS(proj4string(crimes.map)))
dim(streets)

plot(streets)
plot(portland.bdy.simp, border='red', add=TRUE)

N <- length(crimes.map)
crimes.map.small <- crimes.map[sample(N, .1*N),]

dist <- numeric(nrow(crimes.map.small))
for (i in 1:length(crimes.map.small)) {
  dist[i] <- gDistance(crimes.map.small[i,], streets)  
}
bins <- seq(0, 500, 10)
dist.cut <- cut(dist, 
                breaks = bins,
                right = FALSE)

barplot(table(dist.cut), las=2, cex.names=0.5)

crimes.small <- to.data.table(crimes.map.small)
crimes.small[, dist:=dist]

crimes.dist <- crimes.small[, .(mean.dist = mean(dist),
                 q1.dist = quantile(dist, .25),
                 med.dist = median(dist),
                 q3.dist = quantile(dist, .75),
                 q95 = quantile(dist, .95),
                 q99 = quantile(dist, .99)), by=category]
crimes.dist
write.csv(crimes.dist, file = '../dist_table.csv')


# # ============================================================================
# # MINIMUM AREAS
# # ============================================================================
# # week 1:
# par(mfrow=c(1,1)); par(mfrow=c(5,4), mar=c(2,3,1,1))
# plot(kde.all.w116[order(-kde.all.w116)], type='l', xlim=c(0,1000),
#      main='All', ylab='w1')
# abline(v=c(min.cells, max.cells), col='red')
# 
# plot(kde.street.w116[order(-kde.street.w116)], type='l', xlim=c(0,1000),
#      main='Street')
# abline(v=c(min.cells, max.cells), col='red')
# 
# plot(kde.burglary.w116[order(-kde.burglary.w116)], type='l', xlim=c(0,1000),
#      main='Burglary')
# abline(v=c(min.cells, max.cells), col='red')
# 
# plot(kde.vehicle.w116[order(-kde.vehicle.w116)], type='l', xlim=c(0,1000),
#      main='Vehicle')
# abline(v=c(min.cells, max.cells), col='red')
# 
# # week 2
# plot(kde.all.w216[order(-kde.all.w216)], type='l', xlim=c(0,1000))
# abline(v=c(min.cells, max.cells), col='red')
# 
# plot(kde.street.w216[order(-kde.street.w216)], type='l', xlim=c(0,1000))
# abline(v=c(min.cells, max.cells), col='red')
# 
# plot(kde.burglary.w216[order(-kde.burglary.w216)], type='l', xlim=c(0,1000))
# abline(v=c(min.cells, max.cells), col='red')
# 
# plot(kde.vehicle.w216[order(-kde.vehicle.w216)], type='l', xlim=c(0,1000))
# abline(v=c(min.cells, max.cells), col='red')
# 
# # month 1:
# plot(kde.all.m116[order(-kde.all.m116)], type='l', xlim=c(0,1000))
# abline(v=c(min.cells, max.cells), col='red')
# 
# plot(kde.street.m116[order(-kde.street.m116)], type='l', xlim=c(0,1000))
# abline(v=c(min.cells, max.cells), col='red')
# 
# plot(kde.burglary.m116[order(-kde.burglary.m116)], type='l', xlim=c(0,1000))
# abline(v=c(min.cells, max.cells), col='red')
# 
# plot(kde.vehicle.m116[order(-kde.vehicle.m116)], type='l', xlim=c(0,1000))
# abline(v=c(min.cells, max.cells), col='red')
# 
# # month 2:
# plot(kde.all.m216[order(-kde.all.m216)], type='l', xlim=c(0,1000))
# abline(v=c(min.cells, max.cells), col='red')
# 
# plot(kde.street.m216[order(-kde.street.m216)], type='l', xlim=c(0,1000))
# abline(v=c(min.cells, max.cells), col='red')
# 
# plot(kde.burglary.m216[order(-kde.burglary.m216)], type='l', xlim=c(0,1000))
# abline(v=c(min.cells, max.cells), col='red')
# 
# plot(kde.vehicle.m216[order(-kde.vehicle.m216)], type='l', xlim=c(0,1000))
# abline(v=c(min.cells, max.cells), col='red')
# 
# # month 3:
# plot(kde.all.m316[order(-kde.all.m316)], type='l', xlim=c(0,1000))
# abline(v=c(min.cells, max.cells), col='red')
# 
# plot(kde.street.m316[order(-kde.street.m316)], type='l', xlim=c(0,1000))
# abline(v=c(min.cells, max.cells), col='red')
# 
# plot(kde.burglary.m316[order(-kde.burglary.m316)], type='l', xlim=c(0,1000))
# abline(v=c(min.cells, max.cells), col='red')
# 
# plot(kde.vehicle.m316[order(-kde.vehicle.m316)], type='l', xlim=c(0,1000))
# abline(v=c(min.cells, max.cells), col='red')

# =============================================================================
# Calculating Competition Metric in 2016
# =============================================================================

## One-Month Horizon
crimes.mar16 = 
  crimes.map[with(crimes.map@data, occ_year == 2016 & occ_month == 3), ]

### for _maximum_ forecasted area
a.all = grd.layer[rank.all, ]
a.street = grd.layer[rank.street, ]
a.burglary = grd.layer[rank.burglary, ]
a.vehicle = grd.layer[rank.vehicle, ]

max.a = c(
  pai(n = sum(!is.na(`$`(crimes.mar16 %over% a.all, ID))),
      N = length(crimes.mar16), a = gArea(a.all), A = gArea(portland.bdy)),
  pai(n = sum(!is.na(`$`(crimes.mar16[crimes.mar16$category ==
                                        'STREET CRIMES', ] %over% a.all, ID))),
      N = length(crimes.mar16), a = gArea(a.all), A = gArea(portland.bdy)),
  pai(n = sum(!is.na(`$`(crimes.mar16[crimes.mar16$category ==
                                        'BURGLARY', ] %over% a.all, ID))),
      N = length(crimes.mar16), a = gArea(a.all), A = gArea(portland.bdy)),
  pai(n = sum(!is.na(`$`(
    crimes.mar16[crimes.mar16$category ==
                   'MOTOR VEHICLE THEFT', ] %over% a.all, ID))),
    N = length(crimes.mar16), a = gArea(a.all), A = gArea(portland.bdy))
)

### for _minimum_ forecasted area
a.all = grd.layer[rank.all[1L:min.cells], ]
a.street = grd.layer[rank.street[1L:min.cells], ]
a.burglary = grd.layer[rank.burglary[1L:min.cells], ]
a.vehicle = grd.layer[rank.vehicle[1L:min.cells], ]

min.a = c(
  pai(n = sum(!is.na(`$`(crimes.mar16 %over% a.all, ID))),
      N = length(crimes.mar16), a = gArea(a.all), A = gArea(portland.bdy)),
  pai(n = sum(!is.na(`$`(crimes.mar16[crimes.mar16$category ==
                                        'STREET CRIMES', ] %over% a.all, ID))),
      N = length(crimes.mar16), a = gArea(a.all), A = gArea(portland.bdy)),
  pai(n = sum(!is.na(`$`(crimes.mar16[crimes.mar16$category ==
                                        'BURGLARY', ] %over% a.all, ID))),
      N = length(crimes.mar16), a = gArea(a.all), A = gArea(portland.bdy)),
  pai(n = sum(!is.na(`$`(
    crimes.mar16[crimes.mar16$category ==
                   'MOTOR VEHICLE THEFT', ] %over% a.all, ID))),
    N = length(crimes.mar16), a = gArea(a.all), A = gArea(portland.bdy))
)
  
png("~/Desktop/pai.m1.png")
barplot(matrix(c(max.a, min.a), nrow = 2L, byrow = TRUE),
        beside = TRUE, col = c('darkgreen', 'red'),
        names.arg = c('All', 'Street', 'Burglary', 'Vehicle'),
        main = 'PAI for One-Month Horizon\n' %+% 
          'Maximum vs. Minimum Forecasted Area')
dev.off()

## One-Week Horizon
crimes.marw1 = 
  crimes.map[crimes.map$occ_date %between% D('2016-03-01', '2016-03-06'), ]

### for _maximum_ forecasted area
a.all = grd.layer[rank.all, ]
a.street = grd.layer[rank.street, ]
a.burglary = grd.layer[rank.burglary, ]
a.vehicle = grd.layer[rank.vehicle, ]

max.a = c(
  pai(n = sum(!is.na(`$`(crimes.marw1 %over% a.all, ID))),
      N = length(crimes.marw1), a = gArea(a.all), A = gArea(portland.bdy)),
  pai(n = sum(!is.na(`$`(crimes.marw1[crimes.marw1$category ==
                                        'STREET CRIMES', ] %over% a.all, ID))),
      N = length(crimes.marw1), a = gArea(a.all), A = gArea(portland.bdy)),
  pai(n = sum(!is.na(`$`(crimes.marw1[crimes.marw1$category ==
                                        'BURGLARY', ] %over% a.all, ID))),
      N = length(crimes.marw1), a = gArea(a.all), A = gArea(portland.bdy)),
  pai(n = sum(!is.na(`$`(
    crimes.marw1[crimes.marw1$category ==
                   'MOTOR VEHICLE THEFT', ] %over% a.all, ID))),
    N = length(crimes.marw1), a = gArea(a.all), A = gArea(portland.bdy))
)

### for _minimum_ forecasted area
a.all = grd.layer[rank.all[1L:min.cells], ]
a.street = grd.layer[rank.street[1L:min.cells], ]
a.burglary = grd.layer[rank.burglary[1L:min.cells], ]
a.vehicle = grd.layer[rank.vehicle[1L:min.cells], ]

min.a = c(
  pai(n = sum(!is.na(`$`(crimes.marw1 %over% a.all, ID))),
      N = length(crimes.marw1), a = gArea(a.all), A = gArea(portland.bdy)),
  pai(n = sum(!is.na(`$`(crimes.marw1[crimes.marw1$category ==
                                        'STREET CRIMES', ] %over% a.all, ID))),
      N = length(crimes.marw1), a = gArea(a.all), A = gArea(portland.bdy)),
  pai(n = sum(!is.na(`$`(crimes.marw1[crimes.marw1$category ==
                                        'BURGLARY', ] %over% a.all, ID))),
      N = length(crimes.marw1), a = gArea(a.all), A = gArea(portland.bdy)),
  pai(n = sum(!is.na(`$`(
    crimes.marw1[crimes.marw1$category ==
                   'MOTOR VEHICLE THEFT', ] %over% a.all, ID))),
    N = length(crimes.marw1), a = gArea(a.all), A = gArea(portland.bdy))
)
  
png("~/Desktop/pai.w1.png")
barplot(matrix(c(max.a, min.a), nrow = 2L, byrow = TRUE),
        beside = TRUE, col = c('darkgreen', 'red'),
        names.arg = c('All', 'Street', 'Burglary', 'Vehicle'),
        main = 'PAI for One-Week Horizon\n' %+% 
          'Maximum vs. Minimum Forecasted Area')
dev.off()
