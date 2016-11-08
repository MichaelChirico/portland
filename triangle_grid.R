# Forecasting Crime in Portland
# ** Creating Potential Regular Triangular Tiling of Portland **
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
library(sp)
library(maptools)
library(rgeos)
library(abind)

#import portland
prj = CRS("+init=epsg:2913")
portland = gBuffer(gUnaryUnion(readShapePoly(
  "./data/Portland_Police_Districts.shp", proj4string = prj)),
  #See http://gis.stackexchange.com/questions/163445/
  #  some micro-scale errors being caused by the
  #  un-"buffered" shapefile
  byid = TRUE, width = 0)

area = 250*250 #in square feet
#given area, side of
#  equilateral triangle with that area is
side = 2*sqrt(area/sqrt(3)) #in feet
lims = apply(bbox(portland), 1L, diff)

#Count number of triangles needed, left-right
nn = as.integer(ceiling(2*lims[1L]/side)) + 1L
#top-bottom
mm = as.integer(ceiling(2*lims[2L]/side/sqrt(3)))

coord.array = 
  #array of coordinates -- first "face" is x,
  #  second "face" is y coordinates. Start to the
  #  left of the upper-left corner since it is the top
  #  vertex of an up-facing triangle. The grid is
  #  made up of alternating coordinates of a 
  #  rectangular array with x coordinates along
  #  multiples of s/2, y coordinates along
  #  multiples of s*sqrt(3)/2
  abind(bbox(portland)["x", "min"] + 
          matrix(rep(-1:nn, each = mm+1L), mm+1L, nn+2L) * side/2,
        bbox(portland)["y", "max"] + 
          matrix(rep(0L:mm, nn+2L), mm+1L, nn+2L) * -side*sqrt(3)/2,
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
downs = downs[ , apply(downs["i", , ] >= 1L & downs["i", , ] <= mm+1L & 
                         downs["j", , ] >= 1L & downs["j", , ] <= nn+2L,
               1L, all), ]
ups = ups[ , apply(ups["i", , ] >= 1L & ups["i", , ] <= mm+1L & 
                         ups["j", , ] >= 1L & ups["j", , ] <= nn+2L,
               1L, all), ]

#paste together up & down triangles
tris = abind(ups, downs, along = 2L)

#convert to sp-friendly coordinates
coords = array(sapply(1L:3L, function(kk)
    matrix(coord.array[t(tris[ , , kk])], nrow = 2)),
    dim = c(2, dim(tris)[2L]/2L, 3))

#construct from scratch
triangles = 
  SpatialPolygons(lapply(seq_len(dim(coords)[2L]),
                         function(jj)
                           Polygons(list(Polygon(t(coords[ , jj, ]))), ID = jj)),
                  proj4string = prj)

#clip to portland
triangles = 
  gIntersection(
    triangles[which(gIntersects(triangles, portland, byid = TRUE)), ], 
    portland, byid = TRUE
  )

plot(portland, border = 'red')
plot(triangles, add = TRUE)
