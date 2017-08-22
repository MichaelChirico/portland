#!/usr/bin/env Rscript
#  Running a grid search 
library(data.table)
params =
  CJ(crime = c('all', 'burglary'),
     horizon = c('1w', '1m', '3m'),
     delx = seq(150, 750, length.out = 5),
     dely = seq(150, 750, length.out = 5),
     eta = seq(.25, 2.5, length.out = 5),
     lt = seq(7, 90, length.out = 5),
     theta = seq(0, pi/2, length.out = 5),
     k = c(50, 150, 250),
     kde.bw = seq(100, 600, length.out = 5),
     kde.lags = c(1, 3, 6, 8, 10),
     kde.win = seq(7L, 30L, length.out = 5))

params = params[(delx*dely) %between% c(250^2, 600^2)][sample(.N, 100)]

for(i in 1:nrow(params)) {
  with(params[i],
       cat(
         sprintf("#!/bin/sh
#$ -cwd
#$ -q all.q
#$ -pe openmp 1
#$ -S /bin/bash
#$ -o /home/chiricom/portland/output_170227.log
#$ -e /home/chiricom/portland/error_170227.log

source /etc/profile.d/modules.sh
module unload R/3.2.3
module load shared R/3.3.2 vowpal_wabbit gcc/5.2.0
#see http://stackoverflow.com/questions/6395078/
unset R_HOME
                 
Rscript /home/chiricom/portland/ar_ws_evaluate_params.R "),
         delx,dely,eta,lt,theta,k,kde.bw,kde.lags,kde.win,crime,horizon,
         file=sprintf("scripts/arwsmodel170227-%d.bash",i)
         )
       )
  print(sprintf("qsub scripts/arwsmodel170227-%d.bash",i))
  system(sprintf("qsub scripts/arwsmodel170227-%d.bash",i))
}

