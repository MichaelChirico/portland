#!/bin/bash

#create vw file
#  arguments:
#    1 ) E-W grid width (delx)
#    2 ) N-S grid width (dely)
#    3 ) forecast area target weight alpha:
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
#    12) competition metric (pei or pai)
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
#              1   2  3   4   5   6    7   8 9 10 11  12 13  14
./create_vw.R 600 600 0 1800 20 1e-4 1e-5 .5 1  0 .5 pei 1w all
