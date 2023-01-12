# Project:   fireworks
# Objective: Compare convergence plots
# Author:    Edoardo Costantini
# Created:   2022-10-10
# Modified:  2022-10-10

# Set up ----------------------------------------------------------------------

  # Make sure we have a clean environment:
  rm(list = ls())

  # Initialize the environment:
  source("./init.R")

  # Define working directory
  outdir <- "../output/"

# Convergence for expert imputation -------------------------------------------

  # Impute with expert start
  expert_mids <- mice(fdd,
                      predictorMatrix = fdd.pred,
                      meth = parms$meth,
                      maxit = 1e2,
                      print = TRUE)

  # Save mids
  saveRDS(expert_mids, paste0(outdir, "convergence-expert.rds"))

# Convergence for the pcr.aux and the pcr.all single imputation run -----------

  # Define a quick pred for fdd
  pMat     <- quickpred(fdd)

  # Impute with default behaviour and desired quickpred
  si_4auxall <- mice(fdd,
                     m               = 5,
                     maxit           = 1e2, # 20
                     predictorMatrix = pMat,
                     printFlag       = TRUE,
                     method          = "pmm")

  # Save mids
  saveRDS(si_4auxall, paste0(outdir, "convergence-si-4-aux-all.rds"))

# Convergence for pcr.aux -----------------------------------------------------

  # Impute with pcr.aux (internal maxit for single imp = 20)
  pcraux_mids <- imputePCAaux(Z = fdd,
                              imp_target = c("yc1", "yc2", "yc3",
                                             "yp1", "yp2", "yp3",
                                             "trt"),
                              ncfs = 19L,
                              maxit = 1e2)

  # Save mids
  saveRDS(pcraux_mids, paste0(outdir, "convergence-pcraux.rds"))

# Impute with pmm PCR ---------------------------------------------------------

  # Impute with variable by variable
  vbv_mids <- mice(fdd,
                   meth = "pcr.pmm",
                   maxit = 1e2,
                   npc = 24L,
                   threshold = 1L,
                   maxcor = 1L,
                   eps = 0L,
                   seed = 20221010,
                   remove.collinear = FALSE,
                   print = TRUE)

  # Save mids
   saveRDS(vbv_mids, paste0(outdir, "convergence-vbv.rds"))

# Convergence for default choice ----------------------------------------------

  # Impute with default behaviour
  default_mids <- mice(fdd,
                       maxit = 1e2,
                       print = FALSE)

  # Save mids
  saveRDS(default_mids, paste0(outdir, "convergence-default.rds"))

# Compare traceplots ----------------------------------------------------------

  # Read the data
  expert_mids <- readRDS(paste0(outdir, "convergence-expert.rds"))
  si_4auxall <- readRDS(paste0(outdir, "convergence-si-4-aux-all.rds"))
  pcraux_mids <- readRDS(paste0(outdir, "convergence-pcraux.rds"))
  vbv_mids <- readRDS(paste0(outdir, "convergence-vbv.rds"))
  default_mids <- readRDS(paste0(outdir, "convergence-default.rds"))

  # YP
  YP <- c("yp1", "yp2", "yp3")
  plot(expert_mids, YP)
  plot(si_4auxall, YP)
  plot(pcraux_mids$mids, YP)
  plot(vbv_mids, YP)
  plot(default_mids, YP)

  # YC
  YC <- c("yc1", "yc2", "yc3")
  plot(expert_mids, YC)
  plot(si_4auxall, YC)
  plot(pcraux_mids$mids, YC)
  plot(vbv_mids, YC)
  plot(default_mids, YC)
