# Forecasting Crime in Portland
# ** Automatic Data Download **
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira

rm(list = ls(all = TRUE))
gc()
#for web scraping
library(rvest) 

# Official Contest Data
URL = paste0("http://www.nij.gov/funding/Pages/",
             "fy16-crime-forecasting-challenge.aspx")

data_links = read_html(URL) %>% 
  #Get all <a href=...> tags, convert to text
  html_nodes(xpath = "//a/@href") %>% html_text() %>%
  #All data files end in .zip
  grep("Data.zip", ., fixed = TRUE, value = TRUE) %>% 
  #URLS are internal to the nij.gov site, so prepend
  paste0("www.nij.gov", .)

#Download data
for (uu in data_links) {
  tmp = tempfile()
  # method = "auto" -> method = "internal" was
  #  returning an error (?)
  download.file(uu, tmp, method = 'wget')
  unzip(tmp, exdir = "data")
  unlink(tmp)
}
