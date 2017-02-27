#!/usr/bin/env Rscript
library(data.table)
fn = list.files('scores', full.names = TRUE)
names(fn) = gsub('.*ar_ws_my_(.*)arws.*', '\\1', fn)

x = rbindlist(lapply(fn, fread), idcol = 'hc')

x[ , run_no := .GRP, 
   by =  c('delx', 'dely', 'eta', 'lt', 'theta', 
           'k', 'kde.bw', 'kde.lags', 'kde.win')]

x[ , param_no := .GRP, 
   by =  setdiff(names(x), c('train_set', 'pei', 'pai'))]

cat('**OPTIMA FROM', max(x$run_no), 'RUNS**\n\n')

idx = x[ , .(mean(pei), mean(pai)), by = param_no
         ][unique(c(which.max(V1), which.max(V2))), param_no]

x[param_no == idx]
