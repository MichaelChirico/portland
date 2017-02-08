#!/bin/sh
#$ -cwd
#$ -q all.q
#$ -pe openmp 1
#$ -S /bin/bash
#$ -o /home/ppau/output_portland.log
#$ -e /home/ppau/error_portland.log
source /etc/profile.d/modules.sh
module unload R/3.2.3
module load shared R/3.3.2 vowpal_wabbit gcc/5.2.0
#see http://stackoverflow.com/questions/6395078/
unset R_HOME

sh fit_features.bash 250 600 0 1 1 2 250 1 vehicle 1w
