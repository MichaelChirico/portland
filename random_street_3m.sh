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


sh fit_features.bash 600 600 0 1 1 1.57880402290758 500 500 1 street 3m
sh fit_features.bash 250 250 0 1 1 0.081063902716931 50 250 1 street 3m
sh fit_features.bash 600 600 0 1 1 2.38876404762229 500 500 1 street 3m
sh fit_features.bash 250 250 0 1 1 2.01692847670967 50 250 1 street 3m
sh fit_features.bash 600 600 0 1 1 0.491903789607293 500 500 1 street 3m
sh fit_features.bash 250 250 0 1 1 1.36667123591409 50 250 1 street 3m
sh fit_features.bash 600 600 0 1 1 2.85769526085528 500 500 1 street 3m
sh fit_features.bash 250 250 0 1 1 1.3362278704543 50 250 1 street 3m
sh fit_features.bash 600 600 0 1 1 1.53317856457268 500 500 1 street 3m
sh fit_features.bash 250 250 0 1 1 2.74616916858016 50 250 1 street 3m
sh fit_features.bash 600 600 0 1 1 1.93602870242935 500 500 1 street 3m
sh fit_features.bash 250 250 0 1 1 2.07675713896217 50 250 1 street 3m
sh fit_features.bash 600 600 0 1 1 2.79263450061918 500 500 1 street 3m
sh fit_features.bash 250 250 0 1 1 1.55591428938973 50 250 1 street 3m
sh fit_features.bash 600 600 0 1 1 1.35042083979701 500 500 1 street 3m
sh fit_features.bash 250 250 0 1 1 0.553155550771861 50 250 1 street 3m
sh fit_features.bash 600 600 0 1 1 2.58474101688397 500 500 1 street 3m
sh fit_features.bash 250 250 0 1 1 2.23795839425865 50 250 1 street 3m
sh fit_features.bash 600 600 0 1 1 2.73948823676111 500 500 1 street 3m
sh fit_features.bash 250 250 0 1 1 2.11464816916139 50 250 1 street 3m
