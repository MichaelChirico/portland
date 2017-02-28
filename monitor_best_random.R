library(data.table)
fl = list.files('scores', full.names = TRUE)
names(fl) = gsub('.*my_(.*)ran.*', '\\1', fl)
x = rbindlist(lapply(fl, fread), idcol = 'ch')

params = c('delx', 'dely', 'alpha', 'eta', 'lt', 'theta', 'k',
           'l1', 'l2', 'kde.bw', 'kde.lags', 'kde.win')
fwrite(x[delx>125 & dely>125 ,
         if (min(pei) >= .02) .(pei = mean(pei)), by = c('ch', params)
         ][ , .SD[which.max(pei)], by = ch],
       '~/Desktop/best_random.csv')