#!/usr/bin/env Rscript
# Forecasting Crime in Portland
# **     GPP Featurization      **
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
library(spatstat)
#data.table after spatstat to
#  access data.table::shift more easily
library(data.table)

args = commandArgs(trailingOnly = TRUE)
delx = as.integer(args[1L])
dely = as.integer(args[2L])
lengthscale = as.numeric(args[3L])
features = as.integer(args[4L])
l2 = as.numeric(args[5L])
l1 = as.numeric(args[6L])
alpha = as.numeric(args[7L])
metric = args[8L]
horizon = list('1w' = as.Date(c('2016-03-01', '2016-03-06')),
               '2w' = as.Date(c('2016-03-01', '2016-03-13')),
               '1m' = as.Date(c('2016-03-01', '2016-03-31')),
               '2m' = as.Date(c('2016-03-01', '2016-04-30')),
               '3m' = as.Date(c('2016-03-01', '2016-05-21')))[[args[9L]]]

aa = delx*dely #forecasted area

crimes = fread("crimes.csv")
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
    xrange =  xrng, yrange = yrng),
    #this must be done within-loop
    #  since it depends on delx & dely
    dimyx = c(y = dely, x = delx)))))
#record order for more reliable merging below
crimes_ever[order(x, y), I := .I]
#eliminate no-crime cells
crimes_ever = crimes_ever[value > 0]

#repeat over-cell counting
crimes.grid.dt = 
  with(crimes[occ_date %between%
                c("2016-02-22", "2016-02-28")],
       setDT(as.data.frame(pixellate(ppp(
         x = x_coordina, y = y_coordina,
         xrange = xrng, yrange = yrng),
         dimyx = c(y = dely, x = delx)))))
crimes.grid.dt[order(x, y), I := .I]

#subset to eliminate never-crime cells
crimes.grid.dt = 
  crimes.grid.dt[crimes_ever, .(x, y, value, I), on = "I"]

#project -- these are the omega * xs
proj = crimes.grid.dt[ , cbind(x, y)] %*% 
  matrix(rnorm(2*features), nrow = 2L) / lengthscale

#create the features
phi = cbind(cos(proj), sin(proj))/sqrt(features)

#convert to data.table for ease
phi.dt = as.data.table(phi)

#temporary files
out.vw = tempfile()
cache = tempfile()
model = tempfile()
preds = tempfile()

fwrite(phi.dt[ , .(paste0(
  crimes.grid.dt$value, " ", 
  crimes.grid.dt$I, "| ", sapply(transpose(lapply(
    names(.SD), function(jj)
      paste0(jj, ":", get(jj)))),
    paste, collapse = " ")))], 
  out.vw, col.names = FALSE, quote = FALSE)

## **TO DO: eliminate the cache purge once the system's
##          up and running properly**
if (file.exists(cache)) system(paste('rm', cache))
#train with VW
system(paste('vw --loss_function poisson --l2', l2, '--l1', l1, out.vw,
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
which.round = function(x) if (x > 0) {if (x < 1) round else floor} else ceiling

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

switch(metric,
       pei = nn/crimes.future[order(-value)[1L:n.cells], sum(value)],
       #rather than load the portland shapefile just to calculate
       #  the total area, pre-do that here
       pai = (nn/crimes.future[ , sum(value)])/(aa*n.cells/4117777129))
