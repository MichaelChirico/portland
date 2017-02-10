# Forecasting Crime in Portland
# ** Convert crimes .dbf to .csv **
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
library(data.table)
library(foreign)
library(zoo)
library(sp)
library(rgeos)
library(rgdal)

crimes = rbindlist(lapply(list.files(
  "./data", pattern = "^NIJ.*\\.dbf", full.names = TRUE),
  #as.is = TRUE is equivalent to stringsAsFactors = FALSE;
  #  also, some missing data snuck in on one line
  read.dbf, as.is = TRUE))[!is.na(occ_date)]

#number of weeks before March 1, 2016
crimes[ , week_no := unclass(as.IDate("2016-02-29") - 
                               as.IDate(occ_date)) %/% 7L + 1L]

# number of months before March 2016
crimes[, month_no := round((as.yearmon("2016-03-01") - as.yearmon(occ_date))*12)]

# day of the month
crimes[, day_no := mday(occ_date)]

# ============================================================================
# REMOVE POINTS OUTSIDE BORDERS
# ============================================================================
# create Spatial Points Data Frame
prj = CRS(prjs <- "+init=epsg:2913")
crimes.sp = with(crimes,
             SpatialPointsDataFrame(
               coords = cbind(x_coordina, y_coordina),
               data = crimes[, -c('x_coordina','y_coordina'), with=FALSE],
               proj4string = prj
           ))

# load portland boundary
portland = readOGR(dsn='data', layer='Portland_Police_Districts',
                   verbose=FALSE, p4s = prjs)
portland.bdy <- gUnaryUnion(portland)

# slect crimes within city boundaries
idx = over(crimes.sp, portland.bdy) 
crimes = crimes[!is.na(idx)]

fwrite(crimes, "crimes_all.csv")
crimes.split = split(crimes, by = "CATEGORY")
fwrite(crimes.split[["STREET CRIMES"]], "crimes_str.csv")
fwrite(crimes.split[["BURGLARY"]], "crimes_bur.csv")
fwrite(crimes.split[["MOTOR VEHICLE THEFT"]], "crimes_veh.csv")
