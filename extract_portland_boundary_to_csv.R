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
subP = portland@polygons[[1L]]@Polygons
npoly = length(subP)
out = which.max(sapply(subP, function(p) p@area * (!p@hole)))
#extract the actual boundary polygon to a
#  new object (que feo there's gotta be a better way??)
portland.boundary = 
  SpatialPolygons(list(Polygons(subP[out], ID = 'boundary')),
                  proj4string = CRS(proj4string(portland)))

#buffer (unbuffered was causing numerical issues)
portland.boundary.buffer = gBuffer(
  portland.boundary, width = 500
)

#only really need the coordinates
fwrite(as.data.table(
  portland.boundary.buffer@polygons[[1L]]@Polygons[[1L]]@coords),
  'data/portland_coords.csv')
