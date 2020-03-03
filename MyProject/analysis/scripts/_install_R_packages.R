########
# This script shows how to install R packages locally into /libraries/R
# To do a fresh install of all R packages, delete the entire /libraries/R folder
# Note: this script is provided for pedagogical purposes only; analysis assumes user has already installed these packages
########

# Create and define a local installation directory for the packages
proj_dir <- Sys.getenv(c("MyProject"))
dir.create(file.path(proj_dir, "analysis/scripts/libraries"))
dir.create(file.path(proj_dir, "analysis/scripts/libraries/R"))
dir.create(file.path(proj_dir, paste0("analysis/scripts/libraries/R/",.Platform$OS.type)))
lib <-     file.path(proj_dir, paste0("analysis/scripts/libraries/R/",.Platform$OS.type))

# Specify packages to install
packages <- c("estimatr")

# Set repository from which R packages will be downloaded
options(repos = "https://cran.rstudio.com")

# Install packages
lapply(packages, install.packages, lib = lib)


