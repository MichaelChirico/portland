#!/bin/bash

#create vw file
#  arguments:
#    1 ) E-W grid width (delx)
#    2 ) N-S grid width (dely)
#    3 ) forecast area target weight (alpha):
#          alpha = 0 : minimum forecast area
#          alpha = 1 : maximum forecast area
#    4 ) spatial lengthscale (eta):
#          lengthscale_{x,y} = eta*del{x,y}
#    5 ) temporal lengthscale (lt)
#    6 ) angle of rotation (theta)
#          theta = 0 : rotate 0 degrees through lower-left corner
#          theta = pi/2: rotate 90 degrees "                    "
#    7 ) # of features (k)
#    8 ) KDE bandwidth (kde.bw)
#    9 ) KDE lag count, # of (month-long) lags to include
#          as KDE features (kde.lags)
#    10) temporal bandwith for KDE lags in days, rectangular (kde.win)
#    11) crime category c
#         c = all : All Calls for Service
#         c = street : Street Crime
#         c = burglary : Burglary
#         c = vehicle : Motor Vehicle Theft
#    12) forecasting horizon h:
#         h = 1w : one week
#         h = 2w : two weeks
#         h = 1m : one month
#         h = 2m : two months
#         h = 3m : three months

./evaluate_params.R "$@"
