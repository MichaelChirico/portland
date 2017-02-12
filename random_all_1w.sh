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


sh fit_features.bash 600 600 0 1 1 0.24826514754848 50 500 1 all 1w
sh fit_features.bash 250 250 0 1 1 2.77228092723401 50 250 1 all 1w
sh fit_features.bash 600 600 0 1 1 0.588149449459632 50 500 1 all 1w
sh fit_features.bash 250 250 0 1 1 2.76676668501797 50 250 1 all 1w
sh fit_features.bash 600 600 0 1 1 0.0729366635219394 50 500 1 all 1w
sh fit_features.bash 250 250 0 1 1 2.95556214773537 50 250 1 all 1w
sh fit_features.bash 600 600 0 1 1 2.53009570525883 50 500 1 all 1w
sh fit_features.bash 250 250 0 1 1 0.495119562231416 50 250 1 all 1w
sh fit_features.bash 600 600 0 1 1 3.06308981279709 50 500 1 all 1w
sh fit_features.bash 250 250 0 1 1 0.500874064603823 50 250 1 all 1w
sh fit_features.bash 600 600 0 1 1 0.110065035027642 50 500 1 all 1w
sh fit_features.bash 250 250 0 1 1 3.01081388937504 50 250 1 all 1w
sh fit_features.bash 600 600 0 1 1 2.46628321278953 50 500 1 all 1w
sh fit_features.bash 250 250 0 1 1 1.07250845631644 50 250 1 all 1w
sh fit_features.bash 600 600 0 1 1 1.43831553712396 50 500 1 all 1w
sh fit_features.bash 250 250 0 1 1 2.91711448305867 50 250 1 all 1w
sh fit_features.bash 600 600 0 1 1 0.867910592005583 50 500 1 all 1w
sh fit_features.bash 250 250 0 1 1 2.68185017729886 50 250 1 all 1w
sh fit_features.bash 600 600 0 1 1 1.54039989321 50 500 1 all 1w
sh fit_features.bash 250 250 0 1 1 2.09400598325149 50 250 1 all 1w
