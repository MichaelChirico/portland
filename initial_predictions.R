# Forecasting Crime in Portland
# ** Initial Predictions **
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
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

crimes.marw1 = 
  crimes[occ_date %between% D('2016-03-01', '2016-03-06')]
future = 
  SpatialPointsDataFrame(
    coords = crimes.marw1[ , cbind(x_coordina, y_coordina)],
    data = crimes.marw1[ , -grep('coord', names(crimes.marw1)), with = FALSE],
    proj4string = prj
  )

#eliminate crimes outside of any March or February 2016
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

dims = c(600, 600)
ncells = round(apply(bb, 1L, diff)/dims)

grd = GridTopology(cellcentre.offset = bb[ , 'min'] + dims/2,
                   cellsize = dims,
                   cells.dim = round(apply(bb, 1L, diff)/dims))

grdSP = as.SpatialPolygons.GridTopology(grd, proj4string = prj)

grdSP = 
  SpatialPolygonsDataFrame(
    grdSP, data = data.frame(rn = rownames(coordinates(grdSP))),
    match.ID = FALSE
  )

counts = table2(future %over% grdSP, ord = "dec")
counts.str = table2(future[future$category == 'STREET CRIMES', ] %over% grdSP,
                    ord = "dec")
counts.bur = table2(future[future$category == 'BURGLARY', ] %over% grdSP,
                    ord = "dec")
counts.veh = table2(future[future$category == 'MOTOR VEHICLE THEFT', ] %over% 
                      grdSP, ord = "dec")

min.cells = ceiling(6969600/prod(dims))
N = nrow(crimes.marw1)
a = min.cells*prod(dims)
A = gArea(portland)

N.all = sum(counts[1L:min.cells])
N.str = sum(counts.str[1L:min.cells])
N.bur = sum(counts.bur[1L:min.cells])
N.veh = sum(counts.veh[1L:min.cells])

# Bandwidth ####
nn = 30L
bws = seq(100, 4000, length.out = nn)
plotdata = data.table(index = rep(c("pai", "pei"), each = nn),
                      bandwidth = rep(bws, 2L),
                      all = numeric(2L*nn), str = numeric(2L*nn),
                      bur = numeric(2L*nn), veh = numeric(2L*nn))
       
for (bw in bws) {
  kdes = rbindlist(lapply(crimes_ym_SP, compute.kdes,
                          port.coord, bw, grd), idcol = "mo")
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
  
  plotdata[index == "pai" & bandwidth == bw,
           `:=`(all = pai(n = n.all, N = N, a = a, A = A),
                str = pai(n = n.str, N = N, a = a, A = A),
                bur = pai(n = n.bur, N = N, a = a, A = A),
                veh = pai(n = n.veh, N = N, a = a, A = A))]
  plotdata[index == "pei" & bandwidth == bw,
           `:=`(all = n.all/N.all, str = n.str/N.str,
                bur = n.bur/N.bur, veh = n.veh/N.veh)]
}

pdf("peipai.pdf")
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
mtext("Competition Indices vs. Bandwidth\n" %+%
        "For 600x600 grid & Minimum Forecast Area", outer = TRUE)
dev.off()

# Cell Size ####

## Based on results above, fix bandwidth at 500 for now --
##  Around 300 was optimal for 250x250 cells, 800 was
##  optimal for 600x600 (clear interdependence of bw & cell size)

sizes = CJ(delx = seq(250, 600, length.out = 5L),
           dely = seq(250, 600, length.out = 5L))

plotdata = rbind(copy(sizes), copy(sizes)
                 )[ , c("index", "all", "str", "bur", "veh") := 
                      c(list(rep(c("pai", "pei"), each = .N/2)),
                        replicate(4L, numeric(.N), simplify = FALSE))]

for (ii in 1L:nrow(sizes)) {
  dims = unlist(sizes[ii])
  grd = GridTopology(cellcentre.offset = bb[ , 'min'] + dims/2,
                     cellsize = dims,
                     cells.dim = round(apply(bb, 1L, diff)/dims))
  grdSP = as.SpatialPolygons.GridTopology(grd, proj4string = prj)
  grdSP = SpatialPolygonsDataFrame(
    grdSP, data = data.frame(rn = rownames(coordinates(grdSP))),
    match.ID = FALSE
  )
    
  counts = table2(future %over% grdSP, ord = "dec")
  counts.str = table2(future[future$category == 'STREET CRIMES', ] %over% grdSP,
                      ord = "dec")
  counts.bur = table2(future[future$category == 'BURGLARY', ] %over% grdSP,
                      ord = "dec")
  counts.veh = table2(future[future$category == 'MOTOR VEHICLE THEFT', ] %over% 
                        grdSP, ord = "dec")
  
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
  
  plotdata[ii, `:=`(all = pai(n = n.all, N = N, a = a, A = A),
                    str = pai(n = n.str, N = N, a = a, A = A),
                    bur = pai(n = n.bur, N = N, a = a, A = A),
                    veh = pai(n = n.veh, N = N, a = a, A = A))]
  plotdata[ii + nrow(sizes),
           `:=`(all = n.all/N.all, str = n.str/N.str,
                bur = n.bur/N.bur, veh = n.veh/N.veh)]
}

pdf("pai_cellsize.pdf")
par(mfrow = c(2L, 2L), oma = c(0,0,3,0))
contour(x = plotdata[ , unique(delx)],
        y = plotdata[ , unique(dely)],
        z = plotdata[ , matrix(all, 5L, 5L)], 
        nlevels = 5L, lwd = 3L,
        xlab = "E-W Size", ylab = "N-S Size",
        main = "All Crimes")
points(plotdata[which.max(all), cbind(delx, dely)],
       pch = "x")
contour(x = plotdata[ , unique(delx)],
        y = plotdata[ , unique(dely)],
        z = plotdata[ , matrix(str, 5L, 5L)], 
        nlevels = 5L, lwd = 3L, col = "red",
        xlab = "E-W Size", ylab = "N-S Size",
        main = "Street")
points(plotdata[which.max(str), cbind(delx, dely)],
       pch = "x", col = "red")
contour(x = plotdata[ , unique(delx)],
        y = plotdata[ , unique(dely)],
        z = plotdata[ , matrix(bur, 5L, 5L)], 
        nlevels = 5L, lwd = 3L, col = "blue",
        xlab = "E-W Size", ylab = "N-S Size",
        main = "Burglary")
points(plotdata[which.max(bur), cbind(delx, dely)],
       pch = "x", col = "blue")
contour(x = plotdata[ , unique(delx)],
        y = plotdata[ , unique(dely)],
        z = plotdata[ , matrix(veh, 5L, 5L)], 
        nlevels = 5L, lwd = 3L, col = "darkgreen",
        xlab = "E-W Size", ylab = "N-S Size",
        main = "Vehicle")
points(plotdata[which.max(veh), cbind(delx, dely)],
       pch = "x", col = "darkgreen")
mtext("PAI vs Cell Size\n" %+%
        "Bandwidth Fixed @ 500ft, Minimum Forecast Area",
      outer = TRUE)
dev.off()
