#!/usr/bin/env Rscript
# Forecasting Crime in Portland
# ** Initial Predictions **
# * --Varying Cell Size-- *
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
library(data.table)
library(funchir)
library(maptools)
library(foreign)
library(rgeos)
library(splancs)
library(parallel)

#TO DO: should do this more shared-server-friendly
n_clust = detectCores()
#supply TWO arguments:
#  1) number of points along grid in each dimension
#  2) abbreviation for forecasting horizon:
#       * 1w : one week
#       * 2w : two weeks
#       * 1m : one month
#       * 2m : two months
#       * 3m : three months
args = commandArgs(trailingOnly = TRUE)
nx = ny = as.integer(args[1L])
horizon = list('1w' = D('2016-03-01', '2016-03-06'),
               '2w' = D('2016-03-01', '2016-03-13'),
               '1m' = D('2016-03-01', '2016-03-31'),
               '2m' = D('2016-03-01', '2016-04-30'),
               '3m' = D('2016-03-01', '2016-05-21'))[[args[2L]]]

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
nml = function(x) {x[is.na(x)] = 0; x/sum(x)}
pai = function(a, n, N, A) (n/N)/(a/A)
ord.table = function(x) (tt <- table(x))[order(tt, decreasing = TRUE)]

# Data Setup ####
prj = CRS("+init=epsg:2913")
portland = readShapePoly("../data/portland.shp", proj4string = prj)
#full boundary is the largest sub-polygon of portland
#  (there are 4 miniature "islands" and 7 holes in the
#   full merged polygon representing Portland's boundaries)
out.bound = which.max(sapply(portland@polygons[[1L]]@Polygons,
                             function(x) nrow(x@coords)))
port.coord = portland@polygons[[1L]]@Polygons[[out.bound]]@coords

bb = bbox(portland)
A = gArea(portland)

crimes = fread("../crimes.csv")

setnames(crimes, tolower(names(crimes)))
crimes[ , occ_date := as.IDate(occ_date)]

#extract crimes within forecasting horizon
#  and put them into SPDF
crimes.future = crimes[occ_date %between% horizon]
N = nrow(crimes.future)
future = 
  SpatialPointsDataFrame(
    coords = crimes.future[ , cbind(x_coordina, y_coordina)],
    data = 
      crimes.future[ , -grep('coord', names(crimes.future)), with = FALSE],
    proj4string = prj
  )

#exclude unused dates 
#TO DO: should include April & May, perhaps depending on the chosen horizon
crimes = crimes[(format(occ_date, "%m") == "03" & 
                   format(occ_date, "%Y") != "2016") | 
                  occ_date %between% c("2016-02-01", "2016-02-29")]
crimes[ , occ_ym := format(occ_date, "%y%m")]

crimes_ym = split(crimes, by = "occ_ym")

crimes_ym_SP = 
  lapply(crimes_ym, function(mo)
    SpatialPointsDataFrame(
      coords = pts(mo), data = mo[ , -grep('coord', names(mo)), with = FALSE],
      proj4string = prj)
  )

# Loop Execution
incl_ratio = sqrt(.0717469) #roughly this % of points will
                            #actually end up included
# Need to inflate since many specified points are
#   outside the competition guidelines
nx = as.integer(nx/incl_ratio)
ny = as.integer(ny/incl_ratio)

#100, 2000 chosen arbitrarily;
#  100 ft as a minimum cell width seems reasonable;
#  2000 ft trimmed the substantial tail that was
#    arising along the constraint boundary
sizes = CJ(delx = seq(100, 2000, length.out = nx),
           dely = seq(100, 2000, length.out = ny))

#create cluster
cl = makeCluster(n_clust, outfile = "")
#pass the necessary packages to each node
invisible(clusterEvalQ(cl, {
  library(data.table);
  library(sp);
  library(splancs)}))
#export the minimum requisite variables to each node
clusterExport(cl, c("pai", "nml", "compute.kdes", "ord.table",
                    "N", "A", "bb", "prj",
                    "sizes", "crimes_ym_SP",
                    "future", "port.coord"),
              envir = environment())
plotdata = rbindlist(parLapply(cl, 1L:(nx*ny), function(ii) {
  dims = unlist(sizes[ii])
  #pass missing data for disallowed grid sizes
  if (!prod(dims) %between% c(62500, 360000))
    return(c(list(delx = rep(dims[1L], 2L),
                  dely = rep(dims[2L], 2L),
                  index = c("pai", "pei")),
             setNames(replicate(4L, rep.int(NA_real_, 2L),
                                simplify = FALSE),
                      c("all", "str", "bur", "veh"))))
  grd = GridTopology(cellcentre.offset = bb[ , 'min'] + dims/2,
                     cellsize = dims,
                     cells.dim = round(apply(bb, 1L, diff)/dims))
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

  list(delx = rep(dims[1L], 2L), dely = rep(dims[2L], 2L),
       index = c("pai", "pei"),
       all = c(pai(n = n.all, N = N, a = a, A = A), n.all/N.all),
       str = c(pai(n = n.str, N = N, a = a, A = A), n.str/N.str),
       bur = c(pai(n = n.bur, N = N, a = a, A = A), n.bur/N.bur),
       veh = c(pai(n = n.veh, N = N, a = a, A = A), n.veh/N.veh))
}))

stopCluster(cl)

# Countour Plots ####
pdf(paste0("pai_cellsize_", args[2L], ".pdf"))
par(mfrow = c(2L, 2L), oma = c(0,0,3,0))
contour(x = plotdata[index == "pai", unique(delx)],
        y = plotdata[index == "pai", unique(dely)],
        z = plotdata[index == "pai", matrix(all, nx, ny)],
        nlevels = 5L, lwd = 3L,
        xlab = "E-W Size", ylab = "N-S Size",
        main = "All Crimes")
points(plotdata[index == "pai"][which.max(all), cbind(delx, dely)],
       pch = "x")
lines(xx <- seq(100, 2000, length.out = 100L),
      62500/xx, lwd = 3L, lty = 2L, col = "orange")
lines(xx, 360000/xx, lwd = 3L, lty = 2L, col = "orange")
contour(x = plotdata[index == "pai", unique(delx)],
        y = plotdata[index == "pai", unique(dely)],
        z = plotdata[index == "pai", matrix(str, nx, ny)],
        nlevels = 5L, lwd = 3L, col = "red",
        xlab = "E-W Size", ylab = "N-S Size",
        main = "Street")
points(plotdata[index == "pai"][which.max(str), cbind(delx, dely)],
       pch = "x", col = "red")
lines(xx <- seq(100, 2000, length.out = 100L),
      62500/xx, lwd = 3L, lty = 2L, col = "orange")
lines(xx, 360000/xx, lwd = 3L, lty = 2L, col = "orange")
contour(x = plotdata[index == "pai", unique(delx)],
        y = plotdata[index == "pai", unique(dely)],
        z = plotdata[index == "pai", matrix(bur, nx, ny)],
        nlevels = 5L, lwd = 3L, col = "blue",
        xlab = "E-W Size", ylab = "N-S Size",
        main = "Burglary")
points(plotdata[index == "pai"][which.max(bur), cbind(delx, dely)],
       pch = "x", col = "blue")
lines(xx <- seq(100, 2000, length.out = 100L),
      62500/xx, lwd = 3L, lty = 2L, col = "orange")
lines(xx, 360000/xx, lwd = 3L, lty = 2L, col = "orange")
contour(x = plotdata[index == "pai", unique(delx)],
        y = plotdata[index == "pai", unique(dely)],
        z = plotdata[index == "pai", matrix(veh, nx, ny)],
        nlevels = 5L, lwd = 3L, col = "darkgreen",
        xlab = "E-W Size", ylab = "N-S Size",
        main = "Vehicle")
points(plotdata[index == "pai"][which.max(veh), cbind(delx, dely)],
       pch = "x", col = "darkgreen")
lines(xx <- seq(100, 2000, length.out = 100L),
      62500/xx, lwd = 3L, lty = 2L, col = "orange")
lines(xx, 360000/xx, lwd = 3L, lty = 2L, col = "orange")
mtext(paste0("PAI vs Cell Size (", args[2L], ")\n",
             "Bandwidth Fixed @ 500ft, Minimum Forecast Area"),
      outer = TRUE)
dev.off()

pdf(paste0("pei_cellsize_", args[2L], ".pdf"))
par(mfrow = c(2L, 2L), oma = c(0,0,3,0))
contour(x = plotdata[index == "pei", unique(delx)],
        y = plotdata[index == "pei", unique(dely)],
        z = plotdata[index == "pei", matrix(all, nx, ny)],
        nlevels = 5L, lwd = 3L,
        xlab = "E-W Size", ylab = "N-S Size",
        main = "All Crimes")
points(plotdata[index == "pei"][which.max(all), cbind(delx, dely)],
       pch = "x")
lines(xx <- seq(100, 2000, length.out = 100L),
      62500/xx, lwd = 3L, lty = 2L, col = "orange")
lines(xx, 360000/xx, lwd = 3L, lty = 2L, col = "orange")
contour(x = plotdata[index == "pei", unique(delx)],
        y = plotdata[index == "pei", unique(dely)],
        z = plotdata[index == "pei", matrix(str, nx, ny)],
        nlevels = 5L, lwd = 3L, col = "red",
        xlab = "E-W Size", ylab = "N-S Size",
        main = "Street")
points(plotdata[index == "pei"][which.max(str), cbind(delx, dely)],
       pch = "x", col = "red")
lines(xx <- seq(100, 2000, length.out = 100L),
      62500/xx, lwd = 3L, lty = 2L, col = "orange")
lines(xx, 360000/xx, lwd = 3L, lty = 2L, col = "orange")
contour(x = plotdata[index == "pei", unique(delx)],
        y = plotdata[index == "pei", unique(dely)],
        z = plotdata[index == "pei", matrix(bur, nx, ny)],
        nlevels = 5L, lwd = 3L, col = "blue",
        xlab = "E-W Size", ylab = "N-S Size",
        main = "Burglary")
points(plotdata[index == "pei"][which.max(bur), cbind(delx, dely)],
       pch = "x", col = "blue")
lines(xx <- seq(100, 2000, length.out = 100L),
      62500/xx, lwd = 3L, lty = 2L, col = "orange")
lines(xx, 360000/xx, lwd = 3L, lty = 2L, col = "orange")
contour(x = plotdata[index == "pei", unique(delx)],
        y = plotdata[index == "pei", unique(dely)],
        z = plotdata[index == "pei", matrix(veh, nx, ny)],
        nlevels = 5L, lwd = 3L, col = "darkgreen",
        xlab = "E-W Size", ylab = "N-S Size",
        main = "Vehicle")
points(plotdata[index == "pei"][which.max(veh), cbind(delx, dely)],
       pch = "x", col = "darkgreen")
lines(xx <- seq(100, 2000, length.out = 100L),
      62500/xx, lwd = 3L, lty = 2L, col = "orange")
lines(xx, 360000/xx, lwd = 3L, lty = 2L, col = "orange")
mtext(paste0("PEI vs Cell Size (", args[2L], ")\n",
             "Bandwidth Fixed @ 500ft, Minimum Forecast Area"),
      outer = TRUE)
dev.off()
