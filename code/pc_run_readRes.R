# Project:   fireworks
# Objective: Read results from simulation
# Author:    Edoardo Costantini
# Created:   2021-12-19
# Modified:  2021-12-19

# Environment ----------------------------------------------------------
rm(list = ls())
source("./init.R") # Support Functions

# Load Results ----------------------------------------------------------
inDir <- "../output/"
files <- grep("tar", list.files(inDir), value = TRUE)
target_tar <- tail(files, 1)
output <- readTarGz(target_tar)

# Restructure Results -----------------------------------------------------

# Were there any errors?
errors <- grep("ERROR", output$file_names)

# Put together main results
out_main <- output$out[grepl("main", output$file_names)]
out <- do.call(rbind, out_main)

# Extract Results ----------------------------------------------------------

# Store Results
saveRDS(out,
        file = paste0("../output/",
                      output$name_run,
                      "_res",
                      ".rds")
)