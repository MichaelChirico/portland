#!/bin/bash
#$ -cwd
#$ -q all.q
#$ -pe openmp 1
#$ -S /bin/bash
#$ -o /home/chiricom/portland/pei_pai_scripts/output_rotate.log
#$ -e /home/chiricom/portland/pei_pai_scripts/error_rotate.log
./grid_rotation.R 750 250 1w
./grid_rotation.R 750 250 2w
./grid_rotation.R 750 250 1m
./grid_rotation.R 750 250 2m

./grid_rotation.R 1000 300 1w
./grid_rotation.R 1000 300 2w
./grid_rotation.R 1000 300 1m
./grid_rotation.R 1000 300 2m

./grid_rotation.R 400 600 1w
./grid_rotation.R 400 600 2w
./grid_rotation.R 400 600 1m
./grid_rotation.R 400 600 2m
