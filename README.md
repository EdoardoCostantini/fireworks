# Project description
Repository hosting a comparison benchmark set up for the fireworks disaster data.

# How to replicate results

To replicate the study, you first need to make sure you have installed all the pacakges used.
You can use the `./input/prep_machine.R` script to install them.
In the following guide, it is assumed that the machine on which the simulation is run already has all packages installed.

- Open the initialization script `init.R` and check that:
  - you have all the required packages installed;
  - the fixed parameters and experimental factor levels are set to the desired values.
- Open the script `pc_run_simulation.R`
- Define the number of desired repetitions by changing the parameter `reps`
- Define the number of clusters for parallelization by changing the parameter `clusters`
- Run the script `pc_run_simulation.R`
- Run the script `pc_run_readRes.R` to unzip the results and create a single .rds file
- Finally, run the script `pc_run_plots.R` to obtain the plots.

# Repository structure
Here is the project structure:
```
├── code
│ ├── functions
│ │ ├── impProcess.R
│ │ ├── imputePCAall.R
│ │ ├── imputePCAaux.R
│ │ ├── readTarGz.R
│ │ └── writeTarGz.R
│ ├── subroutines
│ │ ├── runCell.R
│ │ └── runRep.R
│ ├── compare.R
│ ├── fdd.R
│ ├── init.R
│ ├── pc_run_plots.R
│ ├── pc_run_readRes.R
│ ├── pc_run_simulation.R
│ └── prep.R
├── input
│ ├── mice.pcr.sim_3.13.9.tar.gz
│ └── mice_3.13.18.tar.gz
├── output
│ ├── 20211220_144954.tar.gz
│ └── 20211220_144954_res.rds
├── .Rprofile
├── .gitignore
└── README.md


```

Here is a brief description of the folders:
- `code`: the main software to run the study
  - `checks` folder contains some script to check a few details of the procedure are producing the expected results
  - `experiments` folder contains some initial trial scripts
  - `functions` folder with the main project specific functions
  - `helper` folder with functions to address file management and other small internal tasks 
  - `plots` folder containing some plotting scripts and pdfs
  - `subroutines` folder with the generic functions to run the simulation study
- `input` folder where all the input files (e.g., data) should be stored
- `output` folder where the results of the simulation study will be stored
- `test` folder containing unit testing files