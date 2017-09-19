# this file contains some meta objects common
#   throughout the project; running source
#   on this file is a way of treating the 
#   project folder as a package locally,
#   in the sense of having a set of functions
#   and constants available in scope

## the Portland CRS in units of feet:
##    NAD83(HARN) / Oregon North (ft)
##    http://spatialreference.org/ref/epsg/2913/
prj = CRS("+init=epsg:2913")

#use the transpose of the rotation matrix to multiply against
#  column vectors of coordinates
RT = function(theta) matrix(c(cos(theta), -sin(theta),
                              sin(theta), cos(theta)),
                            nrow = 2L, ncol = 2L)

#rotation formula, relative to a point (x_0, y_0) that's not origin:
#  [x_0, y_0] + R * [x - x_0, y - y_0]
#  (i.e., rotate the distances from (x_0, y_0) about that point,
#   then offset again by (x_0, y_0))
#  Equivalently (implemented below):
#  (I - R)[x_0, y_0] + R[x, y]
rotate = function(x, y, theta, origin)
  matrix(origin, nrow = length(x), 
         ncol = 2L, byrow = TRUE) %*% (diag(2L) - RT(theta)) + 
  cbind(x, y) %*% RT(theta)

# Obtain indices to rearange data from image (eg. result frim pixellate)
# so that it conforms with data from GridTopology objects (eg. results
# from using spkernel2d).
# Input: gt is a grid topology.
# Returns an index.
getGTindices <- function(gt) {
  dimx <- gt@cells.dim[1L]
  dimy <- gt@cells.dim[2L]
  c(matrix(seq_len(dimx*dimy), ncol = dimy, byrow = TRUE)[ , dimy:1L])
}

# create sp object of crimes
to.spdf = function(dt) {
  SpatialPointsDataFrame(
    coords = dt[ , cbind(x_coordina, y_coordina)],
    data = dt[ , -c('x_coordina', 'y_coordina')],
    proj4string = prj)
}

#when we're at the minimum forecast area, we must round up
#  to be sure we don't undershoot; when at the max,
#  we must round down; otherwise, just round
# **TO DO: if we predict any boundary cells and are using the minimum
#          forecast area, WE'LL FALL BELOW IT WHEN WE CLIP TO PORTLAND **
which.round = function(x)
  if (x > 0) {if (x < 1) round else floor} else ceiling

seq_rng = function(rng) seq.int(rng[1L], rng[2L])
