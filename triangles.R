# Forecasting Crime in Portland
# ** Creating Potential Regular Triangular Tiling of Portland **
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
library(data.table)
library(sp)
library(maptools)
library(rgeos)
library(abind)
library(rgdal)

# setwd("C:/Users/cloef/Documents/R/")

# stand-in for data.table::between, which
# doesn't return a matrix; see GH Issue #1902
bw = function(x, y) x >= y[1L] & x <= y[2L]

#checking that the coordinate index arrays (check)
#  return indices within the dimensions of
#  the coordinate array (dim(versus))
in_bounds = function(check, versus)
  apply(bw(check["i", , ], c(1L, versus[1L])) & 
          bw(check["j", , ], c(1L, versus[2L])), 1L, all)

#import portland
prj = CRS("+init=epsg:2913")
# portland = gBuffer(gUnaryUnion(readShapePoly(
#   "./data/Portland_Police_Districts.shp", proj4string = prj)),
#   #See http://gis.stackexchange.com/questions/163445/
#   #  some micro-scale errors being caused by the
#   #  un-"buffered" shapefile
#   byid = TRUE, width = 0)

portland = readOGR('data', 'portland_boundary')

#3 triangle sizes -- min, max, average (in square feet)
aa = 600*600
  #given area, side of
  #  equilateral triangle with that area is
  side = 2*sqrt(aa/sqrt(3)) #in feet
  lims = apply(bbox(portland), 1L, diff)
  
  #Count number of triangles needed, left-right
  nn = as.integer(ceiling(2*lims[1L]/side)) + 1L
  #top-bottom
  mm = as.integer(ceiling(2*lims[2L]/side/sqrt(3)))
  
  coord.array = 
    #array of coordinates -- first "face" is x,
    #  second "face" is y coordinates. Start to the
    #  left of the lower-left corner since it is the top
    #  vertex of a downward-facing triangle. The grid is
    #  made up of alternating coordinates of a 
    #  rectangular array with x coordinates along
    #  multiples of s/2, y coordinates along
    #  multiples of s*sqrt(3)/2
    abind(bbox(portland)["x", "min"] + 
            matrix(rep(-1:nn, each = mm+1L), mm+1L, nn+2L) * side/2,
          bbox(portland)["y", "min"] + 
            matrix(rep(0L:mm, nn+2L), mm+1L, nn+2L) * sqrt(3) * side/2,
          along = 3L)
  
  downs = array(rep(cbind(
    #left-most left-side coordinate index of
    #  triangles in odd-numbered rows; 
    #  reverse order since it comes out nicer
    #  (with paired coordinates consecutively)
    inds <- t(expand.grid(z = 1L:2L,
                          #start y from 0 since this means all
                          #  x rows are 1 index higher on 
                          #  both x & y indices
                          y = seq(0L, nn+2L, by = 2L), 
                          x = seq(1L, mm+1L, by = 2L))),
    #left-most left-side coordinate index of 
    #  triangles in even-numbered rows -- 
    #  increment the x & y indices both by 1
    #  relative to odd-numbered rows
    inds + c(0L, 1L, 1L))[c("x", "y", "z"), ], 3L),
    #total number of triangles is NN/2 (so NN coordinates given x&y)
    dim = c(3L, NN <- (mm + 2L - mm %% 2L)*(nn + 4L - nn %% 2L), 3L), 
    dimnames = list(c("i", "j", "k"), seq_len(NN),
                    c("left", "right", "third")))
  
  #relative to left coordinate, right coordinate
  #  simply shifts the x-index by 2
  downs[ , , "right"] = downs[ , , "right"] + c(0L, 2L, 0L)
  #so far, upward-facing and downward-facing triangles
  #  fit the same pattern
  ups = downs + c(1L, 1L, 0L)
  
  #downward triangles have third coordinate
  #  above and between left&right
  downs[ , , "third"] = downs[ , , "third"] + c(1L, 1L, 0L)
  #upward have _below_
  ups[ , , "third"] = ups[ , , "third"] + c(-1L, 1L, 0L)
  
  #for convenience, we included a bunch of extraneous
  #  triangles; clip those out now
  downs = downs[ , in_bounds(downs, dim(coord.array)), ]
  ups = ups[ , in_bounds(ups, dim(coord.array)), ]
  
  #paste together up & down triangles
  tris = abind(ups, downs, along = 2L)
  
  #convert to sp-friendly coordinates
  coords = array(sapply(1L:3L, function(kk)
    matrix(coord.array[t(tris[ , , kk])], nrow = 2L)),
    dim = c(2L, dim(tris)[2L]/2L, 3L))
  
  #construct from scratch
  triangles = 
    SpatialPolygons(
      lapply(seq_len(dim(coords)[2L]),
             function(jj)
               Polygons(list(Polygon(t(coords[ , jj, ]))), ID = jj)),
      proj4string = prj
    )
  
  triangles2 = 
    SpatialPolygonsDataFrame(triangles1, 
                             data = data.frame(ID = seq_len(length(triangles1))),
                             match.ID = FALSE)
  # writePolyShape(triangles2, "./data/triangles2000")
  writeOGR(triangles2, dsn = './data/grids/',
           layer = paste0("triA", aa/100), driver = "ESRI Shapefile", overwrite_layer = TRUE)

  