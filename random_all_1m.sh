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


sh fit_features.bash 600 600 0 1 1 0.627809625990891 50 500 1 all 1m
sh fit_features.bash 250 250 0 1 1 1.34823214392047 50 250 1 all 1m
sh fit_features.bash 600 600 0 1 1 0.523290690414838 50 500 1 all 1m
sh fit_features.bash 250 250 0 1 1 0.974390515870383 50 250 1 all 1m
sh fit_features.bash 600 600 0 1 1 1.20441619098591 50 500 1 all 1m
sh fit_features.bash 250 250 0 1 1 2.1351376498305 50 250 1 all 1m
sh fit_features.bash 600 600 0 1 1 1.62595822770948 50 500 1 all 1m
sh fit_features.bash 250 250 0 1 1 1.05817035452838 50 250 1 all 1m
sh fit_features.bash 600 600 0 1 1 2.11060457362083 50 500 1 all 1m
sh fit_features.bash 250 250 0 1 1 1.12795007375091 50 250 1 all 1m
sh fit_features.bash 600 600 0 1 1 1.01961246555753 50 500 1 all 1m
sh fit_features.bash 250 250 0 1 1 2.31897793691066 50 250 1 all 1m
sh fit_features.bash 600 600 0 1 1 0.589794913382666 50 500 1 all 1m
sh fit_features.bash 250 250 0 1 1 2.02143058222901 50 250 1 all 1m
sh fit_features.bash 600 600 0 1 1 2.75337994592084 50 500 1 all 1m
sh fit_features.bash 250 250 0 1 1 1.03252220412282 50 250 1 all 1m
sh fit_features.bash 600 600 0 1 1 2.42567232822318 50 500 1 all 1m
sh fit_features.bash 250 250 0 1 1 1.7107323181592 50 250 1 all 1m
sh fit_features.bash 600 600 0 1 1 2.84550852932042 50 500 1 all 1m
sh fit_features.bash 250 250 0 1 1 2.40012817227512 50 250 1 all 1m
