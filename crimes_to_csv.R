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

fwrite(crimes, "crimes.csv")
