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
#    4 ) spatial lengthscale factor (eta):
#          lengthscale_{x,y} = eta*del{x,y}
#    5 ) temporal lengthscale (lt):
#    6 ) # of features (k)
#    7 ) L1 loss parameter for VW (l1)
#    8 ) L2 loss parameter for VW (l2)
#    9 ) learning rate, learning parameter for VW (lambda)
#    10) decay rate, learning parameter for VW (delta)
#    11) initial t, learning parameter for VW (t0)
#    12) power t, learning parameter for VW (p)
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
