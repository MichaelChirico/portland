#!/bin/sh

dx=100
dy=625	  	
	# for dy in 250 425 600
	# do
      for kdebw in 250 500 800 1000
	  do
		for horizon in 1w 2w 1m 2m 3m
		do
		   for cat in all street burglary vehicle
		   do

			 # ./fit_features.bash $dx $dy 0 1 4 200 $kdebw 1 $cat $horizon 
			 ./create_vw_kdes.R $dx $dy 0 1 4 200 $kdebw 1 $cat $horizon 

		   done
		done
	  done
# 	done
# done

dx=625
dy=100
      for kdebw in 250 500 800 1000
	  do
	  	
		for horizon in 1w 2w 1m 2m 3m
		do
		   for cat in all street burglary vehicle
		   do

			 # ./fit_features.bash $dx $dy 0 1 4 200 $kdebw 1 $cat $horizon 
			 ./create_vw_kdes.R $dx $dy 0 1 4 200 $kdebw 1 $cat $horizon 

		   done
		done
	  done