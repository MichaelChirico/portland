library(rgeos)
library(data.table)
library(rgdal)

police_districts = 
  readOGR('data', 'Portland_Police_Districts', 
          p4s = "+init=epsg:2913")

portland = gUnaryUnion(gBuffer(
  #buffer to eliminate sand grain holes
  #  (1e6 by trial and elimination)
  police_districts, width = 1e6*.Machine$double.eps
))

#number of polygon constituents
#  (including holes, islands)
npoly = length(portland@polygons[[1L]]@Polygons)
out = which.max(sapply(portland@polygons[[1L]]@Polygons,
                       #ringDir = 1: outer boundary;
                       #ringDir = 2: inner boundary (hole)
                       function(p) if (p@ringDir > 0) nrow(p@coords) else 0))
#extract the actual boundary polygon to a
#  new object (que feo there's gotta be a better way??)
portland.boundary = 
  SpatialPolygons(list(Polygons(list(
    portland@polygons[[1L]]@Polygons[[out]]
  ), ID = 'boundary')), proj4string = CRS(proj4string(portland)))

#buffer (unbuffered was causing numerical issues)
portland.boundary.buffer = gBuffer(
  portland.boundary, width = 500
)

#only really need the coordinates
fwrite(as.data.table(
  portland.boundary.buffer@polygons[[1L]]@Polygons[[1L]]@coords),
  'data/portland_coords.csv')
