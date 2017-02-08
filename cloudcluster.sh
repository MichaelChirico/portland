#!/bin/bash
#$ -q cloud-small.q    
#$ -N o4
#$ -pe openmp 1
#$ -cwd
#$ -S /bin/bash
#$ -e error.log
#$ -e /home/ppau/cloud_error.log
#$ -o /home/ppau/cloud_output.log

#CMSUB --input=/home/ppau/portland_pau/cloud_data.inp
#CMSUB --input=/home/ppau/portland_pau/cloud_data.out

source /etc/profile.d/modules.sh
module unload R/3.2.3
module load shared R/3.3.2 vowpal_wabbit gcc/5.2.0

# /data/home/ppau/portland_pau/create_vw.R 250 600 0 1 1 2 250 1
cal