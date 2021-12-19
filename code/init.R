# Project:   fireworks
# Objective: Initialize environment for project
# Author:    Edoardo Costantini
# Created:   2021-12-19
# Modified:  2021-12-19

# Packages ----------------------------------------------------------------

  cran_list <- c("parallel",    # simulation paralleliazion
                 "rlecuyer",    # simulation paralleliazion
                 "ggplot2",     # results analysis
                 "grDevices",   # for plotting gray.colors function
                 "dplyr",       # results analysis
                 "stringr",     # for grapling results
                 "reshape2",    # for manipulating results
                 "devtools",    # for detailed session info
                 "mice"         # imputation
                 )
  local_list <- c("mice.pcr.sim")

  # Put together
  pack_list <- c(cran_list, local_list)

  # Load packages
  lapply(pack_list, library, character.only = TRUE, verbose = FALSE)

# Load Functions ----------------------------------------------------------

  # Subroutines
  all_subs <- paste0("./subroutines/",
                     list.files("./subroutines/"))
  lapply(all_subs, source)

  # Functions
  all_funs <- paste0("./functions/",
                     list.files("./functions/"))
  lapply(all_funs, source)

# Parms -------------------------------------------------------------------

  # Empty List
  parms          <- list()
  parms$seed     <- 20210929
  parms$nStreams <- 1000
  parms$outDir   <- "../output/"

  # define pred.mat for pmm FIMD
  meth <- make.method(fdd)
  meth["yc1"] <- "~I(yca1 + ycb1 + ycc1)"
  meth["yc2"] <- "~I(yca2 + ycb2 + ycc2)"
  meth["yc3"] <- "~I(yca3 + ycb3 + ycc3)"
  meth["yp1"] <- "~I(ypa1 + ypb1 + ypc1)"
  meth["yp2"] <- "~I(ypa2 + ypb2 + ypc2)"
  meth["yp3"] <- "~I(ypa3 + ypb3 + ypc3)"
  parms$meth <- meth

# Conds -------------------------------------------------------------------

  factor1 <- c("")
  factor2 <- c("")
  conds <- expand.grid(factor1, factor2)