library(data.table)

crimei = 4
periodi = 5
df = NULL
f = fread("sh readall.sh") # awk 'FNR-1{print $0","FILENAME}' scores/*")
f1 = fread(list.files("scores", full.names = TRUE, pattern = "csv")[1],nrow=1)
setnames(f,c(names(f1),"fname"))
