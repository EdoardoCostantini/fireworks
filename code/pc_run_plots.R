# Project:   fireworks
# Objective: Script to generate plots for this run
# Author:    Edoardo Costantini
# Created:   2021-12-19
# Modified:  2021-12-19

# Read results
out <- readRDS("../output/20211219_161913_res.rds")
out <- readRDS("../output/20211219_163323_res.rds")

ggplot(data = out,
       aes(x = time, y = yp, group = rep, color = imp)) +
  facet_grid(rows = vars(trt), cols = vars(imp)) +
  geom_line() +
  coord_cartesian(ylim = c(15, 40)) +
  theme(legend.position = "bottom")

ggplot(data = out,
       aes(x = time, y = yc, group = rep, color = imp)) +
  facet_grid(rows = vars(trt), cols = vars(imp)) +
  geom_line() +
  coord_cartesian(ylim = c(15, 40)) +
  theme(legend.position = "bottom")
