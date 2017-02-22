#!/usr/bin/env Rscript
set.seed(60251935)

library(data.table)

params = list(
  delx = seq(250,600,100),
  delx = seq(250,600,100),
  alpha = 0,
  eta = seq(1,5,1),
  lt = seq(2,4,1),
  theta = 0,
  k = seq(20,100,50),
  kde.bw = seq(100,1000,50),
  kde.lags = seq(4,24,6),
  kde.win = seq(3,30,10),
  crime = c('all','street','burglary','vehicle'),
  horizon = c('1w','2w','1m','2m','3m')
)

stopifnot(kde.lags*kde.win < 365)

print(paste0('number of param combinations = ', prod(sapply(params, length))))

params.mat = do.call(CJ, params)

# randomize
params.mat = params.mat[sample.int(n = .N)]

# call
library(parallel)

to.run = function (param) {
  system(paste('./sm_evaluate_params.R', paste(param, collapse = " ")))  
}

nb.combinations = 200
mclapply(
  split(
    params.mat[1:nb.combinations], 
    eq(nrow(params.mat[1:nb.combinations]))), 
  to.run)

