# Project:   fireworks
# Objective: Install packages required for running simulation
# Author:    Edoardo Costantini
# Created:   2022-04-26
# Modified:  2022-04-26
# Notes:     Assuming working directory ./code/

# Load init script to lists the names of the packages required
source("init.R")

# 1. Install all packages you can
install.packages(cran_list)

# 2. Install Local mice.sim.pcr
install.packages("../input/mice.pcr.sim_3.13.9.tar.gz",
                 repos = NULL, 
                 type = "source")
