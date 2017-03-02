library(data.table)
fl = as.list(list.files('scores', full.names = TRUE, pattern = "ar_ws_my.*csv"))
names(fl) = gsub('.*my_(.*)ran.*', '\\1', fl) # <- adjust to fit your file names
fl['scores/ar_ws_my_vehicle_3m.csv'] = NULL
x = rbindlist(lapply(fl, fread), idcol = 'ch')

params = c('delx', 'dely', 'alpha', 'eta', 'lt', 'theta', 'k',
           'l1', 'l2', 'kde.bw', 'kde.lags', 'kde.win')
# fwrite(x[delx>125 & dely>125 ,
#          if (min(pei) >= .02) .(pei = mean(pei)), by = c('ch', params)
#          ][ , .SD[which.max(pei)], by = ch],
#        '~/Desktop/best_random.csv')
best = x[delx*dely>250^2 & delx*dely<600^2 ,
  if (min(pei) >= .02) .(pei = mean(pei)), by = c('ch', params)
  ][ , .SD[which.max(pei)], by = ch]

best[order(ch)]

