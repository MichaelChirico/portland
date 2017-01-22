library(data.table)
library(funchir)

scores = 
  fread("scores/all_1w.csv"
        )[delx %in% c(250, 425) & dely %in% c(425, 600) & 
            alpha == 0 & eta %in% 4:6 & lt %in% (1:3 + .5)]

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

# FEATURES ####
scores_k = 
  scores[delta == 1 & l1 == 1e-5 & l2 == 1e-4 & lambda == .5 & 
           t0 == 0 & p == .5][ , .(pei = max(pei), pai = max(pai)),
                               by = .(delx, dely, eta, lt, k)]

scores_k[ , {
  pdf("scores/vary_features.pdf")
  par(mfrow = c(uniqueN(delx), uniqueN(dely)),
      mar = c(0, 0, 0, 0),
      oma = c(5.1, 4.1, 3.1, 2.1))
  MAX = max(pei)
  for (ii in 1:nrow(dims)) {
    x = dcast(.SD[dims[ii], on = c("delx", "dely")], 
              k ~ eta + lt, value.var = "pei")
    y = x[ , !"k"]
    matplot(x$k, y, type = "l", lty = 1, col = cols[names(y)], lwd = 3,
            ylab = "", xlab = "", ylim = c(0, MAX), xaxt = "n", yaxt = "n")
    tile.axes(ii, 2L, 2L)
    if (ii == 3L)
      legend("bottomright", do.call(paste, c(tstrsplit(names(y), "_"),
                                            list(sep = "/"))),
             col = cols[names(y)], lwd = 3, title = "eta/lt", ncol = 2L)
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

# L1 ####
scores_l1 = 
  scores[delta == 1 & k == 200 & l2 == 1e-4 & lambda == .5 & 
           t0 == 0 & p == .5][ , .(pei = max(pei), pai = max(pai)),
                               by = .(delx, dely, eta, lt, l1)]

scores_l1[ , {
  pdf("scores/vary_l1.pdf")
  par(mfrow = c(uniqueN(delx), uniqueN(dely)),
      mar = c(0, 0, 0, 0),
      oma = c(5.1, 4.1, 3.1, 2.1))
  MAX = max(pei)
  for (ii in 1:nrow(dims)) {
    x = dcast(.SD[dims[ii], on = c("delx", "dely")], 
              l1 ~ eta + lt, value.var = "pei")
    y = x[ , -1L]
    matplot(log10(x[[1L]]), y, type = "l", lty = 1, col = cols[names(y)], lwd = 3,
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
  mtext(side = 1L, "log_10(L1)",
        outer = TRUE, line = 2.5)
  mtext(side = 2L, "PEI",
        outer = TRUE, line = 2.5)
  title("PEI Sensitivity to L1", outer = TRUE)
  dev.off()
  }]

# L2 ####
scores_l2 = 
  scores[delta == 1 & k == 200 & l1 == 1e-5 & lambda == .5 & 
           t0 == 0 & p == .5][ , .(pei = max(pei), pai = max(pai)),
                               by = .(delx, dely, eta, lt, l2)]

scores_l2[ , {
  pdf("scores/vary_l2.pdf")
  par(mfrow = c(uniqueN(delx), uniqueN(dely)),
      mar = c(0, 0, 0, 0),
      oma = c(5.1, 4.1, 3.1, 2.1))
  MAX = max(pei)
  for (ii in 1:nrow(dims)) {
    x = dcast(.SD[dims[ii], on = c("delx", "dely")], 
              l2 ~ eta + lt, value.var = "pei")
    y = x[ , -1L]
    matplot(log10(x[[1L]]), y, type = "l", lty = 1, col = cols[names(y)], lwd = 3,
            ylab = "", xlab = "", ylim = c(0, MAX), xaxt = "n", yaxt = "n")
    tile.axes(ii, 2L, 2L)
    if (ii == 3L)
      legend("topright", do.call(paste, c(tstrsplit(names(y), "_"),
                                            list(sep = "/"))),
             col = cols[names(y)], lwd = 3, title = "eta/lt", ncol = 2L)
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

# LAMBDA ####
scores_lambda = 
  scores[delta == 1 & k == 200 & l1 == 1e-5 & l2 == 1e-4 & 
           t0 == 0 & p == .5][ , .(pei = max(pei), pai = max(pai)),
                               by = .(delx, dely, eta, lt, lambda)]

scores_lambda[ , {
  pdf("scores/vary_lambda.pdf")
  par(mfrow = c(uniqueN(delx), uniqueN(dely)),
      mar = c(0, 0, 0, 0),
      oma = c(5.1, 4.1, 3.1, 2.1))
  MAX = max(pei)
  for (ii in 1:nrow(dims)) {
    x = dcast(.SD[dims[ii], on = c("delx", "dely")], 
              lambda ~ eta + lt, value.var = "pei")
    y = x[ , -1L]
    matplot(x[[1L]], y, type = "l", lty = 1, col = cols[names(y)], lwd = 3,
            ylab = "", xlab = "", ylim = c(0, MAX), xaxt = "n", yaxt = "n")
    tile.axes(ii, 2L, 2L)
    if (ii == 3L)
      legend("topright", do.call(paste, c(tstrsplit(names(y), "_"),
                                            list(sep = "/"))),
             col = cols[names(y)], lwd = 3, title = "eta/lt", ncol = 2L)
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


# P ####
scores_p = 
  scores[delta == 1 & k == 200 & l1 == 1e-5 & l2 == 1e-4 & lambda == .5 & 
           t0 == 0][ , .(pei = max(pei), pai = max(pai)),
                     by = .(delx, dely, eta, lt, p)]

scores_p[ , {
  pdf("scores/vary_p.pdf")
  par(mfrow = c(uniqueN(delx), uniqueN(dely)),
      mar = c(0, 0, 0, 0),
      oma = c(5.1, 4.1, 3.1, 2.1))
  MAX = max(pei)
  for (ii in 1:nrow(dims)) {
    x = dcast(.SD[dims[ii], on = c("delx", "dely")], 
              p ~ eta + lt, value.var = "pei")
    y = x[ , -1L]
    matplot(x[[1L]], y, type = "l", lty = 1, col = cols[names(y)], lwd = 3,
            ylab = "", xlab = "", ylim = c(0, MAX), xaxt = "n", yaxt = "n")
    tile.axes(ii, 2L, 2L)
    if (ii == 3L)
      legend("topright", do.call(paste, c(tstrsplit(names(y), "_"),
                                            list(sep = "/"))),
             col = cols[names(y)], lwd = 3, title = "eta/lt", ncol = 2L)
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


