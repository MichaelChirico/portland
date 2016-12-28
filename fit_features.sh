#!/bin/bash

#create vw file
#  arguments:
#    1) E-W grid width (delx)
#    2) N-S grid width (dely)
#    3) lengthscale (l)
#    4) # of features (k)
./create_vw.R 600 600 1800 20

#train with VW
rm output.cache
vw --loss_function poisson --l2 1e-4 --l1 1e-5 output.vw --cache_file output.cache --passes 200 -f output.model

#test with VW
vw -t -i output.model -p output_pred.txt output.vw --loss_function poisson
