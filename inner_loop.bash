#!/bin/sh
#$ -cwd
#$ -q all.q
#$ -pe openmp 1
#$ -S /bin/bash
#$ -o /home/chiricom/portland/output_vw_fit3.log
#$ -e /home/chiricom/portland/error_vw_fit3.log

source /etc/profile.d/modules.sh
module unload R/3.2.3
module load shared R/3.3.2 vowpal_wabbit gcc/5.2.0

sh fit_features.bash 600 600 0 1 2 200 1e-5 1e-4 .5 1 0 .5 "$@"
