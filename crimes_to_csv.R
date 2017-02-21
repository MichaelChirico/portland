# Forecasting Crime in Portland
# ** Convert crimes .dbf to .csv **
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
library(data.table)
library(foreign)
library(zoo)
library(sp)
library(rgeos)
library(maptools)

crimes = rbindlist(lapply(list.files(
  "./data", pattern = "^NIJ.*\\.dbf", full.names = TRUE),
  #as.is = TRUE is equivalent to stringsAsFactors = FALSE;
  #  also, some missing data snuck in on one line
  read.dbf, as.is = TRUE))[!is.na(occ_date)]

#number of weeks before March 1, 2017
crimes[ , week_no := unclass(as.IDate("2017-02-28") - 
                               as.IDate(occ_date)) %/% 7L + 1L]

# number of months before March 2017
crimes[, month_no := round((as.yearmon("2017-03-01") - as.yearmon(occ_date))*12)]

# day of the month
crimes[, day_mo := mday(occ_date)]

# year
crimes[, occ_year := year(occ_date)]

# day = 1 ==> March 1st 2017
# crimes[, day_no := difftime(as.IDate(paste(occ_year,'03-01', sep='-')), 
#                             occ_date, 
#                             units = 'days')
# ]

crimes[, day_no := difftime(as.IDate('2017-03-01'), occ_date, units='days')]

# numerate forecasting period years
#  (sounds weird but it's useful to compute
#  the AR kdes. This way we can group by 
#  lag number and period to compute a given
#  kde lag)
crimes[occ_date %between% c('2017-03-01', '2018-02-28'), fyear := 2018]
crimes[occ_date %between% c('2016-03-01', '2017-02-28'), fyear := 2017]
crimes[occ_date %between% c('2015-03-01', '2016-02-29'), fyear := 2016]
crimes[occ_date %between% c('2014-03-01', '2015-02-28'), fyear := 2015]
crimes[occ_date %between% c('2013-03-01', '2014-02-28'), fyear := 2014]
crimes[occ_date %between% c('2012-03-01', '2013-02-28'), fyear := 2013]


# ============================================================================
# REMOVE POINTS OUTSIDE BORDERS
# ============================================================================
# create Spatial Points Data Frame
prj = CRS(prjs <- "+init=epsg:2913")
crimes.sp = SpatialPoints(
  coords = crimes[ , cbind(x_coordina, y_coordina)],
  proj4string = prj
)

# load portland boundary
portland.bdy <- 
  readShapePoly("data/portland_boundary", 
                proj4string = CRS("+init=epsg:2913"))

# slect crimes within city boundaries
idx = over(crimes.sp, portland.bdy)$dummy
crimes = crimes[!is.na(idx)]

fwrite(crimes, "crimes_all.csv")
crimes.split = split(crimes, by = "CATEGORY")
fwrite(crimes.split[["STREET CRIMES"]], "crimes_str.csv")
fwrite(crimes.split[["BURGLARY"]], "crimes_bur.csv")
fwrite(crimes.split[["MOTOR VEHICLE THEFT"]], "crimes_veh.csv")
