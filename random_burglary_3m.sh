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


sh fit_features.bash 425 425 0 1 1 0.000476687467374966 100 800 1 burglary 3m
sh fit_features.bash 250 250 2.22044604925031e-16 4 0.5 0.517715493522652 10 250 1 burglary 3m
sh fit_features.bash 425 425 0 1 1 2.42036630679466 100 800 1 burglary 3m
sh fit_features.bash 250 250 2.22044604925031e-16 4 0.5 0.306498343297682 10 250 1 burglary 3m
sh fit_features.bash 425 425 0 1 1 3.05527323230228 100 800 1 burglary 3m
sh fit_features.bash 250 250 2.22044604925031e-16 4 0.5 2.70046170564087 10 250 1 burglary 3m
sh fit_features.bash 425 425 0 1 1 2.86017502915329 100 800 1 burglary 3m
sh fit_features.bash 250 250 2.22044604925031e-16 4 0.5 0.702263558656038 10 250 1 burglary 3m
sh fit_features.bash 425 425 0 1 1 2.5338885442058 100 800 1 burglary 3m
sh fit_features.bash 250 250 2.22044604925031e-16 4 0.5 1.57052093612377 10 250 1 burglary 3m
sh fit_features.bash 425 425 0 1 1 0.469992378897658 100 800 1 burglary 3m
sh fit_features.bash 250 250 2.22044604925031e-16 4 0.5 2.3027484839288 10 250 1 burglary 3m
sh fit_features.bash 425 425 0 1 1 0.163882789255983 100 800 1 burglary 3m
sh fit_features.bash 250 250 2.22044604925031e-16 4 0.5 0.429796904549096 10 250 1 burglary 3m
sh fit_features.bash 425 425 0 1 1 0.122289358436923 100 800 1 burglary 3m
sh fit_features.bash 250 250 2.22044604925031e-16 4 0.5 0.601956531734315 10 250 1 burglary 3m
sh fit_features.bash 425 425 0 1 1 2.75882748346122 100 800 1 burglary 3m
sh fit_features.bash 250 250 2.22044604925031e-16 4 0.5 2.36251951306065 10 250 1 burglary 3m
sh fit_features.bash 425 425 0 1 1 2.46255344243533 100 800 1 burglary 3m
sh fit_features.bash 250 250 2.22044604925031e-16 4 0.5 2.6640228096203 10 250 1 burglary 3m
