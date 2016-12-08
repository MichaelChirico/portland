# Predictions using 3d kernels
setwd('~/Dropbox/0_Penn/Research/crime_prediction/portland/')
rm(list = ls())


library(data.table)
library(funchir)
library(maptools)
library(foreign)
library(rgeos)
library(splancs)

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
  data.table(id = 'g' %+% 1L:prod(grd@cells.dim),
             all = kde.all, street = kde.street,
             burglary = kde.burglary, vehicle = kde.vehicle)
}

pts = function(DT) DT[ , cbind(x_coordina, y_coordina)]
nml = function(x) x/sum(x, na.rm = TRUE)
pai = function(a, n, N, A) (n/N)/(a/A)

kernel3d.crime <- function(pts, t, hxy=2400, hz=60, grd.grdtop) {
  # Returns a SpatialGridDataFrame with the kernel estimates as kde:
  # Computes the 3d kde on the last day of t.
  # parameters for kernel3d:
  a1 <- slot(grd.grdtop, "cellcentre.offset")[1] - (slot(grd.grdtop, "cellsize")[1])/2
  a2 <- a1 + slot(grd.grdtop, "cellsize")[1] * slot(grd.grdtop, "cells.dim")[1]
  b1 <- slot(grd.grdtop, "cellcentre.offset")[2] - (slot(grd.grdtop, "cellsize")[2])/2
  b2 <- b1 + slot(grd.grdtop, "cellsize")[2] * slot(grd.grdtop, "cells.dim")[2]
  nx <- slot(grd.grdtop, "cells.dim")[1]
  ny <- slot(grd.grdtop, "cells.dim")[2]
  
  xgr <- seq(a1, a2, length.out = nx)
  ygr <- seq(b1, b2, length.out = ny)
  zgr <- max(t) # last day
  # compute kernel:
  k3d <- kernel3d(pts, t, xgr = xgr, ygr = ygr, zgr = zgr, hxy = hxy, hz = hz)
  grd.k3d <- SpatialGridDataFrame(grd.grdtop, data=data.frame(kde=as.matrix(k3d$v)))
  flipVertical(grd.k3d)
}

flipHorizontal <- function(x) {
  if (!inherits(x, "SpatialGridDataFrame")) stop("x must be a
                                                 SpatialGridDataFrame")
  grd <- getGridTopology(x)
  idx = 1:prod(grd@cells.dim[1:2])
  m = matrix(idx, grd@cells.dim[2], grd@cells.dim[1], byrow =
               TRUE)[,grd@cells.dim[1]:1]
  idx = as.vector(t(m))
  x@data <- x@data[idx, TRUE, drop = FALSE]
  x
}

flipVertical <- function(x) {
  if (!inherits(x, "SpatialGridDataFrame")) stop("x must be a
                                                 SpatialGridDataFrame")
  grd <- getGridTopology(x)
  idx = 1:prod(grd@cells.dim[1:2])
  m = matrix(idx, grd@cells.dim[2], grd@cells.dim[1], byrow =
               TRUE)[grd@cells.dim[2]:1, ]
  idx = as.vector(t(m))
  x@data <- x@data[idx, TRUE, drop = FALSE]
  x
}

# Setup ####
prj = CRS("+init=epsg:2913")
portland = readShapePoly("./data/portland.shp", proj4string = prj)
#full boundary is the largest sub-polygon of portland
#  (there are 4 miniature "islands" and 7 holes in the
#   full merged polygon representing Portland's boundaries)
out.bound = which.max(sapply(portland@polygons[[1L]]@Polygons,
                             function(x) nrow(x@coords)))
port.coord = portland@polygons[[1L]]@Polygons[[out.bound]]@coords

bb = bbox(portland)

crimes = rbindlist(lapply(list.files(
  "./data", pattern = "^NIJ.*\\.dbf", full.names = TRUE),
  #as.is = TRUE is equivalent to stringsAsFactors = FALSE;
  #  also, some missing data snuck in on one line
  read.dbf, as.is = TRUE))[!is.na(occ_date)]

setnames(crimes, tolower(names(crimes)))
crimes[ , occ_date := as.IDate(occ_date)]

crimes[, occ_year := year(occ_date)]
crimes[, occ_month := month(occ_date)]

# create variable days, used for kernel3d:
crimes <- crimes[order(occ_date)]
crimes[, day := 1 + cumsum(c(0, diff(occ_date)))]

crimes.future = 
  # crimes[occ_date %between% D('2016-03-01', '2016-03-06')] # 1st week March
  crimes[occ_date %between% D('2016-03-01', '2016-03-13')] # 1st and 2nd week March
  # crimes[occ_date %between% D('2016-03-01', '2016-04-01')] # month of March
  # crimes[occ_date %between% D('2016-03-01', '2016-05-01')] # months of March and April

future = 
  SpatialPointsDataFrame(
    coords = crimes.future[ , cbind(x_coordina, y_coordina)],
    data = crimes.future[ , -grep('coord', names(crimes.future)), with = FALSE],
    proj4string = prj
  )

#eliminate crimes outside of any January, February and March or January and February 2016
crimes = crimes[(format(occ_date, "%m") %in% c("01","02","03") & 
                   format(occ_date, "%Y") != "2016") | 
                  occ_date %between% c("2016-01-01", "2016-02-29")]
crimes[ , occ_ym := format(occ_date, "%y%m")]

crimes_ym = split(crimes, by = "occ_ym")
crimes_y = split(crimes, by = 'occ_year')

crimes_ym_SP = 
  lapply(crimes_ym, function(mo)
    SpatialPointsDataFrame(
      coords = pts(mo), data = mo[ , -grep('coord', names(mo)), with = FALSE],
      proj4string = prj)
  )

crimes_y_SP = 
  lapply(crimes_y, function(mo)
    SpatialPointsDataFrame(
      coords = pts(mo), data = mo[ , -grep('coord', names(mo)), with = FALSE],
      proj4string = prj)
  )

# ============================================================================
# GRID
# ============================================================================

dims = c(600, 600)
ncells = round(apply(bb, 1L, diff)/dims)

grd = GridTopology(cellcentre.offset = bb[ , 'min'] + dims/2,
                   cellsize = dims,
                   cells.dim = ncells)

grdSP = as.SpatialPolygons.GridTopology(grd, proj4string = prj)

grdSP = 
  SpatialPolygonsDataFrame(
    grdSP, data = data.frame(rn = rownames(coordinates(grdSP))),
    match.ID = FALSE
  )


# ============================================================================
# COUNTS AND PAI/PEI
# ============================================================================

counts = table2(future %over% grdSP, ord = "dec")
counts.str = table2(future[future$category == 'STREET CRIMES', ] %over% grdSP,
                    ord = "dec")
counts.bur = table2(future[future$category == 'BURGLARY', ] %over% grdSP,
                    ord = "dec")
counts.veh = table2(future[future$category == 'MOTOR VEHICLE THEFT', ] %over% 
                      grdSP, ord = "dec")

min.cells = ceiling(6969600/prod(dims))
N = nrow(crimes.future)
a = min.cells*prod(dims)
A = gArea(portland)

N.all = sum(counts[1L:min.cells])
N.str = sum(counts.str[1L:min.cells])
N.bur = sum(counts.bur[1L:min.cells])
N.veh = sum(counts.veh[1L:min.cells])

compute.kdes.3d <- function(DT, hxy, hz, grdtop){
  kde.all <- kernel3d.crime(pts=pts(DT), t=DT[, day], hxy, hz, grdtop)
  kde.str <- kernel3d.crime(pts=pts(DT[category=='STREET CRIMES']),
                            t=DT[category=='STREET CRIMES', day], 
                            hxy, hz, grdtop)
  kde.bur <- kernel3d.crime(pts=pts(DT[category=='BURGLARY']),
                            t=DT[category=='BURGLARY', day], 
                            hxy, hz, grdtop)
  kde.veh <- kernel3d.crime(pts=pts(DT[category=='MOTOR VEHICLE THEFT']),
                            t=DT[category=='MOTOR VEHICLE THEFT', day], 
                            hxy, hz, grdtop)
  # ls <- list(all=kde.all, burglary=kde.bur, vehicle=kde.veh, street=kde.str)
  data.table(id = 'g' %+% 1L:prod(grd@cells.dim),
             all = kde.all$kde, street = kde.str$kde,
             burglary = kde.bur$kde, vehicle = kde.veh$kde)
}


# ============================================================================
# LOOP BANDWIDTHS
# ============================================================================

nn = 30L
# bws = seq(100, 4000, length.out = nn)
bws = seq(50, 1200, length.out = nn)
plotdata = data.table(index = rep(c("pai", "pei"), each = nn),
                      bandwidth = rep(bws, 2L),
                      all = numeric(2L*nn), str = numeric(2L*nn),
                      bur = numeric(2L*nn), veh = numeric(2L*nn))

for (bw in bws) {
  print(paste0('Doing computations for bw =', as.character(bw)))
  kdes = rbindlist(lapply(crimes_y, compute.kdes.3d,
                          bw, 60, grd), idcol = "y")
  #weight prior years at .02 relative to current February
  kdes[ , wt := .2*(y != 2016) + .80*(y == 2016)]
  #aggregate
  wt.kde = kdes[ , lapply(.SD, function(x) sum(x * wt)), 
                 by = id, .SDcols = !c("y", "wt")]
  n.all = sum(counts[wt.kde[order(all, decreasing = TRUE), 
                            id[1L:min.cells]]])
  n.str = sum(counts.str[wt.kde[order(street, decreasing = TRUE), 
                                id[1L:min.cells]]])
  n.bur = sum(counts.bur[wt.kde[order(burglary, decreasing = TRUE), 
                                id[1L:min.cells]]])
  n.veh = sum(counts.veh[wt.kde[order(vehicle, decreasing = TRUE), 
                                id[1L:min.cells]]])
  
  plotdata[index == "pai" & bandwidth == bw,
           `:=`(all = pai(n = n.all, N = N, a = a, A = A),
                str = pai(n = n.str, N = N, a = a, A = A),
                bur = pai(n = n.bur, N = N, a = a, A = A),
                veh = pai(n = n.veh, N = N, a = a, A = A))]
  plotdata[index == "pei" & bandwidth == bw,
           `:=`(all = n.all/N.all, str = n.str/N.str,
                bur = n.bur/N.bur, veh = n.veh/N.veh)]
}

pdf2("peipai_3d_2080_1200_w2.pdf")
par(mfrow = c(1L, 2L), oma = c(0,0,2,0))
plotdata[index == "pai", 
         matplot(bandwidth, cbind(all, str, bur, veh),
                 main = "PAI", xlab = "Bandwidth",
                 ylab = "PAI", type = "l", lty = 1L,
                 lwd = 3L, 
                 col = c("black", "red", "blue", "darkgreen"))]
legend("topright", legend = c("All", "Street", "Burglary", "Vehicle"),
       lwd = 3L, col = c("black", "red", "blue", "darkgreen"))
plotdata[index == "pei", 
         matplot(bandwidth, cbind(all, str, bur, veh),
                 main = "PEI", xlab = "Bandwidth",
                 ylab = "PEI (%)", type = "l", lty = 1L,
                 lwd = 3L, 
                 col = c("black", "red", "blue", "darkgreen"))]
mtext("Kernel 3D, Competition Indices vs. Bandwidth\n" %+%
        "For 600x600 grid & Minimum Forecast Area, 60 days tempral bw", outer = TRUE)
dev.off2()


# ============================================================================
# TEMPORAL BANDWIDTH
# ============================================================================

nn = 30L
bws = seq(5, 100, length.out = nn)
plotdata = data.table(index = rep(c("pai", "pei"), each = nn),
                      bandwidth = rep(bws, 2L),
                      all = numeric(2L*nn), str = numeric(2L*nn),
                      bur = numeric(2L*nn), veh = numeric(2L*nn))

for (bw in bws) {
  kdes = rbindlist(lapply(crimes_y, compute.kdes.3d,
                          1000, bw, grd), idcol = "y")
  #weight prior years at .02 relative to current February
  kdes[ , wt := .2*(y != 2016) + .80*(y == 2016)]
  #aggregate
  wt.kde = kdes[ , lapply(.SD, function(x) sum(x * wt)), 
                 by = id, .SDcols = !c("y", "wt")]
  n.all = sum(counts[wt.kde[order(all, decreasing = TRUE), 
                            id[1L:min.cells]]])
  n.str = sum(counts.str[wt.kde[order(street, decreasing = TRUE), 
                                id[1L:min.cells]]])
  n.bur = sum(counts.bur[wt.kde[order(burglary, decreasing = TRUE), 
                                id[1L:min.cells]]])
  n.veh = sum(counts.veh[wt.kde[order(vehicle, decreasing = TRUE), 
                                id[1L:min.cells]]])
  
  plotdata[index == "pai" & bandwidth == bw,
           `:=`(all = pai(n = n.all, N = N, a = a, A = A),
                str = pai(n = n.str, N = N, a = a, A = A),
                bur = pai(n = n.bur, N = N, a = a, A = A),
                veh = pai(n = n.veh, N = N, a = a, A = A))]
  plotdata[index == "pei" & bandwidth == bw,
           `:=`(all = n.all/N.all, str = n.str/N.str,
                bur = n.bur/N.bur, veh = n.veh/N.veh)]
}

pdf2("peipai_3d_temp_w2.pdf")
par(mfrow = c(1L, 2L), oma = c(0,0,2,0))
plotdata[index == "pai", 
         matplot(bandwidth, cbind(all, str, bur, veh),
                 main = "PAI", xlab = "Bandwidth",
                 ylab = "PAI", type = "l", lty = 1L,
                 lwd = 3L, 
                 col = c("black", "red", "blue", "darkgreen"))]
legend("topright", legend = c("All", "Street", "Burglary", "Vehicle"),
       lwd = 3L, col = c("black", "red", "blue", "darkgreen"))
plotdata[index == "pei", 
         matplot(bandwidth, cbind(all, str, bur, veh),
                 main = "PEI", xlab = "Bandwidth",
                 ylab = "PEI (%)", type = "l", lty = 1L,
                 lwd = 3L, 
                 col = c("black", "red", "blue", "darkgreen"))]
mtext("Kernel 3D, Competition Indices vs. Temporal Bandwidth\n" %+%
        "For 600x600 grid & Minimum Forecast Area, 1000ft spatial bw", outer = TRUE)
dev.off2()

# ============================================================================
# FORECASTING AREA
# ============================================================================

# Total forecasted area	0.25	mi2 – .75 mi2
area.min <- 6969600 # in square feet
area.max <- 2.09088e+7 # in square feet
area.cell <- prod(grd@cellsize)
min.cells <- ceiling(area.min/area.cell)
max.cells <- floor(area.max/area.cell)


# ============================================================================
# CELL SIZE
# ============================================================================
# 
# ## Based on results above, fix bandwidth at 500 for now --
# ##  Around 300 was optimal for 250x250 cells, 800 was
# ##  optimal for 600x600 (clear interdependence of bw & cell size)
# 
# sizes = CJ(delx = seq(250, 600, length.out = 5L),
#            dely = seq(250, 600, length.out = 5L))
# 
# plotdata2 = rbind(copy(sizes), copy(sizes)
# )[ , c("index", "all", "str", "bur", "veh") := 
#      c(list(rep(c("pai", "pei"), each = .N/2)),
#        replicate(4L, numeric(.N), simplify = FALSE))]
# 
# for (ii in 1L:nrow(sizes)) {
#   dims = unlist(sizes[ii])
#   grd = GridTopology(cellcentre.offset = bb[ , 'min'] + dims/2,
#                      cellsize = dims,
#                      cells.dim = round(apply(bb, 1L, diff)/dims))
#   grdSP = as.SpatialPolygons.GridTopology(grd, proj4string = prj)
#   grdSP = SpatialPolygonsDataFrame(
#     grdSP, data = data.frame(rn = rownames(coordinates(grdSP))),
#     match.ID = FALSE
#   )
#   
#   counts = table2(future %over% grdSP, ord = "dec")
#   counts.str = table2(future[future$category == 'STREET CRIMES', ] %over% grdSP,
#                       ord = "dec")
#   counts.bur = table2(future[future$category == 'BURGLARY', ] %over% grdSP,
#                       ord = "dec")
#   counts.veh = table2(future[future$category == 'MOTOR VEHICLE THEFT', ] %over% 
#                         grdSP, ord = "dec")
#   
#   min.cells = ceiling(6969600/prod(dims))
#   a = min.cells*prod(dims)
#   
#   N.all = sum(counts[1L:min.cells])
#   N.str = sum(counts.str[1L:min.cells])
#   N.bur = sum(counts.bur[1L:min.cells])
#   N.veh = sum(counts.veh[1L:min.cells])
#   
#   kdes = rbindlist(lapply(crimes_ym_SP, compute.kdes,
#                           port.coord, h0 = 500, grd), idcol = "mo")
#   #weight prior Marches at .02 relative to current February
#   kdes[ , wt := .02 + .98*(substr(mo, 1L, 2L) == "16")]
#   #aggregate
#   wt.kde = kdes[ , lapply(.SD, function(x) sum(x * wt)), 
#                  by = id, .SDcols = !c("mo", "wt")]
#   n.all = sum(counts[wt.kde[order(all, decreasing = TRUE), 
#                             id[1L:min.cells]]])
#   n.str = sum(counts.str[wt.kde[order(street, decreasing = TRUE), 
#                                 id[1L:min.cells]]])
#   n.bur = sum(counts.bur[wt.kde[order(burglary, decreasing = TRUE), 
#                                 id[1L:min.cells]]])
#   n.veh = sum(counts.veh[wt.kde[order(vehicle, decreasing = TRUE), 
#                                 id[1L:min.cells]]])
#   
#   plotdata[ii, `:=`(all = pai(n = n.all, N = N, a = a, A = A),
#                     str = pai(n = n.str, N = N, a = a, A = A),
#                     bur = pai(n = n.bur, N = N, a = a, A = A),
#                     veh = pai(n = n.veh, N = N, a = a, A = A))]
#   plotdata[ii + nrow(sizes),
#            `:=`(all = n.all/N.all, str = n.str/N.str,
#                 bur = n.bur/N.bur, veh = n.veh/N.veh)]
# }
# 
# pdf("pai_cellsize_w1.pdf")
# par(mfrow = c(2L, 2L), oma = c(0,0,3,0))
# contour(x = plotdata[ , unique(delx)],
#         y = plotdata[ , unique(dely)],
#         z = plotdata[ , matrix(all, 5L, 5L)], 
#         nlevels = 5L, lwd = 3L,
#         xlab = "E-W Size", ylab = "N-S Size",
#         main = "All Crimes")
# points(plotdata[which.max(all), cbind(delx, dely)],
#        pch = "x")
# contour(x = plotdata[ , unique(delx)],
#         y = plotdata[ , unique(dely)],
#         z = plotdata[ , matrix(str, 5L, 5L)], 
#         nlevels = 5L, lwd = 3L, col = "red",
#         xlab = "E-W Size", ylab = "N-S Size",
#         main = "Street")
# points(plotdata[which.max(str), cbind(delx, dely)],
#        pch = "x", col = "red")
# contour(x = plotdata[ , unique(delx)],
#         y = plotdata[ , unique(dely)],
#         z = plotdata[ , matrix(bur, 5L, 5L)], 
#         nlevels = 5L, lwd = 3L, col = "blue",
#         xlab = "E-W Size", ylab = "N-S Size",
#         main = "Burglary")
# points(plotdata[which.max(bur), cbind(delx, dely)],
#        pch = "x", col = "blue")
# contour(x = plotdata[ , unique(delx)],
#         y = plotdata[ , unique(dely)],
#         z = plotdata[ , matrix(veh, 5L, 5L)], 
#         nlevels = 5L, lwd = 3L, col = "darkgreen",
#         xlab = "E-W Size", ylab = "N-S Size",
#         main = "Vehicle")
# points(plotdata[which.max(veh), cbind(delx, dely)],
#        pch = "x", col = "darkgreen")
# mtext("PAI vs Cell Size\n" %+%
#         "Bandwidth Fixed @ 500ft, Minimum Forecast Area",
#       outer = TRUE)
# dev.off()
# 
# par(mfrow=c(1,1))