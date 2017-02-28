from os import system

header = """#!/bin/bash
#note anything after #SBATCH is a command
#SBATCH --mail-user=flaxman@gmail.com
#Email you if job starts, completed or failed
#SBATCH --mail-type=NONE
#SBATCH --job-name=%s
#SBATCH --partition=%s
#Choose your partition depending on your requirements
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=%s
#SBATCH --mem-per-cpu=%d
#Memory per cpu in megabytes      
#SBATCH --output=/data/localhost/not-backed-up/flaxman/%s_%%j.txt

set -x

"""

rscript = "Rscript ar_ws_evaluate_params.R %d %d %f %f 0 %d %d %d %d %s %s\n"


footer = """
echo "SLURM_JOBID: " $SLURM_JOBID

tail -n 1000 /data/localhost/not-backed-up/flaxman/%s_${SLURM_JOBID}.txt > /data/ziz/not-backed-up/flaxman/results/%s_${SLURM_JOBID}.txt

"""

i = 0
j = 0
scripts = []
allruns = open("scripts/ar-ws-street.csv","wa")
allruns.write("bw1,bw2,eta,lt,features,kdebw,kdelags,crime,period\n")

mem_by_period = {'1w': 20000, '2w': 10000, '1m': 8096, '2m': 8096, '3m': 7000}
partition_by_period = {'1w': 'large', '2w': 'medium', '1m': 'small', '2m': 'small', '3m': 'small'}
time_by_period = {'1w': '4:00:00', '2w': '2:00:00', '1m': '1:00:00', '2m': '0:30:00', '3m': '0:30:00'}
days_by_period = {'1w': 7, '2w': 14, '1m':30, '2m':60,'3m':90}

for crime in ['burglary','all','vehicle']: #'all','street','burglary','vehicle']: #all, street
    for period in ['3m','1m','1w']: #,'2w','2m'
        for bw1 in [600]: # rectangle??? 
            for bw2 in [600]: # rectangle??? 
                for eta in [.5,1.0]: #,1.5,2,
                    for ltfactor in [.5,1.0,2.0]: # half of period, period, period * 2
                        for kdebw in [250,500]: # 125, 750, 1000
                            for features in [250]: # 20
                                for kdelags in [1,3,6]: # 6 doesn't make sense if kdewinfactor = 1.0 and period = 3m
                                    for kdewinfactor in [.5,1.0]: # half of period, period
                                        fout = open("scripts/1-ar-ws-%s-%s-%d.slurm"%(period,crime,i),"w")
                                        pc = "%s-%s"%(period,crime)
                                        fout.write(header%(pc,partition_by_period[period],time_by_period[period],mem_by_period[period],pc))
                                        lt = ltfactor*days_by_period[period]
                                        kdewin = kdewinfactor*days_by_period[period]
                                        rscript1 = rscript%(bw1,bw2,eta,lt,features,kdebw,kdelags,kdewin,crime,period)
                                        fout.write(rscript1)
                                        allruns.write("%d,%d,%f,%f,%d,%d,%d,%d,%s,%s\n"%(bw1,bw2,eta,lt,features,kdebw,kdelags,kdewin,crime,period))
                                        j = j + 1
                                        fout.write(footer%(pc,pc))
                                        fout.close()
                                        scripts.append("sbatch scripts/1-ar-ws-%s-%s-%d.slurm"%(period,crime,i))
                                        i = i + 1

print i
import random

random.shuffle(scripts)
for s in scripts:
    system(s)
