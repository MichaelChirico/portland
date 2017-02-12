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


sh fit_features.bash 600 600 0 1 1 2.66020714183671 50 500 1 street 2m
sh fit_features.bash 250 250 0 1 1 1.10528231391344 500 250 1 street 2m
sh fit_features.bash 600 600 0 1 1 2.86204203446442 50 500 1 street 2m
sh fit_features.bash 250 250 0 1 1 2.73218970481653 500 250 1 street 2m
sh fit_features.bash 600 600 0 1 1 2.40302690421894 50 500 1 street 2m
sh fit_features.bash 250 250 0 1 1 1.32607692547812 500 250 1 street 2m
sh fit_features.bash 600 600 0 1 1 2.05889880715954 50 500 1 street 2m
sh fit_features.bash 250 250 0 1 1 3.09938284710764 500 250 1 street 2m
sh fit_features.bash 600 600 0 1 1 1.88419156080433 50 500 1 street 2m
sh fit_features.bash 250 250 0 1 1 2.23070052119624 500 250 1 street 2m
sh fit_features.bash 600 600 0 1 1 1.37924197832454 50 500 1 street 2m
sh fit_features.bash 250 250 0 1 1 1.72331002991138 500 250 1 street 2m
sh fit_features.bash 600 600 0 1 1 1.93116008619194 50 500 1 street 2m
sh fit_features.bash 250 250 0 1 1 2.42842669355926 500 250 1 street 2m
sh fit_features.bash 600 600 0 1 1 2.59929267618471 50 500 1 street 2m
sh fit_features.bash 250 250 0 1 1 0.31736739599164 500 250 1 street 2m
sh fit_features.bash 600 600 0 1 1 2.60900745871868 50 500 1 street 2m
sh fit_features.bash 250 250 0 1 1 1.76274539396972 500 250 1 street 2m
sh fit_features.bash 600 600 0 1 1 0.384886307716757 50 500 1 street 2m
sh fit_features.bash 250 250 0 1 1 2.58229346423644 500 250 1 street 2m
