#!/usr/bin/env Rscript
# Forecasting Crime in Portland
# **    Initial Predictions     **
# * --Varying Cell Orientation-- *
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
library(data.table)
library(maptools)
library(foreign)
library(rgeos)
library(splancs)
library(parallel)

#TO DO: should do this more shared-server-friendly
n_clust = detectCores()
#supply THREE arguments:
#  1) cell size (x: East-West)
#  2) cell isze (y: North-South)
#  3) abbreviation for forecasting horizon:
#       * 1w : one week
#       * 2w : two weeks
#       * 1m : one month
#       * 2m : two months
#       * 3m : three months
args = commandArgs(trailingOnly = TRUE)
delx = as.integer(args[1L])
dely = as.integer(args[2L])
dims = c(delx, dely)
horizon = list('1w' = as.Date(c('2016-03-01', '2016-03-06')),
               '2w' = as.Date(c('2016-03-01', '2016-03-13')),
               '1m' = as.Date(c('2016-03-01', '2016-03-31')),
               '2m' = as.Date(c('2016-03-01', '2016-04-30')),
               '3m' = as.Date(c('2016-03-01', '2016-05-21')))[[args[3L]]]

# Functions ####
compute.kdes <- function(DT, poly, h0, grd){
  kde.all = 
    nml(spkernel2d(pts = DT, poly = poly, h0 = h0, grd = grd))
  kde.street =
    nml(spkernel2d(pts = DT[DT$category=='STREET CRIMES', ],
                   poly = poly, h0 = h0, grd = grd))
  kde.burglary = 
    nml(spkernel2d(pts = DT[DT$category=='BURGLARY', ], 
                   poly = poly, h0 = h0, grd = grd))
  kde.vehicle = 
    nml(spkernel2d(pts = DT[DT$category=='MOTOR VEHICLE THEFT', ],
                   poly = poly, h0 = h0, grd = grd))
  data.table(id = paste0('g', 1L:prod(grd@cells.dim)),
             all = kde.all, street = kde.street,
             burglary = kde.burglary, vehicle = kde.vehicle)
}

pts = function(DT) DT[ , cbind(x_coordina, y_coordina)]
#to normalize densities since they don't sum to 1
nml = function(x) {x[is.na(x)] = 0; x/sum(x)}
#get the multiple of n nearest x
nx.mlt = function (x, n) n * ceiling(x/n)
pai = function(a, n, N, A) (n/N)/(a/A)
ord.table = function(x) (tt <- table(x))[order(tt, decreasing = TRUE)]
#rotation formula, relative to a point (x_0, y_0) that's not origin:
#  [x_0, y_0] + R * [x - x_0, y - y_0]
#  (i.e., rotate the distances from (x_0, y_0) about that point,
#   then offset again by (x_0, y_0))
#  Equivalently (implemented below):
#  (I - R)[x_0, y_0] + R[x, y]
rotate = function(points, theta, origin)
  matrix(origin, nrow = nrow(points), 
         ncol = 2L, byrow = TRUE) %*% (diag(2L) - RT(theta)) + 
  points %*% RT(theta)
#use the transpose of the rotation matrix to multiply against
#  column vectors of coordinates
RT = function(theta) matrix(c(cos(theta), -sin(theta), 
                              sin(theta), cos(theta)), 
                            nrow = 2L, ncol = 2L)


# Data Setup ####
prj = CRS("+init=epsg:2913")
portland = readShapePoly("../data/portland.shp", proj4string = prj)
#full boundary is the largest sub-polygon of portland
#  (there are 4 miniature "islands" and 7 holes in the
#   full merged polygon representing Portland's boundaries)
out.bound = which.max(sapply(portland@polygons[[1L]]@Polygons,
                             function(x) nrow(x@coords)))
port.coord_0 = portland@polygons[[1L]]@Polygons[[out.bound]]@coords

bb = bbox(portland)
#used repeatedly in rotations as reference point
bbm = bb[ , "min"] 
A = gArea(portland)

crimes = fread("../crimes.csv")

setnames(crimes, tolower(names(crimes)))
crimes[ , occ_date := as.IDate(occ_date)]

#extract crimes within forecasting horizon
#  and put them into SPDF
crimes.future = crimes[occ_date %between% horizon]
N = nrow(crimes.future)

#exclude unused dates 
#TO DO: should include April & May, perhaps depending on the chosen horizon
crimes = crimes[(format(occ_date, "%m") == "03" & 
                   format(occ_date, "%Y") != "2016") | 
                  occ_date %between% c("2016-02-01", "2016-02-29")]
crimes[ , occ_ym := format(occ_date, "%y%m")]

crimes_ym = split(crimes, by = "occ_ym")

# Loop Execution
angles = seq(0, pi/2, length.out = 40L)

#create cluster
cl = makeCluster(n_clust, outfile = "")
#pass the necessary packages to each node
invisible(clusterEvalQ(cl, {
  library(data.table);
  library(sp);
  library(splancs)}))
#export the minimum requisite variables to each node
clusterExport(cl, c("pai", "nml", "compute.kdes", "ord.table",
                    "rotate", "RT", "nx.mlt", "pts",
                    "N", "A", "bb", "bbm", "prj", "dims", "delx", "dely",
                    "port.coord_0", "crimes.future", "crimes_ym"),
              envir = environment())
plotdata = rbindlist(parLapply(cl, angles, function(th) {
  #Rotate future crimes data
  future = 
    SpatialPointsDataFrame(
      coords = rotate(pts(crimes.future), th, bbm),
      data = 
        crimes.future[ , -grep('coord', names(crimes.future)), with = FALSE],
      proj4string = prj
    )
  
  #Rotate prior crimes data
  crimes_ym_SP = 
    lapply(crimes_ym, function(mo)
      SpatialPointsDataFrame(
        coords = rotate(pts(mo), th, bbm),
        data = mo[ , -grep('coord', names(mo)), with = FALSE],
        proj4string = prj)
    )
  
  #Rotate Portland
  port.coord = rotate(port.coord_0, th, bbm)
  
  #row order (names lost by c):
  #  x.min, y.min, x.max, y.max
  #  Need min of min columns, max of max columns
  #    to create overall bounding box
  bbs = sapply(crimes_ym_SP, function(x) c(bbox(x)))
  
  new_box = matrix(c(min(bbs[1L, ]), min(bbs[2L, ]),
                     max(bbs[3L, ]), max(bbs[4L, ])),
                   nrow = 2L, ncol = 2L,
                   dimnames = list(c("x", "y"), 
                                   c("min", "max")))
  
  grd = 
    GridTopology(cellcentre.offset = 
                   #to ensure old origin is still a coordinate
                   #  (to isolate the effects of choosing an origin),
                   #  make sure our cell center offset is such that
                   #  it implies going through old origin.
                   #nx.mlt turns the difference into an integer multiple of del*
                   dims/2 + 
                   c(bbm["x"] - nx.mlt(bbm["x"] - new_box["x", "min"], delx),
                     bbm["y"] - nx.mlt(bbm["y"] - new_box["y", "min"], dely)),
                 cellsize = dims,
                 cells.dim = round(apply(new_box, 1L, diff)/dims))
  grdSP = as.SpatialPolygons.GridTopology(grd, proj4string = prj)
  grdSP = SpatialPolygonsDataFrame(
    grdSP, data = data.frame(rn = rownames(coordinates(grdSP))),
    match.ID = FALSE
  )

  counts = ord.table(future %over% grdSP)
  counts.str =
    ord.table(future[future$category == 'STREET CRIMES', ] %over% grdSP)
  counts.bur = ord.table(future[future$category == 'BURGLARY', ] %over% grdSP)
  counts.veh =
    ord.table(future[future$category == 'MOTOR VEHICLE THEFT', ] %over% grdSP)

  min.cells = ceiling(6969600/prod(dims))
  a = min.cells*prod(dims)

  N.all = sum(counts[1L:min.cells])
  N.str = sum(counts.str[1L:min.cells])
  N.bur = sum(counts.bur[1L:min.cells])
  N.veh = sum(counts.veh[1L:min.cells])

  kdes = rbindlist(lapply(crimes_ym_SP, compute.kdes,
                          port.coord, h0 = 500, grd), idcol = "mo")
  #weight prior Marches at .02 relative to current February
  kdes[ , wt := .02 + .98*(substr(mo, 1L, 2L) == "16")]
  #aggregate
  wt.kde = kdes[ , lapply(.SD, function(x) sum(x * wt)),
                 by = id, .SDcols = !c("mo", "wt")]
  n.all = sum(counts[wt.kde[order(all, decreasing = TRUE),
                            id[1L:min.cells]]])
  n.str = sum(counts.str[wt.kde[order(street, decreasing = TRUE),
                                id[1L:min.cells]]])
  n.bur = sum(counts.bur[wt.kde[order(burglary, decreasing = TRUE),
                                id[1L:min.cells]]])
  n.veh = sum(counts.veh[wt.kde[order(vehicle, decreasing = TRUE),
                                id[1L:min.cells]]])
  
  #convert to degrees at the end for readability
  list(theta = rep(th*180/pi, 2L), index = c("pai", "pei"),
       all = c(pai(n = n.all, N = N, a = a, A = A), n.all/N.all),
       str = c(pai(n = n.str, N = N, a = a, A = A), n.str/N.str),
       bur = c(pai(n = n.bur, N = N, a = a, A = A), n.bur/N.bur),
       veh = c(pai(n = n.veh, N = N, a = a, A = A), n.veh/N.veh))
}))

stopCluster(cl)

plotdata[ , {
  pdf(paste0("rotation_effects_", delx, "x", dely, "_", args[3L], ".pdf"))
  par(mfrow = c(1L, 2L),
      oma = c(0, 0, 2.5, 0))
  .SD[index == "pai",
      matplot(theta, .SD, type = "l", lty = 1L,
              lwd = 3L, col = c("black", "red", "blue", "darkgreen"),
              xlab = "Angle of Rotation", ylab = "PAI", main = "PAI"),
      .SDcols = !c("theta", "index")]
  .SD[index == "pei",
      matplot(theta, .SD, type = "l", lty = 1L,
              lwd = 3L, col = c("black", "red", "blue", "darkgreen"),
              xlab = "Angle of Rotation", ylab = "PEI", main = "PEI"),
      .SDcols = !c("theta", "index")]
  title(paste0("PAI/PEI vs. Angle of Rotation (", args[3L], ")\n", 
               delx, " ft x", dely, " ft grid size, 500ft bandwidth"),
        outer = TRUE)
  dev.off()
}]
