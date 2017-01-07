#!/bin/sh

for hh in 1w 2w 1m 2m 3m
do
	for cr in all street burglary vehicle
	do
		qsub inner_loop.bash $hh $cr
	done
done
