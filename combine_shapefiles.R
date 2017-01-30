library(rgdal)
library(maptools)

# Get list of all shape files
#------------------------------------------------------------

files <- list.files(path='data', pattern=".*NIJ.*\\.shp$", recursive=TRUE,full.names=TRUE)



# Get points from first file
#-------------------------------------

poly.data<- readOGR(files[1],gsub("^.*/(.*).shp$", "\\1", files[1]))
prj_orig <- proj4string(poly.data)
prj = CRS("+init=epsg:2913")
poly.data <- spTransform(poly.data, prj)

# mapunit points: combin remaining  points with first points
#-----------------------------------------------------------------

for (i in 2:length(files)) {
  print(paste('------------------\\n',files[i]))
  temp.data <- readOGR(files[i], gsub("^.*/(.*).shp$", "\\1",files[i]))
  if (is.na(proj4string(temp.data))) {
    print('   No projection!')
    proj4string(temp.data) <- prj_orig
    temp.data <- spTransform(temp.data, prj)
  } else {
    print('   Changing projection.')
    temp.data <- spTransform(temp.data, prj)
  }
  poly.data <- spRbind(poly.data,temp.data)
}

names(poly.data)
proj4string(poly.data)
nrow(poly.data)

# save data by crime category
#-----------------------------------------------------------------
writeOGR(obj=poly.data, dsn="data/combined", layer="crimes_combined", driver="ESRI Shapefile")
