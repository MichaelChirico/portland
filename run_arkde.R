#!/usr/bin/env Rscript
# load params:
para = fread('best_of_bo.csv')
para[, kde.win := 7]
best.pai = para[, .SD[order(-pai)[1]], by=.(crime, period)]
setkey(best.pai, crime, period)

with(best.pai[.('all','1m')], 
     system(paste('./arkde.R', delx, dely, alpha, eta, lt, theta, k, 
           kde.bw, kde.lags, kde.win, crime, period))
)
