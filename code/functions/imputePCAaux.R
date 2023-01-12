# Project:   fireworks
# Objective: Imputation function for MI-PCA-AUX method
# Author:    Edoardo Costantini
# Created:   2021-12-20
# Modified:  2022-10-11

imputePCAaux <- function(Z, imp_target, ncfs = 1, maxit = 20){

  ## Input: 
  # @Z: dataset w/ missing values,
  # @target: integer vector indexing important variables to impute
  # @cond: single line dataframe describing current condition
  # @parms: the initialization object parms

  ## output: 
  # - a list of chains imputed datasets at iteration iters
  # - per variable list of imputed values
  # - imputation run time

  # For internals
  ## Data
  # Z = dat_miss
  # imp_target = c("yc1", "yc2", "yc3", "yp1", "yp2", "yp3")
  # pcs_target = c(parms$vmap$mp, parms$vmap$ax)
  # ncfs = 1

  ## body:
  start_time <- Sys.time()

  # index constants
  constants <- which(apply(Z,
                           2,
                           function (x){length(unique(x))}) == 1)

  # index analysis variables
  dvs <- which(colnames(Z) %in% imp_target)

  # Prepare object for prcomp
  # Single Imputation to allow PCA
  pMat     <- quickpred(Z)
  Z_SI_mids <- mice(Z,
                    m               = 1,
                    maxit           = 20, # 20
                    predictorMatrix = pMat,
                    printFlag       = FALSE,
                    method          = "pmm")
  Z_SI <- complete(Z_SI_mids)

  # Prepare object for prcomp
  Z_pca <- model.matrix( ~ ., Z_SI[, -c(dvs,
                                        constants)])[, -(1:2)]

  # Extract PCs
  pcs_keep <- 1:ncfs
  prcomp_out <- prcomp(Z_pca,
                       center = TRUE,
                       scale = TRUE)
  PVE <- prop.table(prcomp_out$sdev^2)
  CPVE <- sum(PVE[pcs_keep])

  ## Define input data for imputation
  Z_mice <- cbind(Z[, dvs], prcomp_out$x[, pcs_keep, drop = FALSE])

  ## Define predictor matrix
  pred_mat <- make.predictorMatrix(Z_mice)

  ## Impute
  imp_PCA_mids <- mice::mice(Z_mice,
                             m      = 5,
                             method = "pmm",
                             maxit  = maxit,
                             predictorMatrix = pred_mat,
                             printFlag = FALSE,
                             threshold = 1L,
                             maxcor = 1L,
                             eps = 0L)

  # Track time it took
  end_time <- Sys.time()
  imp_PCA_time <- difftime(end_time, start_time, units = "mins")

  return(list(mids = imp_PCA_mids,
              CPVE = CPVE,
              time = as.vector(imp_PCA_time)))

}
