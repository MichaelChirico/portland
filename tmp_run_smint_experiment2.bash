#! /bin/bash

# direcory where smint_template is
experdir=/backup/portland

# directory where main.py is in spearmint installation
smintdir=/opt/pkgs/spearmint/Spearmint/spearmint

crime=$1
horizon=$2
score=$3
constr=$4


# 1. create an experiment directory
echo '1. create an experiment directory'
# --------------------------------------------------------
if [ -n $constr ]; then # constrained
	echo 'Running CONSTRAINED experiment. HERE WE GO!'
 	newdir=$experdir/smint-$crime-$horizon-$score-constr	
else
	newdir=$experdir/smint-$crime-$horizon-$score
fi

if [ -d $newdir ]; then
	echo 'Removing exising experiment directory...Hope nothing important was there!'
	# sudo rm -rf $newdir  <--- not working (?!)
	mv $newdir $experdir/delete_me/smint-$crime-$horizon-$score
fi

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

# poor way of changing config file to constrained one
# should write python script to edit config file and add constraint code...
if [ -n $constr ]; then # true if string constr is nonzero
    echo "Changing config to constrained..."
    mv config.json config.json.dontuse
	mv config.json.constr config.json
fi

# 4. change experiment name in config.json
echo '4. change experiment name in config.json'
# --------------------------------------------------------
if [ -n $constr ]; then # true if string constr is nonzero
	python change_exper_name.py $crime-$horizon-$score
else
  	python change_exper_name.py $crime-$horizon-$score
fi

# 5. run experiment
echo '5. run experiment'
# --------------------------------------------------------
if [ -d $newdir/output ]
	then
		echo 'CLEANING UP OUTPUT FILE!'
		$smintdir/cleanup.sh $newdir
fi	
python $smintdir/main.py $newdir