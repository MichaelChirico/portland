#!/bin/bash

#create vw file
#  arguments:
#    1) E-W grid width (delx)
#    2) N-S grid width (dely)
#    3) lengthscale (l)
#    4) # of features (k)
#    5) L2 loss parameter for VW
#    6) L1 loss parameter for VW
#    7) forecast area target weight alpha:
#         alpha = 0: minimum forecast area
#         alpha = 1: maximum forecast area
./create_vw.R 600 600 1800 20 1e-4 1e-5 0
