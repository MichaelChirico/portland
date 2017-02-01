#!/bin/sh
#$ -cwd
#$ -q all.q
#$ -pe openmp 1
#$ -S /bin/bash
#$ -o /home/chiricom/portland/output_best_of.log
#$ -e /home/chiricom/portland/error_best_of.log

source /etc/profile.d/modules.sh
module unload R/3.2.3
module load shared R/3.3.2 vowpal_wabbit gcc/5.2.0
#see http://stackoverflow.com/questions/6395078/
unset R_HOME

sh fit_features.bash 600 425 0 2 6 200 1e-05 1e-04 0.5 1 0 0.5 500 6 3m all
sh fit_features.bash 600 600 0 2 6 200 1e-05 1e-04 0.5 1 0 0.5 500 6 3m all
sh fit_features.bash 425 425 0 2 6 200 1e-05 1e-04 0.5 1 0 0.5 500 6 3m all
sh fit_features.bash 600 600 0 2 5.5 200 1e-05 1e-04 0.5 1 0 0.5 500 6 3m all
sh fit_features.bash 600 425 0 4.5 5.5 200 1e-05 1e-04 0.5 1 0 0.5 500 6 3m all
sh fit_features.bash 600 425 0 4.5 6 200 1e-05 1e-04 0.5 1 0 0.5 500 6 3m all
sh fit_features.bash 600 425 0 6 6 200 1e-05 1e-04 0.5 1 0 0.5 500 6 3m all
sh fit_features.bash 425 425 0 3 6 200 1e-05 1e-04 0.5 1 0 0.5 500 6 3m all
sh fit_features.bash 600 425 0 3 5.5 200 1e-05 1e-04 0.5 1 0 0.5 500 6 3m all
sh fit_features.bash 600 600 0 4.5 4.5 200 1e-05 1e-04 0.5 1 0 0.5 500 6 3m all
sh fit_features.bash 425 425 0 2 5.5 200 1e-05 1e-04 0.5 1 0 0.5 500 6 3m all
sh fit_features.bash 425 425 0 3 5.5 200 1e-05 1e-04 0.5 1 0 0.5 500 6 3m all
sh fit_features.bash 250 425 0 3.5 6 200 1e-05 1e-04 0.5 1 0 0.5 500 6 3m all
sh fit_features.bash 250 425 0 3.5 5.5 200 1e-05 1e-04 0.5 1 0 0.5 500 6 3m all
