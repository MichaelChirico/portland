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

#Create an R Project in your local directory, and all of
#  these relative paths will work out of the box
setwd('~/Dropbox/0_Penn/Research/crime_prediction/portland/')
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
  dt <- data.table(data.frame(sp))
  cbind(dt, coords)
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
# KDE PLOTS
# ============================================================================

# some styling palettes:
norm_palette <- colorRampPalette(c("white","red"))
pal_opaque <- norm_palette(15)
pal_trans <- norm_palette(15)
pal_trans[1] <- "#FFFFFF00" #was originally "#FFFFFF" 

# define a bandwidth:
# h <- sd(crimes.map$x_coordina)*(2/(3*length(crimes.map)))^(1/6)


# TOTAL CRIMES:
crimes.map.dens <- kde.points(crimes.map, lims=portland)

# units to counts:
N = nrow(crimes.map.dens)
crimes.map.dens@data <- crimes.map.dens@data * N
plot(crimes.map.dens, col=pal_opaque)
masker <- poly.outer(crimes.map.dens, portland, extend=100)
add.masking(masker)
plot(portland, add=TRUE)

# BURGLARY:
crimes.burglary <- crimes.map[crimes.map$category=='BURGLARY',]
crimes.burglary.dens <- kde.points(crimes.burglary, lims=portland)
plot(crimes.burglary.dens, col=pal_opaque)
masker <- poly.outer(crimes.burglary.dens, portland, extend=100)
add.masking(masker)
plot(portland, add=TRUE)

# MOTOR VEHICLE THEFT:
crimes.vehicle <- crimes.map[crimes.map$category=='MOTOR VEHICLE THEFT',]
crimes.vehicle.dens <- kde.points(crimes.vehicle, lims=portland)
plot(crimes.vehicle.dens, col=pal_opaque)
masker <- poly.outer(crimes.vehicle.dens, portland, extend=100)
add.masking(masker)
plot(portland, add=TRUE)

# STREET CRIMES:
crimes.street <- crimes.map[crimes.map$category=='STREET CRIMES',]
crimes.street.dens <- kde.points(crimes.street, lims=portland)
plot(crimes.street.dens, col=pal_opaque)
masker <- poly.outer(crimes.street.dens, portland, extend=100)
add.masking(masker)
plot(portland, add=TRUE)

# OTHER:
crimes.other <- crimes.map[crimes.map$category=='OTHER',]
crimes.other.dens <- kde.points(crimes.other, lims=portland)
plot(crimes.other.dens, col=pal_opaque)
masker <- poly.outer(crimes.other.dens, portland, extend=100)
add.masking(masker)
plot(portland, add=TRUE)

# ============================================================================
# K-FUNCTIONS
# ============================================================================
# for spatstats functions, need to convert to ppp data format:
# ppp objects are defined by a set of coordinates and a window object, and (optionaly) a vector of marks
# in this case the window is the border of portland and the marks is crime category.
win <- as.owin(gUnaryUnion(portland, id=NULL))
crimes.ppp <- as.ppp(coordinates(crimes.map), W = win)
marks(crimes.ppp) <- as.factor(crimes.map$category)

par(mfrow=c(1,1))
par(mar = c(4.2,4.2,4.2,4.2))
kf.all <- Lest(crimes.ppp, correction='border') 
# kf.all.env <- envelope(crimes.ppp, Kest, correction='border')
plot(kf.all)
# plot(kf.all.env)

crimes.ppp.burglary <- crimes.ppp[crimes.map$category=='BURGLARY']
kf.burglary <- Kest(crimes.ppp.burglary, correction='border') 
# kf.burglary.env <- envelope(crimes.ppp.burglary, Kest, correction='border')
plot(kf.burglary)
# plot(kf.burglary.env)

crimes.ppp.vehicle <- crimes.ppp[crimes.map$category=='MOTOR VEHICLE THEFT']
kf.vehicle <- Kest(crimes.ppp.vehicle, correction='border') 
# kf.vehicle.env <- envelope(crimes.ppp.vehicle, Kest, correction='border')
plot(kf.vehicle)
# plot(kf.vehicle.env)

crimes.ppp.street <- crimes.ppp[crimes.map$category=='STREET CRIMES']
kf.street <- Kest(crimes.ppp.street, correction='border') 
# kf.street.env <- envelope(crimes.ppp.street, Kest, correction='border')
plot(kf.street)
# plot(kf.street.env)

crimes.ppp.other <- crimes.ppp[crimes.map$category=='OTHER']
kf.other <- Kest(crimes.ppp.other, correction='border') 
# kf.other.env <- envelope(crimes.ppp.other, Kest, correction='border')
plot(kf.other)
# plot(kf.other.env)

# ============================================================================
# CROSS L-FUNCTIONS
# ============================================================================

ck.burglaryStreet <- Lcross(crimes.ppp, i='BURGLARY', j='STREET CRIMES', correction='border')
plot(ck.burglaryStreet)

ck.burglaryVehicle <- Lcross(crimes.ppp, i='BURGLARY', j='MOTOR VEHICLE THEFT', correction='border')
plot(ck.burglaryVehicle)

ck.burglaryOther <- Lcross(crimes.ppp, i='BURGLARY', j='OTHER', correction='border')
plot(ck.burglaryOther)

ck.vehicleStreet <- Lcross(crimes.ppp, i='MOTOR VEHICLE THEFT', j='STREET CRIMES', correction='border')
plot(ck.vehicleStreet)

ck.vehicleOther <- Lcross(crimes.ppp, i='MOTOR VEHICLE THEFT', j='OTHER', correction='border')
plot(ck.vehicleOther)

ck.streetOther <- Lcross(crimes.ppp, i='STREET CRIMES', j='OTHER', correction='border')
plot(ck.streetOther)

# ============================================================================
# GRID
# ============================================================================

bb <- bbox(portland)
cell.sizex <- 600
cell.sizey <- 600
cell.dimx <- round((bb[1,2] - bb[1,1])/cell.sizex)
cell.dimy <- round((bb[2,2] - bb[2,1])/cell.sizey)

grd <- GridTopology(cellcentre.offset = c(bb[1,1], bb[2,1]),
                    cellsize = c(cell.sizex, cell.sizey),
                    cells.dim = c(cell.dimx, cell.dimy))

# turn grid to SpatialPolygonsDataFrame:
nb.cells = cell.dimx * cell.dimy
grd.layer <- SpatialPolygonsDataFrame(as.SpatialPolygons.GridTopology(grd),
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

plot(grd)
plot(portland.bdy, add=TRUE)

# crimes.count <- poly.counts(crimes.map, grd)

# ============================================================================
# SPATIO-TEMPORAL HISTOGRAMS
# ============================================================================
# 1. assign each crime to a grid cell
# 2. group by weeks and category
# 3. count crimes per cell

# overlay crimes with grid:
idx <- over(crimes.map, grd)
crimes.map$grd.id <- idx$grd.id

# check:
plot(grd[grd$grd.id == crimes.map[1, ]$grd.id, ])
plot(crimes.map[1, ], add=TRUE)

# generate counts by week and grid cell:
crimes <- to.data.table(crimes.map)
counts <- crimes[, .(count = .N), by = .(occ_wed, grd.id, category)]
counts <- dcast(counts, occ_wed + grd.id ~ category, fill=0, value.var = 'count')

# add sum of all crimes per week and grid cell:
counts[, all := rowSums(.SD), by = .(occ_wed, grd.id), 
       .SDcols = c('BURGLARY','MOTOR VEHICLE THEFT','OTHER','STREET CRIMES')]
setnames(counts, sub("\\s", "_", names(counts)))

# number of empty cells per week:
counts[, week_zeros := nrow(grd) - .N, by=.(occ_wed)]
counts[, week_count := .N, by=.(occ_wed)]

# create data.table of weekly zero cell counts:
week.zeros <- counts[, .SD[1, week_zeros], by=occ_wed]
setnames(week.zeros, sub('V1','count', names(week_zeros)))
zeros.total <- week_zeros[, sum(count)]

add.zeros <- function(tab,  zeros.total) {
  # add counts of
  if ('0' %in% names(tab)) {
    tab[1] <- tab[1] + zeros.total
    
  } else {
    tab <- c(0, tab)
    names(tab)[1] <- 0
    tab[1] <- tab[1] + zeros.total
  }
  tab
}

tab.counts <- function(dt, variable, from=NULL, to=NULL){
  date.min <- dt[, min(occ_wed)]
  date.max <- dt[, max(occ_wed)]
  
  if (is.null(from) | is.null(to)){
    from <- date.min
    to <- date.max
  }
  dt <- dt[occ_wed>=from & occ_wed<=to]
  tab <- dt[, table(get(variable))]
  
  # count number of weekly zero cells:
  week.zeros <- dt[, .SD[1, week.zeros], by=occ_wed]
  setnames(week.zeros, sub('V1','count', names(week.zeros)))
  zeros.total <- week.zeros[, sum(count)]
  
  tab <- add.zeros(tab, zeros.total)
  tab
}

# counts for all categories:
date.from <- '2016-02-01'
date.to <- '2016-02-08' 

tab.all <- tab.counts(counts, variable = 'all', from = date.from, to = date.to)
tab.burglaries <- tab.counts(counts, variable = 'BURGLARY', from = date.from, to = date.to)
tab.vehicle <- tab.counts(counts, variable = 'MOTOR_VEHICLE_THEFT', from = date.from, to = date.to)
tab.other <- tab.counts(counts, variable = 'OTHER', from = date.from, to = date.to)
tab.street <- tab.counts(counts, variable = 'STREET_CRIMES', from = date.from, to = date.to)


