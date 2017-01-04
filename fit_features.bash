#!/bin/bash
#$ -cwd
#$ -q all.q
#$ -pe openmp 1
#$ -S /bin/bash
#$ -o /home/chiricom/portland/output_vw_fit.log
#$ -e /home/chiricom/portland/error_vw_fit.log

source /etc/profile.d/modules.sh
module unload R/3.2.3
module load shared R/3.3.2 vowpal_wabbit

#create vw file
#  arguments:
#    1 ) E-W grid width (delx)
#    2 ) N-S grid width (dely)
#    3 ) forecast area target weight (alpha):
#          alpha = 0 : minimum forecast area
#          alpha = 1 : maximum forecast area
#    4 ) lengthscale (l)
#    5 ) # of features (k)
#    6 ) L1 loss parameter for VW (l1)
#    7 ) L2 loss parameter for VW (l2)
#    8 ) learning rate, learning parameter for VW (lambda)
#    9 ) decay rate, learning parameter for VW (delta)
#    10) initial t, learning parameter for VW (t0)
#    11) power t, learning parameter for VW (p)
#    12) competition metric m (pei or pai)
#    13) forecasting horizon h:
#         h = 1w : one week
#         h = 2w : two weeks
#         h = 1m : one month
#         h = 2m : two months
#         h = 3m : three months
#    14) crime category c
#         c = all : All Calls for Service
#         c = street : Street Crime
#         c = burglary : Burglary
#         c = vehicle : Motor Vehicle Theft
./create_vw.R "$@"
