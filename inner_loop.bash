#!/bin/sh
#$ -cwd
#$ -q all.q
#$ -pe openmp 1
#$ -S /bin/bash
#$ -o /home/chiricom/portland/output_vw_fit.log
#$ -e /home/chiricom/portland/error_vw_fit.log

source /etc/profile.d/modules.sh
module unload R/3.2.3
module load shared R/3.3.2 vowpal_wabbit gcc/5.2.0
#see http://stackoverflow.com/questions/6395078/
unset R_HOME

for dx in 250 425 600
do
	for dy in 250 425 600
	do
		for eta in 2 2.5 3.5 4.5 5.5
		do
			for lt in 2 2.5 3.5 4.5 5.5
			do
				sh fit_features.bash $dx $dy 0 $eta $lt 200 1e-5 1e-4 .5 1 0 .5 "$@"
			done
		done
	done
done
