#!/usr/bin/env Rscript
# Forecasting Crime in Portland
# **     GPP Featurization      **
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
cat("Setup...\t")
t0 = proc.time()["elapsed"]
suppressMessages({
  library(spatstat, quietly = TRUE)
  #data.table after spatstat to
  #  access data.table::shift more easily
  library(data.table, warn.conflicts = FALSE, quietly = TRUE)
})

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
t0.vw = as.numeric(args[10L])
pp = as.numeric(args[11L])

#outer parameters
metric = args[12L]
horizon = args[13L]
crime.type = args[14L]

#baselines for testing:
# delx=dely=600;alpha=0;lengthscale=1800
# features=5;l1=1e-5;l2=1e-4;lambda=.5;
# delta=1;t0.vw=1;pp=.5
# metric='pei';hh='2w';crime.type='all'

aa = delx*dely #forecasted area
end.date = 
  as.IDate(switch(
    horizon, '1w' = '2016-03-06', '2w' = '2016-03-13',
    '1m' = '2016-03-31', '2m' = '2016-04-30', '3m' = '2016-05-21'
  ))

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

t1 = proc.time()["elapsed"]
cat(sprintf("%3.0fs", t1 - t0), "\n")
cat("Pixellate...\t")
t0 = proc.time()["elapsed"]
crimes.grid.dt = 
  crimes[occ_date <= end.date, 
         as.data.table(pixellate(ppp(
           x = x_coordina, y = y_coordina,
           xrange = xrng, yrange = yrng, check = FALSE),
           dimyx = c(y = dely, x = delx))),
         by = week_no]

t1 = proc.time()["elapsed"]
cat(sprintf("%3.0fs", t1 - t0), "\n")
cat("Delete Cells...\t")
t0 = proc.time()["elapsed"]
#_should_ be ordered by this anyway
crimes.grid.dt[order(-week_no, x, y), I := seq_len(.N), by = week_no]
#subset to eliminate never-crime cells
crimes.grid.dt = 
  crimes.grid.dt[crimes_ever, .(week_no, x, y, value, I), on = "I"]

#can use this to split into train & test
crimes.grid.dt[ , train := week_no > 0L]

#project -- these are the omega * xs
t1 = proc.time()["elapsed"]
cat(sprintf("%3.0fs", t1 - t0), "\n")
cat("Project+Featurize...\t")
t0 = proc.time()["elapsed"]
proj = crimes.grid.dt[ , cbind(x, y, week_no)] %*% 
  matrix(rnorm(3*features), nrow = 3L) / lengthscale

#create the features
phi = cbind(cos(proj), sin(proj))/sqrt(features)

t1 = proc.time()["elapsed"]
cat(sprintf("%3.0fs", t1 - t0), "\n")
cat("VW Output...\n")
t0 = proc.time()["elapsed"]

#temporary files
train.vw = tempfile()
test.vw = tempfile()
cache = tempfile()
model = tempfile()
pred.vw = tempfile()

cat("Training file:", train.vw,
    "\nTesting file:", test.vw,
    "\nCache:", cache,
    "\nModel:", model,
    "\nPredictions:", pred.vw, "\n")

#convert to data.table to use fwrite
phi.dt = with(crimes.grid.dt,
              data.table(v = value,
                         l = paste0(I, "_", week_no, "|")))
for (jj in seq_len(ncol(phi)))
  set(phi.dt, j = paste0("V", jj), 
      value = sprintf("V%i:%.5f", jj, phi[ , jj]))
fwrite(phi.dt[crimes.grid.dt$train], train.vw, 
       sep = " ", quote = FALSE, col.names = FALSE)
fwrite(phi.dt[!crimes.grid.dt$train], test.vw, 
       sep = " ", quote = FALSE, col.names = FALSE)

## **TO DO: eliminate the cache purge once the system's
##          up and running properly**
if (file.exists(cache)) system(paste('rm', cache))
#train with VW
t1 = proc.time()["elapsed"]
cat("\n****************************\n",
    "VW Output...\t", sprintf("%3.0fs", t1 - t0), "\n")
cat("VW Training...\n")
t0 = proc.time()["elapsed"]
system(paste('vw --loss_function poisson --l1', l1, '--l2', l2, 
             '--learning_rate', lambda,
             '--decay_learning_rate', delta,
             '--initial_t', t0.vw, '--power_t', pp, train.vw,
             '--cache_file', cache, '--passes 200 -f', model))
#test with VW
t1 = proc.time()["elapsed"]
cat("\n****************************\n",
    "VW Training...\t", sprintf("%3.0fs", t1 - t0), "\n")
cat("VW Testing...\n")
t0 = proc.time()["elapsed"]

system(paste('vw -t -i', model, '-p', pred.vw, 
             test.vw, '--loss_function poisson'))

preds = fread(pred.vw, sep = " ", header = FALSE, col.names = c("pred", "I_wk"))
preds[ , c("I", "week_no", "I_wk") := 
         c(lapply(tstrsplit(I_wk, split = "_"), as.integer),
           list(NULL))]

crimes.future[preds, pred.count := exp(i.pred), on = c("I", "week_no")]

#when we're at the minimum forecast area, we must round up
#  to be sure we don't undershoot; when at the max,
#  we must round down; otherwise, just round
# **TO DO: if we predict any boundary cells and are using the minimum
#          forecast area, WE'LL FALL BELOW IT WHEN WE CLIP TO PORTLAND **
t1 = proc.time()["elapsed"]
cat("\n****************************\n", 
    "VW Testing...\t", sprintf("%3.0fs", t1 - t0), "\n")
cat("Calculate Score...\t")
t0 = proc.time()["elapsed"]
which.round = function(x)
  if (x > 0) {if (x < 1) round else floor} else ceiling

n.cells = as.integer(which.round(alpha)(6969600*(1+2*alpha)/aa))

hotspot.ids =
  crimes.future[ , .(tot.pred = sum(pred.count)), by = I
                 ][order(-tot.pred)[1L:n.cells], I]
crimes.future[ , hotspot := I %in% hotspot.ids]

#how well did we do? lower-case n in the PEI/PAI calculation
nn = crimes.future[(hotspot), sum(value)]

score =
  switch(metric,
         pei = nn/crimes.future[ , .(tot.crimes = sum(value)), by = I
                                 ][order(-tot.crimes)[1L:n.cells],
                                   sum(tot.crimes)],
         #rather than load the portland shapefile just to calculate
         #  the total area, pre-do that here
         pai = (nn/crimes.future[ , sum(value)])/(aa*n.cells/4117777129))

ff = paste0("scores/", crime.type, "_", horizon, "_", metric, ".csv")

if (!file.exists(ff)) 
  cat("delx,dely,alpha,l,k,l1,l2,lambda,delta,t0,p,score\n", file = ff)

cat(paste(delx, dely, alpha, lengthscale, features, l1, l2,
          lambda, delta, t0.vw, pp, score, sep = ","), "\n",
    append = TRUE, file = ff)
t1 = proc.time()["elapsed"]
cat(sprintf("%3.0fs", t1 - t0), "\n")
