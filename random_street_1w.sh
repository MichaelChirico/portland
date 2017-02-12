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


sh fit_features.bash 600 425 0 1 1 1.93680534442532 200 250 1 street 1w
sh fit_features.bash 250 250 0 1 1 2.37180685799584 50 250 1 street 1w
sh fit_features.bash 600 425 0 1 1 0.101545862524198 200 250 1 street 1w
sh fit_features.bash 250 250 0 1 1 0.464975923084995 50 250 1 street 1w
sh fit_features.bash 600 425 0 1 1 1.75232712265833 200 250 1 street 1w
sh fit_features.bash 250 250 0 1 1 2.30948239093734 50 250 1 street 1w
sh fit_features.bash 600 425 0 1 1 0.318149975240636 200 250 1 street 1w
sh fit_features.bash 250 250 0 1 1 0.177164608599927 50 250 1 street 1w
sh fit_features.bash 600 425 0 1 1 1.92580193952934 200 250 1 street 1w
sh fit_features.bash 250 250 0 1 1 2.80334597582369 50 250 1 street 1w
sh fit_features.bash 600 425 0 1 1 2.57327205879012 200 250 1 street 1w
sh fit_features.bash 250 250 0 1 1 2.71553625209338 50 250 1 street 1w
sh fit_features.bash 600 425 0 1 1 1.48072743110958 200 250 1 street 1w
sh fit_features.bash 250 250 0 1 1 2.71100269017804 50 250 1 street 1w
sh fit_features.bash 600 425 0 1 1 1.7502110255544 200 250 1 street 1w
sh fit_features.bash 250 250 0 1 1 0.177370583808193 50 250 1 street 1w
sh fit_features.bash 600 425 0 1 1 1.09304718100248 200 250 1 street 1w
sh fit_features.bash 250 250 0 1 1 0.60521186312622 50 250 1 street 1w
sh fit_features.bash 600 425 0 1 1 0.729663707067915 200 250 1 street 1w
sh fit_features.bash 250 250 0 1 1 0.511560662154935 50 250 1 street 1w
