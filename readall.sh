awk 'FNR-1{print $0","FILENAME}' scores/*
