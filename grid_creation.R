# Forecasting Crime in Portland
# ** Creating Potential Tilings of Portland **
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira

library(maptools)
library(rgdal)
library(rgeos)
library(sp)
library(funchir)

#projection used by all official things Portland
prj = CRS("+init=epsg:2913")

portland <-
  gUnaryUnion(readShapePoly("./data/Portland_Police_Districts.shp", 
                            proj4string = prj))

bb <- bbox(portland)

# =============================================================================
# RECTANGULAR GRIDS   
# =============================================================================

## list out our choices of grid, including
##   also a companion for easy saving
cell.sizes = 
  list(still problems with grid too small.
       sq_min = list(dims = c(x = 250, y = 250),
                    name = 'rec250x250'),
       sq_max = list(dims = c(x = 600, y = 600),
                     name = 'rec600x600'),
       sq_mid = list(dims = c(x = 460, y = 460),
                     name = 'rec460x460'),
       #roughly gauging the typical block shape
       rec_block = list(dims = c(x = 370, y = 750),
                        name = 'rec370x750'))

## create rectangular grids
invisible(
  sapply(cell.sizes, function(c.type) 
    with(c.type, {
      n.cells = round(apply(bb, 1L, diff)/dims)
      # create SpatialPolygonsDataFrame:
      grd.layer <- 
        SpatialPolygonsDataFrame(
          as.SpatialPolygons.GridTopology(
            GridTopology(cellcentre.offset = bb[ , 'min'],
                         cellsize = dims,
                         cells.dim = n.cells),
            proj4string = prj), data = data.frame(id = integer(prod(n.cells))),
          match.ID = FALSE
        )
      names(grd.layer) <- "ID"
      
      # intersect grid with boundaries of Portland:
      # See http://stackoverflow.com/questions/15881455/
      #   Apparently when the grid is small enough, some problems occur from
      #   cells which don't intersect the city?? Not sure. But this works:
      grd = 
        gIntersection(
          grd.layer[which(gIntersects(grd.layer, portland, byid = TRUE)), ], 
          portland, byid = TRUE
        )
      
      # Sanity checks
      # grd.bdy <- gUnaryUnion(grd)
      # areas <- poly.areas(grd)
      # areas.total <- gArea(grd)
      
      # turn grid to SpatialPointsDataFrame with data=id
      grd = 
        SpatialPolygonsDataFrame(
          grd, data = data.frame(grd.id = gsub("\\s.*", "", names(grd))), 
          match.ID = FALSE
        )
      
      #save output
      writeOGR(grd, dsn = './data/grids/',
               layer = name, driver = "ESRI Shapefile")
    }
    )
  )
)
