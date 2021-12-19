# Project:   fireworks
# Objective: Compare results
# Author:    Edoardo Costantini
# Created:   2021-12-10
# Modified:  2021-12-10

library(mice)
library(dplyr)
library(reshape2)
library(ggplot2)
lapply(paste0("./functions/", list.files("./functions/")), source)

# Load data

# define pred.mat for pmm FIMD
  meth <- make.method(fdd)
  meth["yc1"] <- "~I(yca1 + ycb1 + ycc1)"
  meth["yc2"] <- "~I(yca2 + ycb2 + ycc2)"
  meth["yc3"] <- "~I(yca3 + ycb3 + ycc3)"
  meth["yp1"] <- "~I(ypa1 + ypb1 + ypc1)"
  meth["yp2"] <- "~I(ypa2 + ypb2 + ypc2)"
  meth["yp3"] <- "~I(ypa3 + ypb3 + ypc3)"

reps <- 10

store_fimd <- list()
store_all <- list()
store_vbv <- list()

set.seed(123)

seeds <- sample(100:2000, reps)

for (i in 1:reps){
  # Impute with pmm FIMD
  out_fimd <- mice(fdd, pred = fdd.pred,
                   seed = seeds[i],
                   meth = meth, maxit = 20, print = FALSE)
  store_fimd[[i]] <- cbind(meth = "PMM",
                           rep = i, impProcess(mids_object = out_fimd,
                                               include_0 = FALSE,
                                               dv = "yp"))
  rm(out_fimd)

  # Impute with PCR-ALL
  names(which(colSums(is.na(fdd)) != 0))
  out_PCAall <- imputePCAall(Z = fdd,
                             imp_target = names(which(colSums(is.na(fdd)) != 0)),
                             pcs_target = names(fdd),
                             seed = seeds[i],
                             m = 5,
                             ncfs = 24,
                             dv = "yp"
  )
  store_all[[i]] <- cbind(meth = "ALL", rep = i, out_PCAall$means)
  rm(out_PCAall)

  # Impute with PCR-VBV
  out_vbv <- mice(fdd, meth = "pcr.pmm",
                  seed = seeds[i],
                  maxit = 20, print = FALSE)
  store_vbv[[i]] <- cbind(meth = "VBV",
                          rep = i,
                          impProcess(out_vbv, include_0 = FALSE, dv = "yp"))
  rm(out_vbv)
}

set1 <- do.call(rbind, store_fimd)
set2 <- do.call(rbind, store_all)
set3 <- do.call(rbind, store_vbv)
set <- rbind(set1, set2, set3)

saveRDS(set, "../output/fireworks_imputation.rds")

set$rep <- factor(set$rep)

ggplot(data = set2, aes(x = time, y = yp, group = rep, color = meth)) +
  facet_grid(rows = NULL, cols = vars(trt)) +
  # geom_point() +
  geom_line() +
  coord_cartesian(ylim = c(15, 40)) +
  theme(legend.position = "bottom")

head(set3)

df2 <- data.frame(supp=rep(c("VC", "OJ"), each=3),
                dose=rep(c("D0.5", "D1", "D2"),2),
                len=c(6.8, 15, 33, 4.2, 10, 29.5))
head(df2)

ggplot(data=df2, aes(x = dose, y = len, group=supp)) +
  geom_line()+
  geom_point()