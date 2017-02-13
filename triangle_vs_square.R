# February 10, 2017
# Compare efficiency of triangular grid and square grid.

library(rgdal)
library(sp)
library(dplyr)
library(tidyr)
library(data.table)

# load triangular grid
grd.tri = readOGR('data/grids', 'triA625')
plot(grd.tri)
prj = CRS(proj4string(grd.tri))

# load crimes csv
crimes= fread('crimes_all.csv')

to.map = function (dt, prj=CRS("+init=epsg:2913")) {
  crimes.sp = with(dt,
                   SpatialPointsDataFrame(
                     coords = cbind(x_coordina, y_coordina),
                     data = dt[, -c('x_coordina','y_coordina'), with=FALSE],
                     proj4string = prj))
}

# load portland boundary:
portland.bdy = readOGR('data', 'portland_boundary')

# create square grid
aa = gArea(grd.tri[100, ])
cell.sizes = c(sqrt(aa), sqrt(aa))
bb = bbox(portland.bdy)
nb.cells.xy = round((bb[, 'max'] - bb[, 'min'])/cell.sizes)
grdtop = GridTopology(cellcentre.offset = bb[, 'min'],
                      cellsize = cell.sizes,
                      cells.dim = nb.cells.xy)

# transform to SpatialPolygons
grd.poly = as.SpatialPolygons.GridTopology(grd = grdtop, 
                                           proj4string = prj)

# clip to portland boundaries
grd.poly = 
  gIntersection(
    grd.spdf[which(gIntersects(grd.poly, portland.bdy, byid = TRUE)), ], 
    portland.bdy, byid = TRUE
  )

# transform to SpatialPolygonsDataFrame 
grd.spdf = SpatialPolygonsDataFrame(Sr = grd.poly,
                                    data=data.frame(id = seq_len(prod(nb.cells.xy))),
                                    match.ID = FALSE)


# counts 
crimes.subs = crimes[month_no==1] # subsample crimes to forecasting horizon
crimes.subs.sp = to.map(crimes.subs, prj = prj)

# --- for triangle grid
grd.tri.count = over(crimes.subs.sp, grd.tri, returnList = F) %>% 
  group_by(ID) %>% 
  summarise(count = n())

# append counts to grid
grd.tri@data = merge(grd.tri@data, grd.tri.count, by='ID', all.x=TRUE)

# --- for square grid
grd.sqr.count = over(crimes.subs.sp, grd.spdf, returnList = F) %>% 
  group_by(id) %>% 
  summarise(count = n())

# select top cells
area.max = 2.0909e+7
area.min = 6969600

nb.cells = round(area.min/aa)

hotspots.tri = grd.tri.count[order(-grd.tri.count$count), 'ID'][1:nb.cells,]$ID
hotspots.sqr = grd.sqr.count[order(-grd.sqr.count$count), 'id'][1:nb.cells,]$id

plot(portland.bdy)
plot(grd.tri[grd.tri$ID %in% hotspots.tri, ], add=T, col='red')
plot(grd.spdf[grd.spdf$id %in% hotspots.sqr, ], add=T, col='yellow')

hotspots.tri.counts = grd.tri.count[order(-grd.tri.count$count), 'count'][1:nb.cells,]
hotspots.sqr.counts = grd.sqr.count[order(-grd.sqr.count$count), 'count'][1:nb.cells,]

counts = data.table(cbind(hotspots.tri.counts, hotspots.sqr.counts))
setnames(counts, c('tri','sqr'))
counts[, `:=`(tri.sum = sum(tri),
              sqr.sum = sum(sqr))]
fwrite(counts, file = 'data/triangle_vs_square.csv')
