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


sh fit_features.bash 250 250 1 1.84240358101623 3.720838347878 0.184581413082462 10 250 1 burglary 2w
sh fit_features.bash 250 250 0 1 1 1.17625054362507 50 250 1 burglary 2w
sh fit_features.bash 250 250 1 1.84240358101623 3.720838347878 2.10031745145233 10 250 1 burglary 2w
sh fit_features.bash 250 250 0 1 1 2.76077531792205 50 250 1 burglary 2w
sh fit_features.bash 250 250 1 1.84240358101623 3.720838347878 0.491693974239069 10 250 1 burglary 2w
sh fit_features.bash 250 250 0 1 1 1.94086399046708 50 250 1 burglary 2w
sh fit_features.bash 250 250 1 1.84240358101623 3.720838347878 1.49570046421365 10 250 1 burglary 2w
sh fit_features.bash 250 250 0 1 1 1.60736259543533 50 250 1 burglary 2w
sh fit_features.bash 250 250 1 1.84240358101623 3.720838347878 1.6853230191199 10 250 1 burglary 2w
sh fit_features.bash 250 250 0 1 1 1.18020504160293 50 250 1 burglary 2w
sh fit_features.bash 250 250 1 1.84240358101623 3.720838347878 0.968993485576694 10 250 1 burglary 2w
sh fit_features.bash 250 250 0 1 1 1.62419464997511 50 250 1 burglary 2w
sh fit_features.bash 250 250 1 1.84240358101623 3.720838347878 2.02193129812584 10 250 1 burglary 2w
sh fit_features.bash 250 250 0 1 1 1.24991523856959 50 250 1 burglary 2w
sh fit_features.bash 250 250 1 1.84240358101623 3.720838347878 1.79891276434873 10 250 1 burglary 2w
sh fit_features.bash 250 250 0 1 1 0.0310788834059559 50 250 1 burglary 2w
sh fit_features.bash 250 250 1 1.84240358101623 3.720838347878 1.70326708523657 10 250 1 burglary 2w
sh fit_features.bash 250 250 0 1 1 0.490744610625692 50 250 1 burglary 2w
sh fit_features.bash 250 250 1 1.84240358101623 3.720838347878 2.09288095901828 10 250 1 burglary 2w
sh fit_features.bash 250 250 0 1 1 1.76482926518275 50 250 1 burglary 2w
