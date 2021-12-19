# Project:   fireworks
# Objective: subroutine doRep to run all conditions for a single repetition
# Author:    Edoardo Costantini
# Created:   2021-12-19
# Modified:  2021-12-19

runRep <- function(rp, conds, parms, fs) {

# Example Internals -------------------------------------------------------

  # rp = 1

  ## Set seed
  .lec.SetPackageSeed(rep(parms$seed, 6))
  if(!rp %in% .lec.GetStreams()) # if the streams do not exist yet
    .lec.CreateStream(c(1 : parms$nStreams)) # then
  .lec.CurrentStream(rp) # this is equivalent to setting the seed Rle

  # Cycle thorugh conditions
  for(i in 1 : nrow(conds)) {
    # i <- 1
    print(paste0("Rep: ", rp,
                 " / Cond: ", i,
                 " / Time: ",
                 Sys.time()))

    runCell(rp = rp,
            cond = conds[i, ],
            fs = fs,
            parms = parms)
  }

}
