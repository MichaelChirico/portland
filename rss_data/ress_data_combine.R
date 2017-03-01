setwd('~/Dropbox/0_Penn/Research/crime_prediction/portland/rss_data/')

# parse XML

library(rvest)
library(data.table)

# first XML

x = readLines('./911incidents.cfm')
x = gsub('&lt;', '<', x, fixed = TRUE)
x = gsub('&gt;', '>', x, fixed = TRUE)

x = read_html(paste(x, collapse = '\n'))

xy = x %>% html_nodes(xpath = '//entry/point') %>% html_text %>%
  strsplit(' ') %>% transpose %>% setDT
# x %>% html_nodes(xpath = '//content/dl/dd[5]') %>% html_text %>% 
x_id = x %>% html_nodes(xpath = '//entry/id') %>% html_text %>% 
  strsplit('/') %>% lapply(tail, n=1L) %>% transpose
xy[ , id := x_id]
ct = x %>% html_nodes(xpath = '//content/dl/dd[2]') %>% html_text
xy[ , call_type := ct]

# second spreadsheet
z = readLines('./911incidents_2.cfm')
z = gsub('&lt;', '<', z, fixed = TRUE)
z = gsub('&gt;', '>', z, fixed = TRUE)
z = gsub('&gt;', '>', z, fixed = TRUE)

z = read_html(paste(z, collapse = '\n'))
zy = z %>% html_nodes(xpath = '//entry/point') %>% html_text %>%
  strsplit(' ') %>% transpose %>% setDT

z_id = z %>% html_nodes(xpath = '//entry/id') %>% html_text %>% 
  strsplit('/') %>% lapply(tail, n=1L) %>% transpose
zy[ , id := z_id]

ct = z %>% html_nodes(xpath = '//content/dl/dd[2]') %>% html_text
zy[ , call_type := ct]

xz = rbind(xy, zy)
print(paste('# of duplicates =',xz[, .N, by=id][N==2, .N]))
# xz = xz[xz[, .N, by=id][, N==1]]
xz = unique(xz, by='id')
setnames(xz, c('V1','V2'), c('y_coordina', 'x_coordina'))

# from spreadsheet

charles = fread('./charles_geocode.csv')
setnames(charles, c('lon','lat'), c('x_coordina','y_coordina'))
charles[, call_type := sapply(call_type, toupper)]
charles = charles[, .(call_type, x_coordina, y_coordina)]

# combine spreadsheet data with xml
xz[, id := NULL]
comb = rbind(xz, charles)
comb[, .N, by=.(x_coordina, y_coordina, call_type)][N>1]

# load crimes data

library(data.table)
library(foreign)
library(zoo)
library(sp)
library(rgeos)
library(maptools)
library(data.table)

crimes = rbindlist(lapply(list.files(
  "../data", pattern = "^NIJ.*\\.dbf", full.names = TRUE),
  #as.is = TRUE is equivalent to stringsAsFactors = FALSE;
  #  also, some missing data snuck in on one line
  read.dbf, as.is = TRUE))[!is.na(occ_date)]

# match categories

descr = crimes[, .(CATEGORY, CALL_GROUP, CASE_DESC)]
descr = unique(descr)

comb = comb[descr, CATEGORY:=i.CATEGORY, on=list(call_type=CASE_DESC)]
comb[!is.na(CATEGORY)]

# crs
comb[, x_coordina := as.numeric(x_coordina)]
comb[, y_coordina := as.numeric(y_coordina)]
xsp = SpatialPoints(comb[ , cbind(x_coordina, y_coordina)],
                    proj4string = CRS('+init=epsg:4326'))

proj4string(xsp)
xsp = spTransform(xsp, CRS("+init=epsg:2913"))

comb[, x_coordina := xsp@coords[,1]]
comb[, y_coordina := xsp@coords[,2]]

comb
# save to csv

fwrite(comb, '../data/rss_feed_Feb28.csv')







