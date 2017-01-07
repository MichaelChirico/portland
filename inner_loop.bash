#!/bin/sh
#$ -cwd
#$ -q all.q
#$ -pe openmp 1
#$ -S /bin/bash
#$ -o /home/chiricom/portland/output_vw_fit3.log
#$ -e /home/chiricom/portland/error_vw_fit3.log

source /etc/profile.d/modules.sh
module unload R/3.2.3
module load shared R/3.3.2 vowpal_wabbit gcc/5.2.0

for dx in 250 425 600
do
	for dy in 250 425 600
	do
		for eta in 0 3 6
		do
			for lt in 0 3 6
			do
				sh fit_features.bash $dx $dy 0 $eta $lt 200 1e-5 1e-4 .5 1 0 .5 "$@"
			done
		done
	done
done
