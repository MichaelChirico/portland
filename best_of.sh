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

sh fit_features.bash 600 425 0 2 6 200 1000 6 all 1m
sh fit_features.bash 600 250 0 2 6 200 1000 6 all 1m
sh fit_features.bash 425 600 0 1.5 4 500 1000 6 all 1w
sh fit_features.bash 250 600 0 1.5 5 300 1000 6 all 1w
sh fit_features.bash 600 600 0 1.5 4 100 1000 6 all 2m
sh fit_features.bash 600 600 0 2 2.5 200 1000 6 all 2w
sh fit_features.bash 600 250 0 2 5.5 200 1000 6 all 2w
sh fit_features.bash 600 425 0 2 6 200 1000 6 all 3m
sh fit_features.bash 425 425 0 2 6 200 1000 6 all 3m
sh fit_features.bash 600 425 0 3.5 4.5 200 1000 6 burglary 1m
sh fit_features.bash 250 250 0 2 3 200 1000 6 burglary 1m
sh fit_features.bash 250 425 0 2.5 2 200 1000 6 burglary 1w
sh fit_features.bash 600 425 0 3.5 4.5 200 1000 6 burglary 2m
sh fit_features.bash 250 250 0 2 6 200 1000 6 burglary 2m
sh fit_features.bash 250 250 0 6 2.5 200 1000 6 burglary 2w
sh fit_features.bash 425 600 0 3.5 2 200 1000 6 burglary 3m
sh fit_features.bash 250 250 0 1 3.5 200 1000 6 burglary 3m
sh fit_features.bash 600 600 0 2 5.5 200 1000 6 street 1m
sh fit_features.bash 600 600 0 2 2 200 1000 6 street 1w
sh fit_features.bash 425 600 0 3.5 6 200 1000 6 street 2m
sh fit_features.bash 250 600 0 3.5 4.5 200 1000 6 street 2m
sh fit_features.bash 600 600 0 2 3.5 200 1000 6 street 2w
sh fit_features.bash 425 600 0 3.5 6 200 1000 6 street 3m
sh fit_features.bash 250 600 0 3.5 5.5 200 1000 6 street 3m
sh fit_features.bash 600 600 0 6 2 200 1000 6 vehicle 1m
sh fit_features.bash 250 250 0 6 1 200 1000 6 vehicle 1m
sh fit_features.bash 425 600 0 2.5 2.5 200 1000 6 vehicle 1w
sh fit_features.bash 250 250 0 1 1 200 1000 6 vehicle 1w
sh fit_features.bash 600 600 0 6 2 200 1000 6 vehicle 2m
sh fit_features.bash 250 250 0 6 1 200 1000 6 vehicle 2m
sh fit_features.bash 600 600 0 2 3.5 200 1000 6 vehicle 2w
sh fit_features.bash 250 250 0 2 1 200 1000 6 vehicle 2w
sh fit_features.bash 250 250 0 4.5 1 200 1000 6 vehicle 3m
