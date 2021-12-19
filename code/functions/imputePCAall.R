# Project:   fireworks
# Objective: Imputation function for the all method
# Author:    Edoardo Costantini
# Created:   2021-12-19
# Modified:  2021-12-19

imputePCAall <- function(Z, ncfs = 1){

  ## Input: 
  # @Z: dataset w/ missing values,
  # @target: integer vector indexing important variables to impute
  # @cond: single line dataframe describing current condition
  # @parms: the initialization object parms
  # @Z_ori: the original dataset

  ## output: 
  # - a list of chains imputed datasets at iteration iters
  # - per variable list of imputed values
  # - imputation run time

  # For internals
  ## Data
  # Z = fdd
  # ncfs = 1

  ## body:
  start_time <- Sys.time()

  # index original variables
  x_original <- 1:ncol(Z)

  # index constants
  constants <- which(apply(Z,
                           2,
                           function (x){length(unique(x))}) == 1)

  # Single Imputation to allow PCA
  pMat     <- quickpred(Z, mincor = .3)
  Z_SI_mids <- mice(Z,
                    m               = 1,
                    maxit           = 20, # 20
                    predictorMatrix = pMat,
                    printFlag       = FALSE,
                    method          = "pmm")
  Z_SI <- complete(Z_SI_mids)

  # Prepare object for prcomp
  Z_pca <- model.matrix( ~ ., Z_SI[, -constants])[, -(1:2)]

  # Extract PCs
  prcomp_out <- prcomp(Z_pca,
                       center = TRUE,
                       scale = TRUE)
  PVE <- prop.table(prcomp_out$sdev^2)

  # Define which pcs to keep (flexible to proportion of v explained)
  pcs_keep <- 1:ncfs

  # Keep dataset of PC predictors
  prcomp_dat <- prcomp_out$x[, pcs_keep, drop = FALSE]

  # Keep CPVE value
  CPVE <- sum(PVE[pcs_keep])

  ## Define input data for imputation
  Z_mice <- cbind(Z, prcomp_dat)

  ## Define predictor matrix
  pred_mat <- make.predictorMatrix(Z_mice)
  pred_mat[, x_original] <- 0

  ## Impute
  imp_PCA_mids <- mice(Z_mice,
                       m      = 5,
                       method = "pmm",
                       maxit  = 1,
                       printFlag = FALSE,
                       predictorMatrix = pred_mat,
                       threshold = 1,
                       maxcor = 1,
                       eps = 0)

  # Track time it took
  end_time <- Sys.time()
  imp_PCA_time <- difftime(end_time, start_time, units = "mins")

  return(list(mids = imp_PCA_mids,
              CPVE = CPVE,
              time = as.vector(imp_PCA_time)))

}
