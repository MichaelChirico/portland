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

#Create an R Project in your local directory, and all of 
#  these relative paths will work out of the box
wds = c(data = "./data")

# Official Contest Data
URL = "http://www.nij.gov/funding/Pages/" %+% 
  "fy16-crime-forecasting-challenge.aspx"

data_links = read_html(URL) %>% 
  #Get all <a href=...> tags, convert to text
  html_nodes(xpath = "//a/@href") %>% html_text() %>%
  #All data files end in .zip
  grep("\\.zip$", ., value = TRUE) %>% 
  #URLS are internal to the nij.gov site, so prepend
  `%+%`("www.nij.gov", .)

#Download data
for (uu in data_links) {
  tmp = tempfile()
  # method = "auto" -> method = "internal" was
  #  returning an error (?)
  download.file(uu, tmp, method = "curl")
  unzip(tmp, exdir = wds["data"])
  unlink(tmp)
}

#Crime shapefiles' data
crimes = rbindlist(lapply(lapply(list.files(
  wds["data"], pattern = "^NIJ.*\\.dbf", full.names = TRUE),
  #as.is = TRUE is equivalent to stringsAsFactors = FALSE
  read.dbf, as.is = TRUE), setDT)
  #also, some missing data snuck in on one line
  )[!is.na(occ_date)]
setnames(crimes, tolower(names(crimes)))
crimes[ , occ_date := as.IDate(occ_date)]

#From cross-referencing the project page,
#  spatialreference.org, and prj2epsg.org,
#  determined the following common CRS for
#  all project-associated shapefiles
prj = CRS("+init=epsg:2913")
crimes_map = 
  crimes[ , SpatialPointsDataFrame(
    coords = cbind(x_coordina, y_coordina),
    data = .SD[ , !(c("x", "y") %+% "_coordina"), with = FALSE],
    proj4string = prj)]

#Working on a more manageable subsample of crimes for now
crimes_map2 = 
  crimes[sample(.N, .1*.N), 
         SpatialPointsDataFrame(
           coords = cbind(x_coordina, y_coordina),
           data = .SD[ , !(c("x", "y") %+% "_coordina"), with = FALSE],
           proj4string = prj)]

portland = readShapePoly("./data/Portland_Police_Districts.shp", 
                         proj4string = prj)

#Spatial join -- find the district associated with each crime
crimes_map2@data[ , c("district", "precinct")] = 
  (crimes_map2 %over% portland)[ , c("DISTRICT", "PRECINCT")]

#Some observations outside the police district boundaries presented
crimes_map2 = crimes_map2[!is.na(crimes_map2$precinct), ]

#Creating some grids
lims = bbox(portland) #units: feet

## Using rectangles, what are the minimum and maximum number of
##   equal (rectangular) subdivisions of the bounding box?
sqrt(prod(apply(lims, 1L, diff)))/c(600, 250)

rec_grid = function(n_div)
  #generate a gridding of Portland bounding box which divides both
  #  x & y directions n_div number of times equally
  gIntersection(as(SpatialGrid(GridTopology(
    cellcentre.offset = lims[ , "min"],
    cellsize = apply(lims, 1L, diff)/n_div,
    cells.dim = c(n_div, n_div)), 
    proj4string = prj), "SpatialPolygons"), 
    gUnaryUnion(portland), byid = TRUE)

grd50 = rec_grid(50)
grd50 = 
  SpatialPolygonsDataFrame(
    grd50, data = data.frame(ID = 1:length(grd50),
      row.names = sapply(grd50@polygons, slot, "ID")))
grd50@data = setDT(grd50@data)

plot(portland, col = "red", border = "black")
plot(grd_50, border = "yellow", add = TRUE)
plot(crimes_map2, add = TRUE)

crimes_map2@data$year = with(crimes_map2@data, year(occ_date))

cols = colorRampPalette(c("green", "red"))(10)

par(mfrow = c(2, 3))
for (yr in sort(unique(crimes_map2@data$year))) {
  new_var = "crimes" %+% yr
  grd50@data[grd50@data[ , 
    .SD[(crimes_map2[crimes_map2$year == yr, ] %over% grd50), on = "ID"][ , .N, ID]],
    (new_var) := i.N, on = "ID"][is.na(get(new_var)), (new_var) := 0]
  plot(grd50, col = grd50@data[ , cols[ceiling(10*ecdf(get(new_var))(get(new_var)))]],
       main = yr)
}