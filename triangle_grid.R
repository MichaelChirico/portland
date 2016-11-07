library(sp)
library(abind)

area = 2.5
#given area, side of
#  equilateral triangle with that area is
side = 2*sqrt(area/sqrt(3))
delx = 10
dely = 5

#Count number of triangles needed, left-right
nn = as.integer(ceiling(2*delx/side)) + 1L
#top-bottom
mm = as.integer(ceiling(2*dely/side/sqrt(3)))

coord.array = 
  #array of coordinates -- first "face" is x,
  #  second "face" is y coordinates. Start to the
  #  left of the origin since the origin is the top
  #  vertex of an up-facing triangle. The grid is
  #  made up of alternating coordinates of a 
  #  rectangular array with x coordinates along
  #  multiples of s/2, y coordinates along
  #  multiples of s*sqrt(3)/2
  abind(matrix(rep(-1:nn, each = mm+1L), mm+1L, nn+2L) * side/2,
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
    t(matrix(coord.array[t(tris[ , , kk])], nrow = 2))),
    dim = c(2, dim(tris)[2L]/2L, 3))

#construct from scratch
triangles = 
  SpatialPolygons(lapply(seq_len(dim(coords)[2L]),
                         function(jj)
                           Polygons(list(Polygon(coords[ , jj, ])), ID = jj)))

bound = SpatialPolygons(list(Polygons(list(Polygon(matrix(c(
  0, 0, delx, 0, delx, -dely, 0, -dely), ncol = 2L, byrow = TRUE))), ID = 1L)))
    
plot(triangles)
plot(bound, border = 'red', add = TRUE)