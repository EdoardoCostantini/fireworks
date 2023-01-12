# Project:   fireworks
# Objective: Prep environment script (install packs and the likes)
# Author:    Edoardo Costantini
# Created:   2022-04-26
# Modified:  2022-10-10

# Install packages from the init script

  install.packages(cran_list)

# Install costum mice packages

  install.packages("../input/mice.pcr.sim_3.13.9.tar.gz",
                   repos = NULL,
                   type = "source")

  install.packages("../input/mice_3.13.18.tar.gz",
                   repos = NULL,
                   type = "source")
