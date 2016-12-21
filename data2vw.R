rm(list = ls())
setwd('~/Dropbox/0_Penn/Research/crime_prediction/portland/')

library(data.table)
library(funchir)
library(foreign)
library(maptools)
library(rgeos)
library(spatstat)
library(GISTools)
library(sp)
library(raster)
library(rgdal)
library(splancs)

#Create an R Project in your local directory, and all of
#  these relative paths will work out of the box
wds <- c(data = "./data")

# ============================================================================
# FUNCTIONS
# ============================================================================
compute.kdes <- function(DT, poly, h0, grd){
  kde.all = 
    nml(spkernel2d(pts = DT, poly = poly, h0 = h0, grd = grd))
  kde.street =
    nml(spkernel2d(pts = DT[DT$category=='STREET CRIMES', ],
                   poly = poly, h0 = h0, grd = grd))
  kde.burglary = 
    nml(spkernel2d(pts = DT[DT$category=='BURGLARY', ], 
                   poly = poly, h0 = h0, grd = grd))
  kde.vehicle = 
    nml(spkernel2d(pts = DT[DT$category=='MOTOR VEHICLE THEFT', ],
                   poly = poly, h0 = h0, grd = grd))
  data.table(id = 'g' %+% 1L:prod(grd@cells.dim),
             all = kde.all, street = kde.street,
             burglary = kde.burglary, vehicle = kde.vehicle)
}

pts = function(DT) DT[ , cbind(x_coordina, y_coordina)]
nml = function(x) x/sum(x, na.rm = TRUE)
pai = function(a, n, N, A) (n/N)/(a/A)

# ============================================================================
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

# ============================================================================
# LOAD DATA
# - crimes shapefiles
# - portlan shapefile
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
crimes[ , occ_mo_1st := occ_date - mday(occ_date) + 1L] # First-of-the-month containing occ_date
crimes[ , occ_wed := occ_date - occ_wday + 4L] # Wednesday of the week containing occ_date

prj = CRS("+init=epsg:2913")
crimes.sp <- to.map(crimes, pct=1)

#----------------------------------------------------------------------------
portland <- readShapePoly("./data/Portland_Police_Districts.shp", 
                          proj4string = prj)

portland.bdy <- gUnaryUnion(portland)

## get outer bounds of Portland (http://stackoverflow.com/questions/12663263)
outerRings <- Filter(function(pol) pol@ringDir==1, 
                     portland.bdy@polygons[[1L]]@Polygons)
outerBounds <- SpatialPolygons(list(Polygons(outerRings, ID=1)))
port.coord <- outerRings[[5]]@coords

## simplified portlan boundary (got here by trial and error;
##   portland.bdy consist of 5 polys)
portland.bdy.simp <- 
  SpatialPolygons(list(Polygons(list(
    outerBounds@polygons[[1]]@Polygons[[5]]),ID=1)))

bb <- bbox(portland)

# ============================================================================
# GRID
# ============================================================================
dims <- c(600, 600)
ncells <- round(apply(bb, 1L, diff)/dims)

grd <- GridTopology(cellcentre.offset = bb[ , 'min'] + dims/2,
                   cellsize = dims,
                   cells.dim = ncells)

grd.sp <- as.SpatialPolygons.GridTopology(grd, proj4string = prj)

grd.sp <-
  SpatialPolygonsDataFrame(
    grd.sp, data = data.frame(grdid = rownames(coordinates(grd.sp))),
    match.ID = FALSE
  )

# load grid
# grd.sp <- readShapePoly("./data/grids/rec600x600.shp", proj4string = prj)

# ============================================================================
# AGGREGATE DATA
# - need to decide aggregating frequency (week?)
# ============================================================================
grd.id <- over(crimes.sp, grd.sp)
crimes.sp$grdid <- grd.id$grdid

# check
# plot(grd.sp)
plot(portland.bdy)
plot(gBuffer(grd.sp[grd.sp$grdid == crimes.sp[1L, ]$grdid, ], width=500), col='red', add=TRUE)
plot(crimes.sp[1L, ], add=TRUE)

# drop crimes outside the city
crimes.sp <- crimes.sp[!is.na(crimes.sp$grdid), ]

crimes.dt <- to.data.table(sp = crimes.sp)
crimes.agg <- crimes.dt[, .N, by=.(grdid, occ_year, occ_wed)]

# create factor variables
crimes.agg[, `:=`(grdid = as.factor(grdid),
                  occ_year = as.factor(occ_year))]

# ============================================================================
# CREATE DUMMY VARIABLES
# ============================================================================
# library(caret)
# dummies <- dummyVars("~.",data=crimes.agg, fullRank=F)
# predict(dummies, crimes.agg)

# ============================================================================
# GENERATE KDE ESTIMATES
# will use the KDE estimate of each cell as a feuture in the vw model
# ============================================================================
# # weekly estimates
# crimes.dt <- to.data.table(crimes.sp) 
# crimes.agg.week <- crimes.dt[, .N, by=.(occ_year, occ_wed, grdid, category)]
# crimes.agg.week <- dcast(crimes.agg.week, occ_year + occ_wed + grdid ~ category, fill = 0, value.var = 'N')

# using all data pooled
kdes <- compute.kdes(crimes.sp, port.coord, h0 = 1000, grd = grd)

grd.df <- SpatialGridDataFrame(grd, data = kdes)

grd.ras <- brick(grd.df)
par(mfrow=c(1,1))
plot(grd.ras$all)
plot(portland.bdy, add=T)
plot(crimes.sp[sample(1:nrow(crimes.sp), 1000), ], add=T)

# merge kde estimations with aggregate data:
crimes.agg <- merge(crimes.agg, kdes, by.x='grdid', by.y='id', all.x=TRUE)
# top.all <- kdes[order(-all), id][1:50]
# plot(portland.bdy)
# plot(grd.sp[grd.sp$grdid %in% top.all, ], add=T)
# plot(grd.sp[grd.sp$grdid %in% crimes.agg[is.na(all), grdid],], add=T, col='red')

crimes.agg[is.na(all), all := 0]
crimes.agg[is.na(street), street := 0]
crimes.agg[is.na(burglary), burglary := 0]
crimes.agg[is.na(vehicle), vehicle := 0]

grd.df <- SpatialGridDataFrame(grd, data = kdes)
# par(mfrow=c(1,1))
# spplot(grd.df, checkEmptyRC=FALSE, col.regions=terrain.colors(16), cuts=15)

# ============================================================================
# PARSE TO VOWPAL WABBIT
# ============================================================================
crimes.agg[, vw_all := paste(N, '|', grdid, occ_year, 'kde:', all)]
crimes.agg[, vw_street := paste(N, '|', grdid, occ_year, 'kde:', street)]
crimes.agg[, vw_burglary := paste(N, '|', grdid, occ_year, 'kde:', burglary)]
crimes.agg[, vw_vehicle := paste(N, '|', grdid, occ_year, 'kde:', vehicle)]

# split into training and test sets
crimes.agg.train <- crimes.agg[occ_wed < '2016-03-01',]
crimes.agg.test <- crimes.agg[occ_wed >= '2016-03-01' & occ_wed < '2016-03-15', ]


for (variable in c('vw_all','vw_street','vw_burglary','vw_vehicle')){
  write.table(crimes.agg.train[, get(variable)], paste0('data/vowpal/', variable,'_train.vw'), row.names = FALSE, quote = FALSE, col.names = FALSE)
  write.table(crimes.agg.test[, get(variable)], paste0('data/vowpal/', variable,'_test.vw'), row.names = FALSE, quote = FALSE, col.names = FALSE)
}

# ============================================================================
# ASSESS TEST DATA
# ============================================================================
# list.files('data/vowpal/')
# test <- fread('data/vowpal/test.pred')
# setnames(test, 'V1','pred')
# 
# test[, true := crimes.agg.test$N]
# test[, plot(true, pred)]
















