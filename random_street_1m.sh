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


sh fit_features.bash 600 600 0 1 1 1.18801403833042 500 500 1 street 1m
sh fit_features.bash 250 250 0 1 1 0.43200502651481 50 250 1 street 1m
sh fit_features.bash 600 600 0 1 1 2.54353704996765 500 500 1 street 1m
sh fit_features.bash 250 250 0 1 1 2.80333632568458 50 250 1 street 1m
sh fit_features.bash 600 600 0 1 1 2.303091563088 500 500 1 street 1m
sh fit_features.bash 250 250 0 1 1 0.725260306825763 50 250 1 street 1m
sh fit_features.bash 600 600 0 1 1 0.0150400113454132 500 500 1 street 1m
sh fit_features.bash 250 250 0 1 1 0.433310302004774 50 250 1 street 1m
sh fit_features.bash 600 600 0 1 1 1.767411577455 500 500 1 street 1m
sh fit_features.bash 250 250 0 1 1 3.08497819937053 50 250 1 street 1m
sh fit_features.bash 600 600 0 1 1 2.70168477391228 500 500 1 street 1m
sh fit_features.bash 250 250 0 1 1 2.45869799059458 50 250 1 street 1m
sh fit_features.bash 600 600 0 1 1 2.40618338769915 500 500 1 street 1m
sh fit_features.bash 250 250 0 1 1 2.25384663183894 50 250 1 street 1m
sh fit_features.bash 600 600 0 1 1 2.52089872623631 500 500 1 street 1m
sh fit_features.bash 250 250 0 1 1 2.46123746496816 50 250 1 street 1m
sh fit_features.bash 600 600 0 1 1 2.52581032227543 500 500 1 street 1m
sh fit_features.bash 250 250 0 1 1 0.516050207059644 50 250 1 street 1m
sh fit_features.bash 600 600 0 1 1 0.769767931169823 500 500 1 street 1m
sh fit_features.bash 250 250 0 1 1 1.76200187097615 50 250 1 street 1m
