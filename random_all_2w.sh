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


sh fit_features.bash 425 600 0 1 1 0.212172895818467 100 250 1 all 2w
sh fit_features.bash 250 250 0 1 1 1.49197536495688 50 250 1 all 2w
sh fit_features.bash 425 600 0 1 1 2.08198602584059 100 250 1 all 2w
sh fit_features.bash 250 250 0 1 1 2.97778188671669 50 250 1 all 2w
sh fit_features.bash 425 600 0 1 1 0.964474403624506 100 250 1 all 2w
sh fit_features.bash 250 250 0 1 1 1.3985341958657 50 250 1 all 2w
sh fit_features.bash 425 600 0 1 1 2.06437010541536 100 250 1 all 2w
sh fit_features.bash 250 250 0 1 1 2.45952484067049 50 250 1 all 2w
sh fit_features.bash 425 600 0 1 1 2.13191202299019 100 250 1 all 2w
sh fit_features.bash 250 250 0 1 1 0.179739538256083 50 250 1 all 2w
sh fit_features.bash 425 600 0 1 1 0.677263014288729 100 250 1 all 2w
sh fit_features.bash 250 250 0 1 1 2.41439239889456 50 250 1 all 2w
sh fit_features.bash 425 600 0 1 1 1.10700645064495 100 250 1 all 2w
sh fit_features.bash 250 250 0 1 1 0.655210058208876 50 250 1 all 2w
sh fit_features.bash 425 600 0 1 1 2.91256377501199 100 250 1 all 2w
sh fit_features.bash 250 250 0 1 1 0.589742485324542 50 250 1 all 2w
sh fit_features.bash 425 600 0 1 1 1.31605503401469 100 250 1 all 2w
sh fit_features.bash 250 250 0 1 1 3.01103917363904 50 250 1 all 2w
sh fit_features.bash 425 600 0 1 1 0.798248447509076 100 250 1 all 2w
sh fit_features.bash 250 250 0 1 1 0.817111260558096 50 250 1 all 2w
