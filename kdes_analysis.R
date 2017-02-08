# Explore baseline KDEs

library(data.table)

kdes = fread('kde_baselines/kde_baselines.csv')
kdes[, .(mpai = mean(pai), sdpai = sd(pai), mpei = mean(pei), sdpei=sd(pei)), by=crime.type]

kdes[crime.type=='street' & horizon=='3m'][order(-pai)]
kdes[crime.type=='street' & horizon=='3m'][order(-pei)]
