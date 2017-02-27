#!/usr/bin/env Rscript
library(data.table)
fn = list.files('scores', full.names = TRUE)
names(fn) = gsub('.*ar_ws_my_(.*)arws.*', '\\1', fn)

x = rbindlist(lapply(fn, fread), idcol = 'hc')

cat('**OPTIMA FROM', 
    uniqueN(x, by = c('delx', 'dely', 'eta', 'lt', 'theta', 
                      'k', 'kde.bw', 'kde.lags', 'kde.win')),
    'RUNS**\n\n')

x[ , .SD[unique(c(which.max(pei), which.max(pai)))], by = hc]
