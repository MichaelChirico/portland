#!/usr/bin/env Rscript
library(data.table)

n_scripts = 40L
n_per = 1000L

NN = n_scripts * n_per

params =
  data.table(delx = runif(NN, 125, 2000),
             dely = NA_real_,
             eta = runif(NN, .5, 6),
             lt = runif(NN, 7, 90),
             theta = runif(NN, 0, pi/2),
             features = sample(50:400, NN, TRUE),
             kde.bw = runif(NN, 125, 1000),
             kde.lags = sample(12, NN, TRUE),
             kde.win = runif(NN, 0, 100),
             horizon = sample(c('1w','2w','1m','2m','3m'), NN, TRUE),
             crime.type = 
               sample(c('all','burglary','street','vehicle'),NN,TRUE))

params[ , dely := runif(.N, 250^2, 600^2)/delx]

params[ , script_no := rep(seq_len(n_scripts), each = n_per)]

params[ , {
  fn = paste0('scripts/random170228_', .BY$script_no, '.bash')
  cat('#!/bin/sh
#$ -cwd
#$ -q all.q
#$ -pe openmp 1
#$ -S /bin/bash
#$ -o /home/chiricom/portland/output_random.log
#$ -e /home/chiricom/portland/error_random.log

source /etc/profile.d/modules.sh
module unload R/3.2.3
module load shared R/3.3.2 vowpal_wabbit gcc/5.2.0
#see http://stackoverflow.com/questions/6395078/
unset R_HOME\n', file = fn)
  
  cat(paste('Rscript /home/chiricom/portland/ar_ws_evaluate_params.R',
            do.call(paste, .SD)), sep = '\n', file = fn, append = TRUE)
  
  system(paste('qsub', fn))
}, by = script_no]
