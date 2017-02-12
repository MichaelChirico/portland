#!/bin/sh
#$ -cwd
#$ -q all.q
#$ -pe openmp 1
#$ -S /bin/bash
#$ -o /home/chiricom/portland/output_random.log
#$ -e /home/chiricom/portland/error_random.log
source /etc/profile.d/modules.sh
module unload R/3.2.3
module load shared R/3.3.2 vowpal_wabbit gcc/5.2.0
#see http://stackoverflow.com/questions/6395078/
unset R_HOME


sh fit_features.bash 600 600 0 1 1 0.913683930877448 200 500 1 all 2m
sh fit_features.bash 250 250 0 1 1 0.0998696619608595 100 250 1 all 2m
sh fit_features.bash 600 600 0 1 1 0.51907472801451 200 500 1 all 2m
sh fit_features.bash 250 250 0 1 1 0.297713861091596 100 250 1 all 2m
sh fit_features.bash 600 600 0 1 1 0.479644894517963 200 500 1 all 2m
sh fit_features.bash 250 250 0 1 1 0.365883960809877 100 250 1 all 2m
sh fit_features.bash 600 600 0 1 1 1.60015060899286 200 500 1 all 2m
sh fit_features.bash 250 250 0 1 1 0.152896739688635 100 250 1 all 2m
sh fit_features.bash 600 600 0 1 1 2.89331483205053 200 500 1 all 2m
sh fit_features.bash 250 250 0 1 1 1.26058535415416 100 250 1 all 2m
sh fit_features.bash 600 600 0 1 1 2.76014950570589 200 500 1 all 2m
sh fit_features.bash 250 250 0 1 1 2.18844469277424 100 250 1 all 2m
sh fit_features.bash 600 600 0 1 1 0.205502436298482 200 500 1 all 2m
sh fit_features.bash 250 250 0 1 1 1.90859999858802 100 250 1 all 2m
sh fit_features.bash 600 600 0 1 1 1.9607400812889 200 500 1 all 2m
sh fit_features.bash 250 250 0 1 1 2.34120786657932 100 250 1 all 2m
sh fit_features.bash 600 600 0 1 1 1.21189885165162 200 500 1 all 2m
sh fit_features.bash 250 250 0 1 1 0.0900726451443562 100 250 1 all 2m
sh fit_features.bash 600 600 0 1 1 1.96054067604573 200 500 1 all 2m
sh fit_features.bash 250 250 0 1 1 2.85346454492612 100 250 1 all 2m
