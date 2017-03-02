library(data.table)
library(readxl)
library(ggmap)

x = read_excel('data/February 28th calls manual.xlsx',
               col_names = FALSE) %>% setDT

setnames(x, c('call_type', 'address', 'state', 'x', 'time'))
x[ , x := NULL]
x[ , state := state[1L]]
x[ , address := gsub(' / ', ' & ', address, fixed = TRUE)]
x[ , c('lon', 'lat') := geocode(paste(address, state))]
#Quick manual inspection -- these failed or were throttled
x[address == "WB I84 FWY At/ NE 82nd Ave",
  c('lat', 'lon') := .(45.525251, -122.663676)]
x[address == "NB I205 BRG at /Midspan",
  c('lat', 'lon') := .(45.582848, -122.543909)]
x[address == "3700 Block of SE 149th Ave",
  c('lat', 'lon') := .(45.4957205,-122.5118981)]
x[address == "100 Block of NE 102nd Ave",
  c('lat', 'lon') := .(45.523430, -122.558283)]

fwrite(x, 'rss_data/charles_geocode.csv')
