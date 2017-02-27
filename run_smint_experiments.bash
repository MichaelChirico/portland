#! /bin/bash

# cd /opt/pkgs/spearmint/Spearmint/spearmint
cd /backup/portland

crime=all
horizon=3m
score=pai

# 1. create an experiment directory
echo '1. create an experiment directory'
# --------------------------------------------------------
newdir=/backup/portland/smint-$crime-$horizon-$score
mkdir $newdir

# 2. copy template in experiment dir
echo '2. copy template in experiment dir'
# --------------------------------------------------------
cp -a /backup/portland/smint_template/. $newdir

# 3. make experiment file
echo '3. make experiment file'
# name of file example: all-3m-pai.exper
# --------------------------------------------------------
cd $newdir
python make_experiment_file.py $crime $horizon $score


# 4. change experiment name in config.json
echo '4. change experiment name in config.json'
# --------------------------------------------------------
python change_exper_name.py $crime-$horizon-$score

# 5. run experiment
echo '5. run experiment'
# --------------------------------------------------------
