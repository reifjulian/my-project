########
# This script installs all necessary R packages into /libraries/R
# To do a fresh install of all R packages, delete the entire /libraries/R folder
# Note: this script has been provided for pedagogical purposes only. It should NOT be included as part of your replication materials, since these add-ons are already available in /libraries/R
########

# Create and define a local installation directory for the packages
proj_dir <- Sys.getenv(c("MyProject"))
dir.create(file.path(proj_dir, "analysis/scripts/libraries"))
dir.create(file.path(proj_dir, "analysis/scripts/libraries/R"))
lib <- file.path(proj_dir, "analysis/scripts/libraries/R")

# Specify packages to install
packages <- c("estimatr")

# Set repository from which R packages will be downloaded
options(repos = "https://cran.rstudio.com")

# Install packages
lapply(packages, install.packages, lib = lib)


