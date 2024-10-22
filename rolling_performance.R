#!/usr/bin/env Rscript
# Forecasting Crime in Portland
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
suppressMessages({
  library(spatstat)
  library(splancs)
  library(rgeos)
  library(rgdal)
  library(data.table)
  library(maptools)
  library(magrittr)
  #local "package" of functions
  source('utils.R')
})
#make sure we use the same seed
#  as evaluation_params.R
set.seed(60251935)

arg = commandArgs(trailingOnly = TRUE)
day0s = arg[1L]
crime.type = arg[2L]
use_scraped = arg[3L] == 'use_scraped'
month_based = arg[4L] == 'month_based'
#default for testing
if (is.na(day0s)) {
  day0s = '20170308';crime.type = 'bur'
  use_scraped = FALSE;month_based=FALSE
}
params = grep(sprintf('%s.*1w', crime.type), 
              readLines('final_parameters.rtf'), value = TRUE)
attach(
  setNames(lapply(tstrsplit(params, ' ')[4L:15L], as.numeric),
           c('delx', 'dely', 'alpha', 'eta', 'lt',
             'theta', 'features', 'l1' , 'l2',
             'kde.bw', 'kde.lags', 'kde.win')),
  name = 'params'
)

aa = delx*dely
lx = eta*250
ly = eta*250

# copy definition of week numbering from crimes_to_csv.R
day0 = as.IDate(day0s, format = '%Y%m%d')
week_0 = unclass(as.IDate("2017-02-28") - day0) %/% 7L + 1L

# weeks between week_0 and recent[2L] are those in
#   the past half-year (which was the originally
#   intended purpose of the include_mos variable)
recent = week_0 + c(0L, 26L)

crimes = fread(sprintf('crimes_%s.csv', crime.type))
if (use_scraped) {
  feb28 = fread('data/rss_feed_Feb28.csv')[ , occ_date := '2017-02-28']
  categ = switch(crime.type, 'all' = expression(TRUE),
                 'str' = expression(CATEGORY == 'STREET CRIMES'),
                 'veh' = expression(CATEGORY == 'MOTOR VEHICLE THEFT'),
                 'bur' = expression(CATEGORY == 'BURGLARY'))
  crimes = rbind(crimes[occ_date != '2017-02-28'],
                 feb28[eval(categ), 
                       .(x_coordina, y_coordina, occ_date)], fill = TRUE)
}
crimes[ , occ_date := as.IDate(occ_date)]

point0 = crimes[ , c(min(x_coordina), min(y_coordina))]
crimes[ , paste0(c('x', 'y'), '_coordina') :=
          as.data.table(rotate(x_coordina, y_coordina, theta, point0))]

portland_r = 
  with(fread('data/portland_coords.csv'),
       rotate(x, y, theta, point0))

xrng = range(portland_r[ , 1L])
yrng = range(portland_r[ , 2L])

grdtop = ppp(xrange = xrng, yrange = yrng) %>%
  pixellate(eps = c(delx, dely)) %>% 
  as.SpatialGridDataFrame.im %>%
  as('GridTopology')

rowids = seq_len(prod(grdtop@cells.dim))
grdSPDF = SpatialPolygonsDataFrame(
  as.SpatialPolygons.GridTopology(grdtop, proj4string = prj),
  data = data.frame(I = rowids, row.names = sprintf('g%d', rowids)), 
  match.ID = FALSE
)

idx.new = getGTindices(grdtop)

incl_ids =
  with(crimes[week_no > week_0], as.data.table(pixellate(ppp(
    x = x_coordina, y = y_coordina,
    xrange = xrng, yrange = yrng, check = FALSE),
    eps = c(delx, dely)))[idx.new, ]
  )[value > 0, which = TRUE]

pd_length = 7L
half_year = 26L
yr_length = 2L * half_year * pd_length

crimes[ , occ_date_int := unclass(occ_date)]
unq_crimes = crimes[ , unique(occ_date_int)]

day0_int = unclass(day0)
if (month_based) {
  incl_mos = c(10L, 11L, 12L, 1L, 2L, 3L)
  pd_length = 7L
  one_year = 52L
  n_pds = 5L*one_year
  start = day0_int - (seq_len(n_pds) - 1L) * pd_length
  start = start[month(as.Date(start, origin = '1970-01-01')) %in% incl_mos]
} else {
  start = c(sapply(day0_int - (seq_len(5L) - 1L) * yr_length,
                   function(yr_start) yr_start - 
                     (seq_len(half_year) - 1L) * pd_length))
}

windows = data.table(start, end = start + pd_length - 1L, key = 'start,end')

crime_start_map = data.table(occ_date_int = unq_crimes)
crime_start_map[ , start_date := 
                   foverlaps(data.table(start = occ_date_int, 
                                        end = occ_date_int),
                             windows)$start]

crimes[crime_start_map, start_date := i.start_date,
       on = 'occ_date_int']

X = crimes[!is.na(start_date), as.data.table(pixellate(ppp(
  x = x_coordina, y = y_coordina,
  xrange = xrng, yrange = yrng, check = FALSE),
  #reorder using GridTopology - im mapping
  eps = c(x = delx, dely)))[idx.new],
  #subset to eliminate never-crime cells
  keyby = start_date][ , I := rowid(start_date)]

# calculate N*, N here before removing never-crime cells
n.cells = as.integer(which.round(alpha)(6969600*(1+2*alpha)/aa))
#force copy (don't risk copy-by-reference issues)
actual = copy(X[start_date == day0_int][order(-value)[1:n.cells]])
N_star = actual[ , sum(value)]
NN = X[start_date == day0_int, sum(value)]
X = X[I %in% incl_ids]

crimes.sp =
  SpatialPointsDataFrame(
    coords = crimes[ , cbind(x_coordina, y_coordina)],
    data = crimes[ , -c('x_coordina', 'y_coordina')],
    proj4string = prj
  )

crimes.sp@data = setDT(crimes.sp@data)
#for faster indexing
setkey(crimes.sp@data, occ_date_int)

compute.kde <- function(pts, start, lag.no) {
  idx = pts@data[occ_date_int %between% 
                   (start - kde.win*lag.no + c(0, kde.win - 1L)), which = TRUE]
  if (!length(idx)) return(rep(0, length(incl_ids)))
  kde = spkernel2d(pts = pts[idx, ],
                   poly = portland_r, h0 = kde.bw, grd = grdtop)[incl_ids]
}

start_lag = CJ(start = start, lag = seq_len(kde.lags))

RHS = start_lag[, c(I = list(incl_ids),
                    lapply(setNames(lag, paste0('lag', lag)), compute.kde, 
                           pts = crimes.sp, start = .BY$start)),
                by = start]

X = X[RHS, on = c(start_date = 'start', 'I')]

X[ , train := start_date != day0_int]

proj = X[ , cbind(x, y, start_date)] %*% 
  (matrix(rt(3L*features, df = 2.5), nrow = 3L)/c(lx, ly, lt))

incl = setNames(nm = names(X))
incl.kde = grep("^lag", incl, value = TRUE)

phi.dt =
  X[ , {
    coln_to_vw = function(vn) { 
      V = get(vn)
      #to assure maximum comparability to the data model used
      #  in training, be sure to multiply by the same factor
      trainV = V[start_date <= day0_int - yr_length & V > 0]
      val = V * 10^(abs(round(mean(log10(trainV)))))
      if (any(is.nan(val)))
        stop('NaNs detected! Current parameters:',
             paste(args, collapse = '/'))
      sprintf("%s:%.5f", vn, val)
    }
    c(list(v = value, 
           l = paste0(I, "_", start_date, "|kdes")), 
      lapply(incl.kde, coln_to_vw),
      list(rff_namespace = '|rff'))
  }]

if (features > 500L) invisible(alloc.col(phi.dt, 3L*features))
fkt = 1/sqrt(features)
for (jj in 1L:features) {
  pj = proj[ , jj]
  set(phi.dt, j = paste0(c("cos", "sin"), jj), 
      value = list(sprintf("cos%i:%.5f", jj, fkt*cos(pj)),
                   sprintf("sin%i:%.5f", jj, fkt*sin(pj))))
}
rm(proj)

hostname = Sys.info()["nodename"]

if(grepl("ziz",hostname)) { # Seth's setup
    source("cleanup.R")
    tdir = "/data/localhost/not-backed-up/flaxman"
    job_id = paste0("_",Sys.getenv("SLURM_JOB_ID"))
    path_to_vw = "./vw"
} else if (grepl('michael', hostname)) {
    tdir = "/tmp"
    job_id = ""
    path_to_vw = "vw"
} else if (grepl('gpc', hostname)) {
  tdir = "/data/shared/loefflerlab/portland_temp"
  job_id = ""
  path_to_vw = "vw"
} else {
  tdir = "delete_me"
  job_id = if (length(jid <- Sys.getenv("REQNAME"))) 
    gsub(".*/|\\..*", "", jid) else ""
  path_to_vw = "vw" 
}

filename = paste('output', day0s, sep = '_')
train.vw = paste(paste0(tdir, '/train'), filename, sep = '_')
test.vw = paste(paste0(tdir, '/test'), filename, sep='_')
cache = paste0(train.vw, '.cache')
pred.vw = paste(paste0(tdir, '/pred'), filename, sep='_')
fwrite(phi.dt[X$train], train.vw,
       sep = " ", quote = FALSE, col.names = FALSE,
       showProgress = FALSE)
fwrite(phi.dt[!X$train], test.vw,
       sep = " ", quote = FALSE, col.names = FALSE,
       showProgress = FALSE)

model = tempfile(tmpdir = tdir, pattern = "model")

call.vw = paste(path_to_vw, '--loss_function poisson --l1', l1,
                '--random_seed 123456789',
                '--l2', l2, train.vw, '--cache_file', cache,
                '--passes 200 -f', model)
system(call.vw, ignore.stderr = TRUE)
invisible(file.remove(train.vw))

system(paste(path_to_vw, '-t -i', model, '-p', pred.vw,
             test.vw, '--loss_function poisson'),
       ignore.stderr = TRUE)
invisible(file.remove(model))

preds =
  fread(pred.vw, sep = " ", header = FALSE, col.names = c("pred", "I_start"))
invisible(file.remove(pred.vw))

preds[ , c("I", "start_date", "I_start") :=
         c(lapply(tstrsplit(I_start, split = "_"), as.integer),
           list(NULL))]

X[preds, pred.count := exp(i.pred), on = c("I", "start_date")]
rm(preds)

hotspots =
  X[(!train)][X[(!train), .(tot.pred = sum(pred.count)), by = I
                ][order(-tot.pred), .(I, rank = .I)][rank <= n.cells],
              .(I, x, y, value, pred.count), on = 'I']
nn = hotspots[ , sum(value)]

AA = 4117777129

fwrite(rbind(actual = actual, predicted = hotspots, 
             idcol = 'pred_v_actual', fill = TRUE),
       sprintf('top_cells_%s_%s_%s.csv', crime.type, arg[3L], arg[4L]))

cat('Crime:', crime.type, 
    arg[3L], arg[4L],
    'Week:', day0s, 
    '// PEI:', nn/N_star,
    '// PAI:', nn/NN/(aa * n.cells/AA), '\n')
