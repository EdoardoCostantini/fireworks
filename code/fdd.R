# Project:   code
# Objective: Explore fdd procedure as in FIMD book
# Author:    Edoardo Costantini
# Created:   2021-12-09
# Modified:  2021-12-09

  library(mice)
  library(lattice)
  library(dplyr)
  library(ggplot2)

# Impute as in FIMD
  meth <- make.method(fdd)
  meth["yc1"] <- "~I(yca1 + ycb1 + ycc1)"
  meth["yc2"] <- "~I(yca2 + ycb2 + ycc2)"
  meth["yc3"] <- "~I(yca3 + ycb3 + ycc3)"
  meth["yp1"] <- "~I(ypa1 + ypb1 + ypc1)"
  meth["yp2"] <- "~I(ypa2 + ypb2 + ypc2)"
  meth["yp3"] <- "~I(ypa3 + ypb3 + ypc3)"
  out_fimd <- mice(fdd, pred = fdd.pred, meth = meth, maxit = 20,
                   seed = 54435,
                   print = TRUE)

# Evaluate imputations
  plot(out_fimd, c("prop1", "prop2", "prop3"))

# Reshape data according to book
  lowi <- mice::complete(out_fimd, "long", inc=TRUE)
  lowi <- data.frame(lowi, cbcl2 = NA, cbin2 = NA, cbex2 = NA)
  lolo <- reshape(lowi, idvar = 'id',
                  varying = 11:ncol(lowi),
                  direction = "long",
                  new.row.names = 1:(nrow(lowi)*3),
                  sep="")
  lolo <- lolo[order(lolo$.imp, lolo$id, lolo$time),]
  row.names(lolo) <- 1:nrow(lolo)

# Plot individual trends
  iv <- is.na(lolo[lolo$.imp==0,]$yp)
  ivn <- ifelse(iv,1,0)
  col12  <- c("grey80","grey80",
              mdc(2),mdc(1),
              mdc(2),"transparent",
              mdc(2),"transparent",
              mdc(2),"transparent",
              mdc(2),"transparent")

  ic <- unique(lolo$id[iv])
  ss <- lolo$id %in% ic

  grp <- 2*as.integer(lolo$.imp) - ivn
  loloss <- data.frame(lolo, grp=grp)
  trellis.par.set(strip.background=list(col="grey95"))
  trellis.par.set(list(layout.heights = list(strip = 1)))
  tp1 <- xyplot(yp~time|factor(id), data=loloss, type="l",
                layout = c(4,4),
        groups=factor(.imp), col="grey80", subset=ss,
         ylab="UCLA-RI Parent Score", pch=19, cex=1,
         xlab="Time", xlim=c("T1","T2","T3"),
               as.table=TRUE)
  print(tp1)

  tp2 <- xyplot(yp~time|factor(id), data=loloss, type="p",
                layout = c(4,4),
         groups=grp, col=col12, subset=ss,
         ylab="UCLA-RI Parent Score",
         pch=19,
         cex=0.8,
         xlab="Time", xlim=c("T1","T2","T3"),
         as.table=TRUE)
  print(tp2, newpage = FALSE)

# Parent
  means <- aggregate(lolo$yp, list(lolo$.imp != 0, lolo$trt, lolo$time),
                     mean, na.rm=TRUE)
  names(means) <- c(".imp","trt","time","yp")
  levels(means$trt) <- c("EMDR","CBT")
  tp <- xyplot(yp~time|trt, data=means, type="o", pch=19,
        groups=factor(.imp), col=c(mdc(4), mdc(6)),
         ylab="UCLA-RI Parent Score", lwd=2,
         xlab="Time", xlim=c("T1","T2","T3"))
  print(tp)

ggplot(data = means, aes(x = time, y = yp, color = .imp)) +
  geom_line() +
  geom_point() +
  facet_grid(rows = NULL, cols = vars(trt))



# Child
  means <- aggregate(lolo$yc,
                     list(lolo$.imp != 0, lolo$trt, lolo$time),
                     mean,
                     na.rm=TRUE)
  names(means) <- c(".imp", "trt", "time", "yc")
  levels(means$trt) <- c("EMDR", "CBT")

  tp <- xyplot(yc ~ time | trt, data = means, type = "o", pch = 19,
               groups = factor(.imp), col = c("red", "blue"),
               lwd = 2,
               ylab = "UCLA-RI Child Score",
               xlab = "Time", xlim = c("T1", "T2", "T3"))
  print(tp)

# Replicate tables in report
fdd_imp <- mice::complete(out_fimd, action = "long")
head(fdd_imp)

fdd %>%
  group_by(trt) %>%
  summarise_at(vars("prop1", "prop2", "prop3",
                    "crop1", "crop2", "crop3"), mean, na.rm = TRUE)

fdd_imp %>%
  group_by(trt) %>%
  summarise_at(vars("prop1", "prop2", "prop3",
                    "crop1", "crop2", "crop3"), mean)

fdd_imp %>%
  group_by(trt) %>%
  summarise_at(vars("prop1", "prop2", "prop3",
                    "crop1", "crop2", "crop3"), sd)