# Overview of Directory

 - `ar_ws_evaluate_params.R` - main script for taking hyperparameters, featurizing them, and running Vowpal Wabbit
 - `competition_output.R` - main script for turning optimal hyperparameters into a contest submission
 - `crimes_{all,bur,str,veh}.csv` - analysis historical data files
 - `rss_data`, `feb28_calls_geocode.R`, `data/February 28th calls manual.xlsx`, `data/rss_feed_Feb28.csv` - supplementary data & scraping from February 28 (final contest day when no official crimes were given to contestants)
 - `data/Portland_Police_Districts.{dbf,sbn,sbx,shp,shp.xml,shx}` - officially supplied shapefile for Portland
 - `extract_portland_boundary_to_csv.R`, `data/portland_coords.csv` - script for converting Portland districts shapefile to a boundary polygon for Portland (with a small buffer), and the output of this script
 - `utils.R` - some helper functions for other scripts
 - `optimization_scripts` - some scripts used for hyperparameter optimization

 This reproduction archive is kept on the `submission_repro_archive` branch of the official GitHub-hosted repository:

 https://github.com/MichaelChirico/portland/blob/submission_repro_archive/README.md
