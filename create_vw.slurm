#!/bin/bash
#note anything after #SBATCH is a command
#SBATCH --mail-user=flaxman@gmail.com
#Email you if job starts, completed or failed
#SBATCH --mail-type=ALL
#SBATCH --job-name=portland-test
#SBATCH --partition=small
#Choose your partition depending on your requirements
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --time=1:00:00
#SBATCH --mem-per-cpu=8192
#Memory per cpu in megabytes      
#SBATCH --output=/data/localhost/not-backed-up/flaxman/portland_%j.txt

Rscript create_vw.R 250 425 0 1.5 4 2000 .01 1e-4 .5 1 0 .5 1w all

#print environment variables: the job ID.
echo "SLURM_JOBID: " $SLURM_JOBID

# Make a Job directory for output and results if it does not exist
#mkdir -p /data/ziz/not-backed-up/flaxman/results/portland_${SLURM_JOBID}
#mkdir -p /data/ziz/not-backed-up/flaxman/outputs/portland_${SLURM_JOBID}


mv /data/localhost/not-backed-up/flaxman/portland_${SLURM_JOBID}.txt /data/ziz/not-backed-up/flaxman/results/portland_${SLURM_JOBID}.txt
mv /data/localhost/not-backed-up/flaxman/scores*${SLURM_JOBID}* /data/ziz/not-backed-up/flaxman/portland-scores/
mv /data/localhost/not-backed-up/flaxman/timings*${SLURM_JOBID}* /data/ziz/not-backed-up/flaxman/portland-timings/
