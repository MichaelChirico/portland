library(rgdal)
library(rgeos)

portland <- readOGR('data', 'portland')
portland.bdy <- gUnaryUnion(portland)

# simplify boundary
## get outer bounds of Portland
## http://stackoverflow.com/questions/12663263
outerRings <- Filter(function(pol) pol@ringDir==1, 
                     portland.bdy@polygons[[1L]]@Polygons)
outerBounds <- SpatialPolygons(list(Polygons(outerRings, ID=1)))

## simplified portland boundary (got here by trial and error;
##   portland.bdy consist of 5 polys)
portland.bdy.simp <- 
  SpatialPolygons(list(Polygons(list(
    outerBounds@polygons[[1]]@Polygons[[5]]), ID=1)))

# save simplified boundary
portland.bdy.simp <- 
  # need to save using rgdal
  as(portland.bdy.simp, "SpatialPolygonsDataFrame") 
writeOGR(obj=portland.bdy.simp, dsn="data", 
         layer="portland_boundary", driver="ESRI Shapefile")
