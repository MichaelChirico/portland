#!/bin/bash
#$ -cwd
#$ -q all.q
#$ -pe openmp 1
#$ -S /bin/bash
#$ -o /home/chiricom/portland/pei_pai_scripts/output_rotate.log
#$ -e /home/chiricom/portland/pei_pai_scripts/error_rotate.log
./grid_rotation.R 1000 250 1w
./grid_rotation.R 1000 250 2w
./grid_rotation.R 1000 250 1m
./grid_rotation.R 1000 250 2m

./grid_rotation.R 250 1000 1w
./grid_rotation.R 250 1000 2w
./grid_rotation.R 250 1000 1m
./grid_rotation.R 250 1000 2m

./grid_rotation.R 1200 300 1w
./grid_rotation.R 1200 300 2w
./grid_rotation.R 1200 300 1m
./grid_rotation.R 1200 300 2m

./grid_rotation.R 300 1200 1w
./grid_rotation.R 300 1200 2w
./grid_rotation.R 300 1200 1m
./grid_rotation.R 300 1200 2m
