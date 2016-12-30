# Forecasting Crime in Portland
# ** Convert crimes .dbf to .csv **
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
library(data.table)
library(foreign)

crimes = rbindlist(lapply(list.files(
  "./data", pattern = "^NIJ.*\\.dbf", full.names = TRUE),
  #as.is = TRUE is equivalent to stringsAsFactors = FALSE;
  #  also, some missing data snuck in on one line
  read.dbf, as.is = TRUE))[!is.na(occ_date)]

#number of weeks before March 1, 2016
crimes[ , week_no := unclass(as.IDate("2016-02-28") - 
                               as.IDate(occ_date)) %/% 7L + 1L]

fwrite(crimes, "crimes_all.csv")
crimes.split = split(crimes, by = "CATEGORY")
fwrite(crimes.split[["STREET CRIMES"]], "crimes_str.csv")
fwrite(crimes.split[["BURGLARY"]], "crimes_bur.csv")
fwrite(crimes.split[["MOTOR VEHICLE THEFT"]], "crimes_veh.csv")
