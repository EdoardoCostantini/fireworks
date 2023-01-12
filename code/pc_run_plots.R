# Project:   fireworks
# Objective: Script to generate plots for this run
# Author:    Edoardo Costantini
# Created:   2021-12-19
# Modified:  2022-10-11

# Read results
out <- readRDS("../output/20211220_144954_res.rds") # vbv 20 iters
out <- readRDS("../output/20221011_093857_res.rds") # vbv 40 iters

out$imp <- factor(out$imp, levels = c("expert",
                                      "pcr.aux",
                                      "pcr.all",
                                      "pcr.vbv",
                                      "default"))
unique(out$imp)
out$time <- factor(out$time)

ggplot(data = out,
       aes(x = time, y = yp, group = rep)) +
  facet_grid(rows = vars(trt), cols = vars(imp)) +
  geom_line() +
  theme(legend.position = "bottom")

ggplot(data = out,
       aes(x = time, y = yc, group = rep)) +
  facet_grid(rows = vars(trt), cols = vars(imp)) +
  geom_line() +
  theme(legend.position = "bottom")
