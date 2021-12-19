# Project:   fireworks
# Objective: subroutine runCell to run a single condition for a single rep
# Author:    Edoardo Costantini
# Created:   2021-12-19
# Modified:  2021-12-19
# Note:      A "cell" is a cycle through the set of conditions.
#            The function in this script generates 1 data set, performs
#            imputations for every condition in the set.

runCell <- function(rp, cond, fs, parms) {

  # Example Internals -------------------------------------------------------

  # cond = conds[1, ]
  # rp   = 1

  # Body ------------------------------------------------------------------
  tryCatch({ # START TRYCATCH EXPRESSION

    # Impute as expert ----------------------------------------------------
    expert_mids <- mice(fdd,
                        pred = fdd.pred,
                        meth = parms$meth,
                        maxit = 20,
                        print = FALSE)

    # Impute with pcr.all -------------------------------------------------
    pcrall_mids <- imputePCAall(Z = fdd, ncfs = 24L)

    # Impute with pmm PCR -------------------------------------------------
    vbv_mids <- mice(fdd,
                     meth = "pcr.pmm",
                     maxit = 20,
                     npc = 24L,
                     threshold = 1L,
                     maxcor = 1L,
                     eps = 0L,
                     print = FALSE)

    # Store Results -------------------------------------------------------
    results <- cbind(rep = rp,
                     rbind(
                       impProcess(mids_object = expert_mids,
                                  include_0 = FALSE,
                                  imp = "pmm"),
                       impProcess(mids_object = pcrall_mids$mids,
                                  include_0 = FALSE,
                                  imp = "pcr.all"),
                       impProcess(mids_object = vbv_mids,
                                  include_0 = FALSE,
                                  imp = "vbv"),
                     make.row.names = FALSE)
    )

    # Store Output ------------------------------------------------------------

    ## Store Main Results
    saveRDS(results,
            file = paste0(fs$outDir,
                          "rep_", rp, "_",
                          "main",
                          ".rds")
    )

    ### END TRYCATCH EXPRESSION
  }, error = function(e){
    err <- paste0("Original Error: ", e)
    err_res <- cbind(rp = rp, Error = err)
    saveRDS(err_res,
            file = paste0(fs$outDir,
                          "rep_", rp, "_",
                          "ERROR",
                          ".rds")
    )
    return(NULL)
  }
  )

}

