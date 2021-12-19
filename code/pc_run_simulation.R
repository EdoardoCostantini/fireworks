# Project:   fireworks
# Objective: Run simulation
# Author:    Edoardo Costantini
# Created:   2021-12-19
# Modified:  2021-12-19

## Make sure we have a clean environment:
rm(list = ls())

## Initialize the environment:
source("./init.R")

## Run specs
  reps <- 1 : 20 # define repetitions
  clusters <- 5  # define clusters

## File System
  fs <- list()
  fs$start_time <- format(Sys.time(), "%Y%m%d_%H%M%S")

  # Main Folder
  fs$outDir <- paste0("../output/", fs$start_time, "/")
  dir.create(fs$outDir)

  # File names
  fs$fileName_res <- fs$start_time
  fs$fileName_prog <- fs$start_time

## Progress report file
file.create(paste0(fs$outDir, fs$fileName_prog, ".txt"))

cat(paste0("SIMULATION PROGRESS REPORT",
           "\n",
           "Starts at: ", Sys.time(),
           "\n", "------", "\n" ),
    file = paste0(fs$outDir, fs$fileName_prog, ".txt"),
    sep = "\n",
    append = TRUE)

## Open clusters
clus <- makeCluster(clusters)

## Export to worker nodes
# export global env
clusterExport(cl = clus, varlist = "fs", envir = .GlobalEnv)
# export script to be executed
clusterEvalQ(cl = clus, expr = source("./init.R"))

# mcApply parallel --------------------------------------------------------

sim_start <- Sys.time()

## Run the computations in parallel on the 'clus' object:
out <- parLapply(cl    = clus,
                 X     = reps,
                 fun   = runRep,
                 conds = conds,
                 parms = parms,
                 fs = fs)

## Kill the cluster:
stopCluster(clus)

sim_ends <- Sys.time()
run_time <- difftime(sim_ends, sim_start, units = "hours")
cat(paste0("\n", "------", "\n",
           "Ends at: ", Sys.time(), "\n",
           "Run time: ",
           round(difftime(sim_ends, sim_start, units = "hours"), 3), " h",
           "\n", "------", "\n"),
    file = paste0(fs$outDir, fs$fileName_prog, ".txt"),
    sep = "\n",
    append = TRUE)

# Attach Extract Info Objects
out_support <- list()
out_support$parms <- parms
out_support$conds <- conds
out_support$session_info <- devtools::session_info()
out_support$run_time <- run_time

# Save output -------------------------------------------------------------

saveRDS(out_support,
        paste0(fs$outDir, "sInfo.rds"))

# Zip output folder -------------------------------------------------------

writeTarGz(fs$fileName_res)