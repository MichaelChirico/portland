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
compute.kdes <- function(DT, poly, h0, nx, ny){
  kde.all = 
    kernel2d(pts = pts(DT), 
             poly = poly, h0 = h0, nx = nx, ny = ny, quiet = TRUE)
  kde.street =
    kernel2d(pts = pts(DT[category=='STREET CRIMES']),
             poly = poly, h0 = h0, nx = nx, ny = ny, quiet = TRUE)
  kde.burglary = 
    kernel2d(pts = pts(DT[category=='BURGLARY']), 
             poly = poly, h0 = h0, nx = nx, ny = ny, quiet = TRUE)
  kde.vehicle = 
    kernel2d(pts = pts(DT[category=='MOTOR VEHICLE THEFT']),
             poly = poly, h0 = h0, nx = nx, ny = ny, quiet = TRUE)
  CJ(x = kde.all$x, y = kde.all$y
     )[ , c("all", "street", "burglary", "vehicle") := 
          lapply(list(kde.all, kde.street, kde.burglary, kde.vehicle),
                 function(k) c(k$z/sum(k$z, na.rm = TRUE)))]
}

pts = function(DT) DT[ , cbind(x_coordina, y_coordina)]

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

dims = c(600, 600)
ncells = round(apply(bb, 1L, diff)/dims)

grd = GridTopology(cellcentre.offset = bb[ , 'min'],
                   cellsize = dims,
                   cells.dim = round(apply(bb, 1L, diff)/dims))

grdDT = as.data.table(coordinates(grd))[ , I := .I]

min.cells = ceiling(6969600/prod(dims))
N = nrow(crimes.marw1)
a = min.cells*prod(dims)
A = gArea(portland)

# Bandwidth ####
nn = 20L
bws = seq(100, 4000, length.out = nn)
plotdata = data.table(index = rep(c("pai", "pei"), each = 2L*nn),
                      bandwidth = rep(bws, 2L),
                      all = numeric(2L*nn), street = numeric(2L*nn),
                      burg = numeric(2L*nn), vehi = numeric(2L*nn))
       
for (bw in bws) {
  kdes = rbindlist(lapply(crimes_ym, compute.kdes, port.coord, bw, ncells["x"], ncells["y"]), idcol = "mo")
  #weight prior Marches at .02 relative to current February
  kdes[ , wt := .02 + .98*(substr(mo, 1, 2) == "16")]
  #aggregate
  wt.kde = kdes[ , lapply(.SD, function(x) sum(x * wt)), 
                 by = .(x, y), .SDcols = !c("mo", "wt")]
  spplot(SpatialGridDataFrame(grd600, data = wt.kde[ , !"id", with = FALSE], proj4string = prj))
  all.rk = grdDF[wt.kde[order(all, decreasing = TRUE)[1:min.cells], id], ]
  rank.all <- head(order(grd.layer$kde.all.feb16, decreasing = TRUE),
                 max.cells)
  plotdata[index == "pai" & bandwidth == bw,
           `:=`(all = pai(n = sum(!is.na(`$`(future %over% a.all, ID))), N = N, a = a, A = A)
}
