library(data.table)
library(spatstat)

crimes = fread("crimes.csv")

#record range here, so that
#  we have the same range 
#  after we subset below
xrng = crimes[ , range(x_coordina)]
yrng = crimes[ , range(y_coordina)]

crimes_ever = 
  with(crimes, setDT(as.data.frame(pixellate(ppp(
    #pixellate counts dots over each cell,
    #  and appears to do so pretty quickly
    x = x_coordina, y = y_coordina,
    xrange =  xrng, yrange = yrng),
    #we can easily make these command line arguments
    dimyx = c(y = 600, x = 600)))))
#record order for more reliable merging below
crimes_ever[order(x, y), I := .I]
#eliminate no-crime cells
crimes_ever = crimes_ever[value > 0]

#now subset to desired date range
crimes = crimes[as.IDate(occ_date) %between%
                  c("2016-02-22", "2016-02-28")]

#repeat over-cell counting
crimes.grid.dt = 
  with(crimes, setDT(as.data.frame(pixellate(ppp(
    x = x_coordina, y = y_coordina,
    xrange = xrng, yrange = yrng),
    dimyx = c(y = 600, x = 600)))))
crimes.grid.dt[order(x, y), I := .I]

#subset to eliminate never-crime cells
crimes.grid.dt = 
  crimes.grid.dt[crimes_ever, .(x, y, value), on = "I"]

#lengthscale and feature count
l = 1800; k = 200

#project -- these are the omega * xs
proj = crimes.grid.dt[ , cbind(x, y)] %*% 
  matrix(rnorm(2*k), nrow = 2L) / l

#create the features
phi = cbind(cos(proj), sin(proj))/sqrt(k)

#convert to data.table for ease
phi.dt = as.data.table(phi)

fwrite(phi.dt[ , c(list(paste0(
  crimes.grid.dt$value, " |")), lapply(
    names(.SD), function(jj)
      paste0(jj, ":", get(jj))))], 
  "test.vw", sep = " ", col.names = FALSE, quote = FALSE)
