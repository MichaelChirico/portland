library(maptools)
library(rgeos)
library(data.table)

portland.bdy <- gBuffer(
  readShapePoly("data/portland_boundary", 
                proj4string = CRS("+init=epsg:2913")), 
  width = 500
)
fwrite(as.data.table(portland.bdy@polygons[[1L]]@Polygons[[1L]]@coords),
       'data/portland_coords.csv')
