#!/usr/bin/env Rscript
library(data.table)
params =
  data.table(crime = 
               c("all", "all", "all", "all", "all", "burglary", 
                 "burglary", "burglary", "burglary", "burglary", 
                 "street", "street", "street", "street", "street",
                 "vehicle", "vehicle", "vehicle", "vehicle", "vehicle"),
             horizon = c("1m", "1w", "2m", "2w", "3m", 
                        "1m", "1w", "2m", "2w", "3m", 
                        "1m", "1w", "2m", "2w", "3m", "1m", 
                        "1w", "2m", "2w", "3m"), 
             delx = 250L, dely = 250L, 
             eta = c(1, 2, 1, 1.5, 0.5, 0.5, 1, 1, 1, 0.5, 
                     0.5, 1, 1, 2, 0.5, 1, 0.5, 1, 0.5, 0.5),
             lt = c(0.5, 1.5, 0.5, 0.5, 2, 1, 2, 2, 0.5, 0.5, 
                    0.5, 2, 2, 0.5, 0.5, 0.5, 1, 1, 2, 2),
             theta = 0, 
             k = c(250L, 50L, 250L, 250L, 250L, 250L,
                   250L, 250L, 250L, 250L, 250L, 50L, 250L, 
                   250L, 250L, 250L, 250L, 250L, 250L, 250L),
             kde.bw = 250,
             kde.lags = c(6L, 3L, 6L, 6L, 6L, 6L, 6L, 6L, 6L,
                          6L, 6L, 6L, 6L, 3L, 6L, 6L, 6L, 6L, 6L, 6L), 
             kde.win = c(15L, 30L, 30L, 15L, 15L, 3L, 30L, 30L, 30L, 30L, 
                         30L, 15L, 30L, 20L, 30L, 3L, 3L, 3L, 3L, 3L))

for(i in 1:nrow(params)) {
  with(params[i],
       cat(
         sprintf("#!/bin/sh
                 #$ -cwd
                 #$ -q all.q
                 #$ -pe openmp 1
                 #$ -S /bin/bash
                 #$ -o /home/chiricom/portland/output_robust.log
                 #$ -e /home/chiricom/portland/error_robust.log

                 source /etc/profile.d/modules.sh
                 module unload R/3.2.3
                 module load shared R/3.3.2 vowpal_wabbit gcc/5.2.0
                 #see http://stackoverflow.com/questions/6395078/
                 unset R_HOME

                 Rscript ~/portland/ar_ws_15_evaluate_params.R ",i,i),
         delx,dely,eta,lt,theta,k,kde.bw,kde.lags,kde.win,crime,horizon,"\n", 
         file=sprintf("scripts/arwsmodel15-%d.bash",i)
         )
       )
  print(sprintf("qsub scripts/arwsmodel15-%d.bash",i))
  system(sprintf("qsub scripts/arwsmodel15-%d.bash",i))
}

