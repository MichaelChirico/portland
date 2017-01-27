library(data.table)
library(funchir)

scores = 
  fread("scores/all_1w.csv"
        )[alpha == 0 & eta %between% c(1.5, 3.5) & 
            lt %between% c(4, 6)]

timings = fread("timings/all_1w.csv")

dims = scores[ , CJ(delx = delx, dely = dely, 
                    unique = TRUE)][order(-dely, delx)]

# DELTA ####
scores_delta = 
  scores[k == 200 & l1 == 1e-5 & l2 == 1e-4 & lambda == .5 & 
           t0 == 0 & p == .5][ , .(pei = max(pei), pai = max(pai)),
                               by = .(delx, dely, eta, lt, delta)]

cols = c("black", "blue", "red", "darkgreen", "darkolivegreen",
         "orange", "yellow", "orchid", "violetred")
names(cols) = 
  scores_delta[ , do.call(paste, c(CJ(eta, lt, unique = TRUE),
                                   list(sep = "_")))]

scores_delta[ , {
  pdf("scores/vary_delta.pdf")
  par(mfrow = c(uniqueN(delx), uniqueN(dely)),
      mar = c(0, 0, 0, 0),
      oma = c(5.1, 4.1, 3.1, 2.1))
  MAX = max(pei)
  for (ii in 1:nrow(dims)) {
    x = dcast(.SD[dims[ii], on = c("delx", "dely")], 
              delta ~ eta + lt, value.var = "pei")
    y = x[ , !"delta"]
    matplot(x$delta, y, type = "l", lty = 1, col = cols[names(y)], lwd = 3,
            ylab = "", xlab = "", ylim = c(0, MAX), xaxt = "n", yaxt = "n")
    tile.axes(ii, 2L, 2L)
    if (ii == 3L)
      legend("bottomleft", do.call(paste, c(tstrsplit(names(y), "_"),
                                            list(sep = "/"))),
             col = cols[names(y)], lwd = 3, title = "eta/lt", ncol = 2L)
    if (ii < 3L) mtext(paste0("E-W Cell Size: ", dims[ii, delx]), 
                             side = 3L, cex = .5)
          if (ii %% 2L == 0L) mtext(paste0("N-S Cell Size: ", dims[ii, dely]),
                                    side = 4L, cex = .5)
  }
  mtext(side = 1L, "Delta",
        outer = TRUE, line = 2.5)
  mtext(side = 2L, "PEI",
        outer = TRUE, line = 2.5)
  title("PEI Sensitivity to Delta", outer = TRUE)
  dev.off()
  }]


timings[delx == 425 & dely == 600 & k == 200 & l1 == 1e-5 & 
          l2 == 1e-4 & lambda == .5 & t0 == 0 & p == .5
        ][ , .(time = mean(time)), keyby = delta
           ][ , {
             pdf("timings/vary_delta.pdf")
             plot(delta, time, type = "l", col = "red", lwd = 3L,
                  xlab = "delta", ylab = "Total Time", ylim = c(0, MAXT),
                  main = "Sensitivity of Run Time to Delta")
             dev.off()
           }]

# FEATURES ####
scores_k = 
  scores[delx %in% c(250, 425) & dely %in% c(425, 600) & 
           delta == 1 & l1 == 1e-5 & l2 == 1e-4 & lambda == .5 & 
           t0 == 0 & p == .5][ , .(pei = max(pei), pai = max(pai)),
                               by = .(delx, dely, eta, lt, k)]
dims_k = scores_k[ , CJ(delx = delx, dely = dely, 
                        unique = TRUE)][order(-dely, delx)]

scores_k[ , {
  pdf("scores/vary_features.pdf")
  par(mfrow = c(uniqueN(delx), uniqueN(dely)),
      mar = c(0, 0, 0, 0),
      oma = c(5.1, 4.1, 3.1, 2.1))
  MAX = max(pei)
  for (ii in 1:nrow(dims)) {
    x = dcast(.SD[dims_k[ii], on = c("delx", "dely")], 
              k ~ eta + lt, value.var = "pei")
    y = x[ , !"k"]
    matplot(x$k, y, type = "l", lty = 1, lwd = 3,
            ylab = "", xlab = "", ylim = c(0, MAX), xaxt = "n", yaxt = "n")
    tile.axes(ii, 2L, 2L)
    if (ii < 3L) mtext(paste0("E-W Cell Size: ", dims[ii, delx]), 
                             side = 3L, cex = .5)
          if (ii %% 2L == 0L) mtext(paste0("N-S Cell Size: ", dims[ii, dely]),
                                    side = 4L, cex = .5)
  }
  mtext(side = 1L, "# Features",
        outer = TRUE, line = 2.5)
  mtext(side = 2L, "PEI",
        outer = TRUE, line = 2.5)
  title("PEI Sensitivity to # Features", outer = TRUE)
  dev.off()
  }]

pdf("timings/vary_k.pdf")
boxplot(time ~ k, data = timings[delta == 1 & l1 == 1e-5 & l2 == 1e-4 & 
                                   lambda == .5 & t0 == 0 & p == .5],
        col = "red", xlab = "# Features", ylab = "Total Time", 
        main = "Sensitivity of Run Time to # Features")
dev.off()

# L1 ####
scores_l1 = 
  scores[delx %in% c(250, 425) & dely %in% c(425, 600) & 
           delta == 1 & k == 200 & l2 == 1e-4 & lambda == .5 & 
           t0 == 0 & p == .5][ , .(pei = max(pei), pai = max(pai)),
                               by = .(delx, dely, eta, lt, l1)]
dims_l1 = scores_l1[ , CJ(delx = delx, dely = dely, 
                        unique = TRUE)][order(-dely, delx)]

scores_l1[ , {
  pdf("scores/vary_l1.pdf")
  par(mfrow = c(uniqueN(delx), uniqueN(dely)),
      mar = c(0, 0, 0, 0),
      oma = c(5.1, 4.1, 3.1, 2.1))
  MAX = max(pei)
  for (ii in 1:nrow(dims)) {
    x = dcast(.SD[dims_l1[ii], on = c("delx", "dely")], 
              l1 ~ eta + lt, value.var = "pei")
    y = x[ , -1L]
    matplot(log10(x[[1L]]), y, type = "l", lty = 1, lwd = 3,
            ylab = "", xlab = "", ylim = c(0, MAX), xaxt = "n", yaxt = "n")
    tile.axes(ii, 2L, 2L)
    if (ii < 3L) mtext(paste0("E-W Cell Size: ", dims[ii, delx]), 
                             side = 3L, cex = .5)
          if (ii %% 2L == 0L) mtext(paste0("N-S Cell Size: ", dims[ii, dely]),
                                    side = 4L, cex = .5)
  }
  mtext(side = 1L, "log_10(L1)",
        outer = TRUE, line = 2.5)
  mtext(side = 2L, "PEI",
        outer = TRUE, line = 2.5)
  title("PEI Sensitivity to L1", outer = TRUE)
  dev.off()
  }]

pdf("timings/vary_l1.pdf")
boxplot(time ~ l1, data = timings[delta == 1 & k == 200 & l2 == 1e-4 & 
                                   lambda == .5 & t0 == 0 & p == .5],
        col = "red", xlab = "L1", ylab = "Total Time", 
        main = "Sensitivity of Run Time to L1")
dev.off()

# L2 ####
scores_l2 = 
  scores[delx %in% c(250, 425) & dely %in% c(250, 425) & 
           delta == 1 & l1 == 1e-5 & k == 200 & lambda == .5 & 
           t0 == 0 & p == .5][ , .(pei = max(pei), pai = max(pai)),
                               by = .(delx, dely, eta, lt, l2)]
dims_l2 = scores_l2[ , CJ(delx = delx, dely = dely, 
                        unique = TRUE)][order(-dely, delx)]

scores_l2[ , {
  pdf("scores/vary_l2.pdf")
  par(mfrow = c(uniqueN(delx), uniqueN(dely)),
      mar = c(0, 0, 0, 0),
      oma = c(5.1, 4.1, 3.1, 2.1))
  MAX = max(pei)
  for (ii in 1:nrow(dims)) {
    x = dcast(.SD[dims_l2[ii], on = c("delx", "dely")], 
              l2 ~ eta + lt, value.var = "pei")
    y = x[ , -1L]
    matplot(log10(x[[1L]]), y, type = "l", lty = 1, lwd = 3,
            ylab = "", xlab = "", ylim = c(0, MAX), xaxt = "n", yaxt = "n")
    tile.axes(ii, 2L, 2L)
    if (ii < 3L) mtext(paste0("E-W Cell Size: ", dims[ii, delx]), 
                             side = 3L, cex = .5)
          if (ii %% 2L == 0L) mtext(paste0("N-S Cell Size: ", dims[ii, dely]),
                                    side = 4L, cex = .5)
  }
  mtext(side = 1L, "log_10(L2)",
        outer = TRUE, line = 2.5)
  mtext(side = 2L, "PEI",
        outer = TRUE, line = 2.5)
  title("PEI Sensitivity to L2", outer = TRUE)
  dev.off()
  }]

pdf("timings/vary_l2.pdf")
boxplot(time ~ l2, data = timings[delta == 1 & l1 == 1e-5 & k == 200 & 
                                   lambda == .5 & t0 == 0 & p == .5],
        col = "red", xlab = "L2", ylab = "Total Time", 
        main = "Sensitivity of Run Time to L2")
dev.off()


# LAMBDA ####
scores_lambda = 
  scores[delx %in% c(250, 425) & dely %in% c(250, 425) & 
           delta == 1 & l1 == 1e-5 & l2 == 1e-4 & k == 200 & 
           t0 == 0 & p == .5][ , .(pei = max(pei), pai = max(pai)),
                               by = .(delx, dely, eta, lt, lambda)]
dims_lambda = scores_lambda[ , CJ(delx = delx, dely = dely, 
                        unique = TRUE)][order(-dely, delx)]

scores_lambda[ , {
  pdf("scores/vary_lambda.pdf")
  par(mfrow = c(uniqueN(delx), uniqueN(dely)),
      mar = c(0, 0, 0, 0),
      oma = c(5.1, 4.1, 3.1, 2.1))
  MAX = max(pei)
  for (ii in 1:nrow(dims)) {
    x = dcast(.SD[dims_lambda[ii], on = c("delx", "dely")], 
              lambda ~ eta + lt, value.var = "pei")
    y = x[ , -1L]
    matplot(x[[1L]], y, type = "l", lty = 1, lwd = 3,
            ylab = "", xlab = "", ylim = c(0, MAX), xaxt = "n", yaxt = "n")
    tile.axes(ii, 2L, 2L)
    if (ii < 3L) mtext(paste0("E-W Cell Size: ", dims[ii, delx]), 
                             side = 3L, cex = .5)
          if (ii %% 2L == 0L) mtext(paste0("N-S Cell Size: ", dims[ii, dely]),
                                    side = 4L, cex = .5)
  }
  mtext(side = 1L, "Lambda",
        outer = TRUE, line = 2.5)
  mtext(side = 2L, "PEI",
        outer = TRUE, line = 2.5)
  title("PEI Sensitivity to Lambda", outer = TRUE)
  dev.off()
  }]

pdf("timings/vary_lambda.pdf")
boxplot(time ~ lambda, data = timings[delta == 1 & l1 == 1e-5 & l2 == 1e-4 & 
                                   k == 200 & t0 == 0 & p == .5],
        col = "red", xlab = "Lambda", ylab = "Total Time", 
        main = "Sensitivity of Run Time to Lambda")
dev.off()


# P ####
scores_p = 
  scores[delx %in% c(250, 425) & dely %in% c(250, 425) & 
           delta == 1 & l1 == 1e-5 & l2 == 1e-4 & lambda == .5 & 
           t0 == 0 & k == 200][ , .(pei = max(pei), pai = max(pai)),
                               by = .(delx, dely, eta, lt, p)]
dims_p = scores_p[ , CJ(delx = delx, dely = dely, 
                        unique = TRUE)][order(-dely, delx)]
scores_p[ , {
  pdf("scores/vary_p.pdf")
  par(mfrow = c(uniqueN(delx), uniqueN(dely)),
      mar = c(0, 0, 0, 0),
      oma = c(5.1, 4.1, 3.1, 2.1))
  MAX = max(pei)
  for (ii in 1:nrow(dims)) {
    x = dcast(.SD[dims_p[ii], on = c("delx", "dely")], 
              p ~ eta + lt, value.var = "pei")
    y = x[ , -1L]
    matplot(x[[1L]], y, type = "l", lty = 1, lwd = 3,
            ylab = "", xlab = "", ylim = c(0, MAX), xaxt = "n", yaxt = "n")
    tile.axes(ii, 2L, 2L)
    if (ii < 3L) mtext(paste0("E-W Cell Size: ", dims[ii, delx]), 
                             side = 3L, cex = .5)
          if (ii %% 2L == 0L) mtext(paste0("N-S Cell Size: ", dims[ii, dely]),
                                    side = 4L, cex = .5)
  }
  mtext(side = 1L, "p",
        outer = TRUE, line = 2.5)
  mtext(side = 2L, "PEI",
        outer = TRUE, line = 2.5)
  title("PEI Sensitivity to p", outer = TRUE)
  dev.off()
  }]

pdf("timings/vary_p.pdf")
boxplot(time ~ p, data = timings[delta == 1 & l1 == 1e-5 & l2 == 1e-4 & 
                                   lambda == .5 & t0 == 0 & k == 200 & p > .01],
        col = "red", xlab = "p", ylab = "Total Time", 
        main = "Sensitivity of Run Time to p")
dev.off()


# T0 ####
scores_t0 = 
  scores[delta == 1 & k == 200 & l1 == 1e-5 & l2 == 1e-4 & lambda == .5 & 
           p == .5][ , .(pei = max(pei), pai = max(pai)),
                     by = .(delx, dely, eta, lt, t0)]

scores_t0[ , {
  pdf("scores/vary_t0.pdf")
  par(mfrow = c(uniqueN(delx), uniqueN(dely)),
      mar = c(0, 0, 0, 0),
      oma = c(5.1, 4.1, 3.1, 2.1))
  MAX = max(pei)
  for (ii in 1:nrow(dims)) {
    x = dcast(.SD[dims[ii], on = c("delx", "dely")], 
              t0 ~ eta + lt, value.var = "pei")
    y = x[ , -1L]
    matplot(x[[1L]], y, type = "l", lty = 1, col = cols[names(y)], lwd = 3,
            ylab = "", xlab = "", ylim = c(0, MAX), xaxt = "n", yaxt = "n")
    tile.axes(ii, 2L, 2L)
    if (ii == 3L)
      legend("bottomleft", do.call(paste, c(tstrsplit(names(y), "_"),
                                            list(sep = "/"))),
             col = cols[names(y)], lwd = 3, title = "eta/lt", ncol = 2L)
    if (ii < 3L) mtext(paste0("E-W Cell Size: ", dims[ii, delx]), 
                             side = 3L, cex = .5)
          if (ii %% 2L == 0L) mtext(paste0("N-S Cell Size: ", dims[ii, dely]),
                                    side = 4L, cex = .5)
  }
  mtext(side = 1L, "t0",
        outer = TRUE, line = 2.5)
  mtext(side = 2L, "PEI",
        outer = TRUE, line = 2.5)
  title("PEI Sensitivity to t0", outer = TRUE)
  dev.off()
  }]

timings[delx == 425 & dely == 425 & delta == 1 & l1 == 1e-5 & 
          l2 == 1e-4 & lambda == .5 & k == 200 & p == .5
        ][ , .(time = mean(time)), keyby = t0
           ][ , {
             pdf("timings/vary_t0.pdf")
             plot(t0, time, type = "l", col = "red", lwd = 3L,
                  xlab = "# Features", ylab = "Total Time", ylim = c(0, MAXT),
                  main = "Sensitivity of Run Time to t0")
             dev.off()
           }]
