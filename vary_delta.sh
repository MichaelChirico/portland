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

for dx in 250 425
do
	for dy in 250 425
	do
		for eta in 4 4.5 5 5.5 6
		do
			for lt in 1.5 2 2.5 3 3.5
			do
				for delta in .01 .05 .1 .5 1 1.5 2 2.5
				do
					sh fit_features.bash $dx $dy 0 $eta $lt 200 1e-5 1e-4 .5 $delta 0 .5 1w all
				done
			done
		done
	done
done
