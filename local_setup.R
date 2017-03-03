#for facilitating running scripts on
#  contributors' respective environments/clusters

hostname = Sys.info()["nodename"]
cat("running on ", hostname, "\n")

if(grepl("ziz",hostname)) { # Seth's setup
    source("cleanup.R")
    tdir = "/data/localhost/not-backed-up/flaxman"
    job_id = paste0("_",Sys.getenv("SLURM_JOB_ID"))
    path_to_vw = "./vw"
} else if (grepl('michael', hostname)) {
    tdir = "/tmp"
    job_id = ""
    path_to_vw = "vw"
} else if (grepl('gpc', hostname)) {
  tdir = "/data/shared/loefflerlab/portland_temp"
  job_id = ""
  path_to_vw = "vw"
} else {
  tdir = "delete_me"
  job_id = if (length(jid <- Sys.getenv("REQNAME"))) 
    gsub(".*/|\\..*", "", jid) else ""
  path_to_vw = "vw" 
}
