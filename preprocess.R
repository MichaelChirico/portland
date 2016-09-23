# Forecasting Crime in Portland
# ** Data Pre-Processing **
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira

rm(list = ls(all = TRUE))
gc()

#Development version 1.9.7 -- try
#  install.packages("data.table", type = "source",
#                   repos = "http://Rdatatable.github.io")
library(data.table)
#Michael Chirico's package of convenience functions;
#  devtools::install_github("MichaelChirico/funchir")
library(funchir)
library(rvest)

# Official Contest Data

URL = "http://www.nij.gov/funding/Pages/" %+% 
  "fy16-crime-forecasting-challenge.aspx"

data_links = read_html(URL) %>% 
  #Get all <a href=...> tags, convert to text
  html_nodes(xpath = "//a/@href") %>% html_text() %>%
  #All data files end in .zip
  grep("\\.zip$", ., value = TRUE)

