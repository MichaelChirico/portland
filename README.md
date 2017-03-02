Forecasting Crime in Portland

* [Contest Guidelines](http://www.nij.gov/funding/Pages/fy16-crime-forecasting-challenge.aspx)

# Creating our analysis data sets

* Required packages: `rvest`, `data.table`, `foreign`, `zoo`, `sp`, `rgeos`, `maptools`, `rgdal`

 1. Run `data_download.R` to scrape the NIJ website for links to all .zip files and download them into `./data`.
 
 2. Run `crimes_to_csv.R` to convert these shapefiles' .dbf databases into our analysis .csv files: `crimes_all.csv`, `crimes_bur.csv`, `crimes_str.csv` and `crimes_veh.csv`.
 
 3. Make sure you have the provided `Portland_Police_Districts.shp` shapefile of police districts in Portland in `./data`, then run `extract_portland_boundary_to_csv.R` to create a text file containing all x-y coordinates of the (500-ft-buffered) vertices of the outer boundary of Portland into `./data/portland_coords.csv`.
