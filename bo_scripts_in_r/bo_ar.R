#!/usr/bin/env Rscript
# Forecasting Crime in Portland
# **     GPP Featurization      **
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
# cat("Setup...\t")

library(rBayesianOptimization)

t0.timer = proc.time()["elapsed"]
library(data.table, warn.conflicts = FALSE, quietly = TRUE)

#inner parameters
args = commandArgs(trailingOnly = TRUE)
#args = c("1w","vehicle")
horizon = args[1]
crime.type = args[2]

#f = read.csv("~/best_score_old.csv",header=F,as.is=T)
#names(f) = c("period","crime","pei.grid","pei.bo","pei.kde","pai.grid","pai.bo","pai.kde")
#best_pai = max(f[f$period == horizon & f$crime == crime.type,c("pai.grid","pai.bo","pai.kde")])


run = function(delx, dely, alpha, eta, lt, k, theta, kde.bw, kde.lags, kde.win) {
    bo_id  = round(runif(1,0,1e8))
    if(delx * dely > 600*600) {
        return(list(Score=0))
    }
   #     cat(sprintf("Rscript evaluate_params.R %d %d %f %f %f 0 %d %f %d %s %s %d\n", round(delx), round(dely), alpha, eta, lt, round(k), kde.bw, round(kde.lags), crime.type, horizon, bo_id),file=sprintf("debug_%d",bo_id))
        system(sprintf("Rscript ar_evaluate_params.R %d %d %f %f %f %f %d %f %d %d %s %s %d\n", round(delx), round(dely), alpha, eta, lt, theta, round(k), kde.bw, round(kde.lags), round(kde.win), crime.type, horizon, bo_id))
        tryCatch({
            scores = fread(paste0("scores_ar/ar_", crime.type, "_", horizon, "_", bo_id, ".csv"))
	    return(list(Score=max(scores$pai)))
        }, error=function(e) { 
       cat(toString(e),file=sprintf("debug2_%d",bo_id))
        cat(sprintf("\nRscript ar_evaluate_params.R %d %d %f %f %f %f %d %f %d %d %s %s %d\n", round(delx), round(dely), alpha, eta, lt, theta, round(k), kde.bw, round(kde.lags), round(kde.win), crime.type, horizon, bo_id), file=sprintf("debug_%d",bo_id)) 
            return(list(Score=0)) } )
}

    BayesianOptimization(run, bounds=list(
            delx=c(250,300),
            dely=c(250,300),
            alpha=c(0,.05),
            eta=c(.5,1),
            lt=c(.5,2),
            k=c(50,200),
            theta=c(0,90),
            #delta=c(1,1),
            #t0=c(0,0),
            #pp=c(.5,.5),
            kde.bw=c(250,500),
            kde.lags=c(1,6), kde.win=c(3,30)), n_iter=1000,verbose=T,init_points=20) #, kernel = list(type="matern", nu=5/2))
