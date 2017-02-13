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


sh fit_features.bash 600 600 0 1 1 1.1045366206809 100 250 1 street 2w
sh fit_features.bash 250 425 0 1 1 0.367681957349364 50 250 1 street 2w
sh fit_features.bash 600 600 0 1 1 0.67372775864257 100 250 1 street 2w
sh fit_features.bash 250 425 0 1 1 0.0144693891767094 50 250 1 street 2w
sh fit_features.bash 600 600 0 1 1 2.05375489314631 100 250 1 street 2w
sh fit_features.bash 250 425 0 1 1 1.69842007044752 50 250 1 street 2w
sh fit_features.bash 600 600 0 1 1 1.53055955426896 100 250 1 street 2w
sh fit_features.bash 250 425 0 1 1 2.96514396637658 50 250 1 street 2w
sh fit_features.bash 600 600 0 1 1 2.82914974121409 100 250 1 street 2w
sh fit_features.bash 250 425 0 1 1 1.35092058504769 50 250 1 street 2w
sh fit_features.bash 600 600 0 1 1 2.25381650011527 100 250 1 street 2w
sh fit_features.bash 250 425 0 1 1 2.81495709810211 50 250 1 street 2w
sh fit_features.bash 600 600 0 1 1 3.10020203807595 100 250 1 street 2w
sh fit_features.bash 250 425 0 1 1 1.55063237026803 50 250 1 street 2w
sh fit_features.bash 600 600 0 1 1 2.64571270091935 100 250 1 street 2w
sh fit_features.bash 250 425 0 1 1 1.7531939052776 50 250 1 street 2w
sh fit_features.bash 600 600 0 1 1 0.694165019719384 100 250 1 street 2w
sh fit_features.bash 250 425 0 1 1 0.87077359802699 50 250 1 street 2w
sh fit_features.bash 600 600 0 1 1 0.722686458266068 100 250 1 street 2w
sh fit_features.bash 250 425 0 1 1 0.162405100824328 50 250 1 street 2w
