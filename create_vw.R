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

crimes = fread("crimes.csv")

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

#now subset to desired date range
crimes = crimes[as.IDate(occ_date) %between%
                  c("2016-02-22", "2016-02-28")]

#repeat over-cell counting
crimes.grid.dt = 
  with(crimes, setDT(as.data.frame(pixellate(ppp(
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

fwrite(phi.dt[ , .(paste0(
  crimes.grid.dt$value, " ", 
  crimes.grid.dt$I, "| ", sapply(transpose(lapply(
    names(.SD), function(jj)
      paste0(jj, ":", get(jj)))),
    paste, collapse = " ")))], 
  "output.vw", col.names = FALSE, quote = FALSE)

system('rm output.cache')
#train with VW
system(paste('vw --loss_function poisson --l2 1e-4 --l1 1e-5 output.vw',
             '--cache_file output.cache --passes 200 -f output.model'))
#test with VW
system('vw -t -i output.model -p output_pred.txt output.vw --loss_function poisson')

preds = fread("output_pred.txt", sep = " ", 
              header = FALSE, col.names = c("pred", "I"))

crimes.grid.dt[preds, pred := i.pred, on = "I"]
