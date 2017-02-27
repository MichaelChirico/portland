#! /bin/bash

cd /opt/pkgs/spearmint/Spearmint/spearmint


crime=all
horizon=3m

# create an experiment directory
newdir=/backup/portland/smint-$crime-$horizon
mkdir $newdir

# copy template
cp /backup/portland/smint_template/main_arws.py $newdir/main_arws.py
