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


sh fit_features.bash 600 600 0 1 1 0.651492830914296 200 500 1 all 3m
sh fit_features.bash 250 250 0 1 1 1.93325360315533 200 250 1 all 3m
sh fit_features.bash 600 600 0 1 1 1.16887336008434 200 500 1 all 3m
sh fit_features.bash 250 250 0 1 1 1.34666573901628 200 250 1 all 3m
sh fit_features.bash 600 600 0 1 1 0.417892846823024 200 500 1 all 3m
sh fit_features.bash 250 250 0 1 1 0.000957933387484929 200 250 1 all 3m
sh fit_features.bash 600 600 0 1 1 2.72175960581247 200 500 1 all 3m
sh fit_features.bash 250 250 0 1 1 1.19928880063238 200 250 1 all 3m
sh fit_features.bash 600 600 0 1 1 2.4838620328808 200 500 1 all 3m
sh fit_features.bash 250 250 0 1 1 2.67338869204404 200 250 1 all 3m
sh fit_features.bash 600 600 0 1 1 0.270709172352201 200 500 1 all 3m
sh fit_features.bash 250 250 0 1 1 0.332017394840039 200 250 1 all 3m
sh fit_features.bash 600 600 0 1 1 2.971293436881 200 500 1 all 3m
sh fit_features.bash 250 250 0 1 1 2.39169449197277 200 250 1 all 3m
sh fit_features.bash 600 600 0 1 1 1.60770311814518 200 500 1 all 3m
sh fit_features.bash 250 250 0 1 1 1.19371809343578 200 250 1 all 3m
sh fit_features.bash 600 600 0 1 1 1.6871855157175 200 500 1 all 3m
sh fit_features.bash 250 250 0 1 1 2.51119274096021 200 250 1 all 3m
sh fit_features.bash 600 600 0 1 1 2.65707334236424 200 500 1 all 3m
sh fit_features.bash 250 250 0 1 1 0.268769421976669 200 250 1 all 3m
