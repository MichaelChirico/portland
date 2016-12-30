#!/usr/bin/env Rscript
# Forecasting Crime in Portland
# **     GPP Featurization      **
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
library(spatstat)
#data.table after spatstat to
#  access data.table::shift more easily
library(data.table)

#from random.org
set.seed(60251935)

#inner parameters
args = commandArgs(trailingOnly = TRUE)
delx = as.integer(args[1L])
dely = as.integer(args[2L])
alpha = as.numeric(args[3L])
lengthscale = as.numeric(args[4L])
features = as.integer(args[5L])
l1 = as.numeric(args[6L])
l2 = as.numeric(args[7L])
lambda = as.numeric(args[8L])
delta = as.numeric(args[9L])
t0 = as.numeric(args[10L])
pp = as.numeric(args[11L])

#outer parameters
metric = args[12L]
hh = args[13L]
crime.type = args[14L]

#baselines for testing:
delx=dely=600;alpha=0;lengthscale=1800
features=20;l1=1e-5;l2=1e-4;lambda=.5;
delta=1;t0=1;pp=.5
metric='pei';hh='1w';crime.type='all'

aa = delx*dely #forecasted area
horizon = list('1w' = as.IDate(c('2016-03-01', '2016-03-06')),
               '2w' = as.IDate(c('2016-03-01', '2016-03-13')),
               '1m' = as.IDate(c('2016-03-01', '2016-03-31')),
               '2m' = as.IDate(c('2016-03-01', '2016-04-30')),
               '3m' = as.IDate(c('2016-03-01', '2016-05-21')))[[hh]]

crime.file = switch(crime.type,
                    all = "crimes_all.csv",
                    street = "crimes_str.csv",
                    burglary = "crimes_bur.csv",
                    vehicle = "crimes_veh.csv")

crimes = fread(crime.file)
crimes[ , occ_date := as.IDate(occ_date)]

#record range here, so that
#  we have the same range 
#  after we subset below
xrng = crimes[ , range(x_coordina)]
yrng = crimes[ , range(y_coordina)]

crimes_ever = 
  with(crimes, setDT(as.data.frame(pixellate(ppp(
    #pixellate counts dots over each cell,
    #  and appears to do so pretty quickly
    x = x_coordina, y = y_coordina,
    xrange = xrng, yrange = yrng, check = FALSE),
    #this must be done within-loop
    #  since it depends on delx & dely
    dimyx = c(y = dely, x = delx)))))
#record order for more reliable merging below
crimes_ever[order(x, y), I := .I]
#eliminate no-crime cells
crimes_ever = crimes_ever[value > 0]

crimes.grid.dt = 
  crimes[occ_date <= "2016-02-28", 
         as.data.table(pixellate(ppp(
           x = x_coordina, y = y_coordina,
           xrange = xrng, yrange = yrng, check = FALSE),
           dimyx = c(y = dely, x = delx))),
         by = week_no]
#_should_ be ordered by this anyway
crimes.grid.dt[order(-week_no, x, y), I := seq_len(.N), by = week_no]
#subset to eliminate never-crime cells
crimes.grid.dt = 
  crimes.grid.dt[crimes_ever, .(week_no, x, y, value, I), on = "I"]

#project -- these are the omega * xs
proj = crimes.grid.dt[ , cbind(x, y, week_no)] %*% 
  matrix(rnorm(3*features), nrow = 3L) / lengthscale

#create the features
phi = cbind(cos(proj), sin(proj))/sqrt(features)

#convert to data.table for ease
phi.dt = as.data.table(phi)

#temporary files
out.vw = tempfile()
cache = tempfile()
model = tempfile()
preds = tempfile()

# this version is faster, but _much_ more RAM-intensive
#   than going line-by-line... abandoning for now
# fwrite(phi.dt[ , .(paste0(
#   crimes.grid.dt$value, " ", 
#   crimes.grid.dt$I, "| ", sapply(transpose(lapply(
#     names(.SD), function(jj)
#       paste0(jj, ":", get(jj)))),
#     paste, collapse = " ")))], 
#   out.vw, col.names = FALSE, quote = FALSE)
cat('starting VW output\n')
for (ii in seq_len(nrow(crimes.grid.dt))) {
  if (ii %% 1e4 == 0) cat('row', ii, '\n')
  crimes.grid.dt[ii, cat(value, " ", I, "| ", sep = "",
                         file = out.vw, append = TRUE)]
  phi.dt[ii, cat(paste(names(.SD), .SD, sep = ":"), 
                 sep = " ", file = out.vw, append = TRUE)]
  cat("\n", file = out.vw, append = TRUE)
}
  


## **TO DO: eliminate the cache purge once the system's
##          up and running properly**
if (file.exists(cache)) system(paste('rm', cache))
#train with VW
system(paste('vw --loss_function poisson --l1', l1, '--l2', l2, 
             '--learning_rate', lambda,
             '--decay_learning_rate', delta,
             '--initial_t', t0, '--power_t', pp, out.vw,
             '--cache_file', cache, '--passes 200 -f', model))
#test with VW
system(paste('vw -t -i', model, '-p', preds, 
             out.vw, '--loss_function poisson'))

preds = fread(preds, sep = " ", header = FALSE, col.names = c("pred", "I"))

crimes.grid.dt[preds, pred := i.pred, on = "I"]

#when we're at the minimum forecast area, we must round up
#  to be sure we don't undershoot; when at the max,
#  we must round down; otherwise, just round
# **TO DO: if we predict any boundary cells and are using the minimum
#          forecast area, WE'LL FALL BELOW IT WHEN WE CLIP TO PORTLAND **
which.round = function(x)
  if (x > 0) {if (x < 1) round else floor} else ceiling

n.cells = as.integer(which.round(alpha)(6969600*(1+2*alpha)/aa))

crimes.grid.dt[order(-pred), hotspot := .I <= n.cells]

#now, pixellate the future crimes
crimes.future = 
  with(crimes[occ_date %between% horizon],
       setDT(as.data.frame(pixellate(ppp(
         x = x_coordina, y = y_coordina,
         xrange = xrng, yrange = yrng),
         dimyx = c(y = dely, x = delx)))))
crimes.future[order(x, y), I := .I]

#how well did we do? lower-case n in the PEI/PAI calculation
nn = crimes.future[crimes.grid.dt[(hotspot)], sum(x.value), on = "I"]

score =
  switch(metric,
         pei = nn/crimes.future[order(-value)[1L:n.cells], sum(value)],
         #rather than load the portland shapefile just to calculate
         #  the total area, pre-do that here
         pai = (nn/crimes.future[ , sum(value)])/(aa*n.cells/4117777129))

ff = paste0("scores/", crime.type, "_", hh, "_", metric, ".csv")

if (!file.exists(ff)) 
  cat("delx,dely,alpha,l,k,l1,l2,lambda,delta,t0,p,score\n", file = ff)

cat(paste(delx, dely, alpha, lengthscale, features, l1, l2,
          lambda, delta, t0, pp, score, sep = ","), "\n",
    append = TRUE, file = ff)
