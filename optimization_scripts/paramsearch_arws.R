#!/usr/bin/env Rscript
#  A grid search
library(data.table)
params = CJ(
  delx = c(250,600,800),
  dely = c(250,600,800),
  alpha = 0,
  eta = c(1,2),
  lt = c(1,2),
  theta = 0,
  k = c(250),
  kde.bw = c(125,250), 
  kde.lags = c(4,8,12),
  kde.win = c(3,8,12),
  crime = c('vehicle','street'),
  horizon = c('2w','1m','3m')
)

# 400 400 0 2 2 0 50 250 5 5 all 2w
# for(i in 1:nrow(params)) {
  for(i in 1:10) {
  with(params[i,],
       cat(
         sprintf("
                 #!/bin/bash
                 module load R
                 module load vowpal_wabbit
                 unset R_HOME

                 cd /home/ubuntu/scratch/portland
                 Rscript ar_ws_evaluate_params.R ",i,i), delx,dely,alpha,eta,lt,theta,k,kde.bw,kde.lags,kde.win,crime,horizon,"\n", 
         file=sprintf("scripts/arwsmodel-%d.bash",i)
         )
       )
  print(sprintf("qsub scripts/arwsmodel-%d.bash",i))
  system(sprintf("qsub scripts/arwsmodel-%d.bash",i))
  if(i %% 200 == 0) {
    print(sprintf("step %d",i))
    Sys.sleep(2)
  }
}

