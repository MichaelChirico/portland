from os import system

for period in ['1w','2w','1m','2m','3m']: #'1w'
    for crime in ['street','burglary','vehicle','all']:
        system("Rscript bo_ar.R %s %s &"%(period,crime))
