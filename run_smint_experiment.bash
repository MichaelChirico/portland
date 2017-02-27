#! /bin/bash

# direcory where smint_template is
experdir=/backup/portland

# directory where main.py is in spearmint installation
smintdir=/opt/pkgs/spearmint/Spearmint/spearmint

crime=$1
horizon=$2
score=$3

# 1. create an experiment directory
echo '1. create an experiment directory'
# --------------------------------------------------------
newdir=$experdir/smint-$crime-$horizon-$score
mkdir $newdir

# 2. copy template in experiment dir
echo '2. copy template in experiment dir'
# --------------------------------------------------------
cp -a $experdir/smint_template/. $newdir # copy all files of template

# 3. make experiment file
echo '3. make experiment file'
# name of file example: all-3m-pai.exper
# to be read by main python code when running
# the model. It tells it crime, horizon and score.
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
if [ -d $newdir/output ]
	then
		echo 'CLEANING UP OUTPUT FILE!'
		$smintdir/cleanup.sh $newdir
fi	
python $smintdir/main.py $newdir