library(data.table)
library(funchir)

ff = list.files("scores", full.names = TRUE)
ff = setNames(ff, gsub("\\..*", "", basename(ff)))
scores = rbindlist(lapply(ff, fread), idcol = "crho")
scores[ , c("crime", "horizon") := tstrsplit(crho, "_")]
scores[ , crho := NULL]
setorder(scores, crime, horizon, delx, dely, eta, lt)

fwrite(scores[ , .SD[c(which.max(pei), 
                       which.max(pai))], 
               by = .(crime, horizon)],
       "current_best.csv")

cols = colorRampPalette(c("blue", "darkgreen"))(10L)
dimcombs = unique(scores[ , .(delx, dely)])[order(-dely, delx)]
etas = unique(scores$eta)
lts = unique(scores$lt)

axparams = list(x = list(at = lts),
                y = list(at = etas))

scores[ , {
  pdf(paste0("scores/pai_", .BY[[1L]], .BY[[2L]], ".pdf"))
  par(mfrow = c(uniqueN(delx), uniqueN(dely)),
      mar = c(0, 0, 0, 0),
      oma = c(5.1, 4.1, 3.1, 2.1))
  for (ii in 1L:nrow(dimcombs)) {
    .SD[dimcombs[ii], on = c("delx", "dely"),
        {
          z = matrix(pai, nrow = 8L, ncol = 8L)
          image(lts, etas, z, xaxt = "n", yaxt = "n", col = cols)
          if (ii < 4L) mtext(paste0("E-W Cell Size: ", delx[1L]), 
                             side = 3L, cex = .5)
          if (ii %% 3L == 0L) mtext(paste0("N-S Cell Size: ", dely[1L]),
                                    side = 4L, cex = .5)
          tile.axes(ii, 3L, 3L, params = axparams)
          idx = which(max(pai) - pai <= .1*max(pai))
          text(lt[idx], eta[idx], round(pai[idx]), cex = .8)
        }]
  }
  mtext(side = 1L, "Time Lengthscale (Weeks)",
        outer = TRUE, line = 2.5)
  mtext(side = 2L, "Space Lengthscale (Factor of Dimension)",
        outer = TRUE, line = 2.5)
  title(paste0("PAI Sensitivity: ", .BY[[1L]], "/", .BY[[2L]]),
        outer = TRUE)
  dev.off()
}, by = .(crime, horizon)]
