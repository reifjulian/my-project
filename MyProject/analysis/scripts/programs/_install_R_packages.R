########
# This script installs the R packages necessary to run the R portion of the analysis.
# Alternatively, user can do this manually by typing install.packages("X") at the R prompt, where X is the name of the package.
########

# Specify packages to install
packages <- c("tidyverse","estimatr")

# Set repository from which R packages will be downloaded
options(repos = "https://cran.rstudio.com")

# Install new packages to first element of .libPaths() or, if path is not writeable, to default user library path
lib <- .libPaths()[1]
if (!dir.create(lib, showWarnings = FALSE)[1]) {
  lib <- Sys.getenv("R_LIBS_USER")
  dir.create(lib, showWarnings = FALSE, recursive = TRUE)
}

########
# Sample code (lines 20-24) to install packages locally into /scripts/libraries/R instead of usual library path
# This code is provided for pedagogical purposes and has been commented out
# Note: R packages such as tidyverse are large (>100 megabytes)
########
#proj_dir <- Sys.getenv(c("MyProject"))
#dir.create(file.path(proj_dir, "scripts/libraries"))
#dir.create(file.path(proj_dir, "scripts/libraries/R"))
#dir.create(file.path(proj_dir, paste0("scripts/libraries/R/",.Platform$OS.type)))
#lib <-     file.path(proj_dir, paste0("scripts/libraries/R/",.Platform$OS.type))

# Install packages from source (Unix) and from binary otherwise
if (.Platform$OS.type=="unix") {
  lapply(packages, install.packages, lib = lib, type="source", dependencies=c("Depends", "Imports", "LinkingTo"))
} else {
  lapply(packages, install.packages, lib = lib, type="binary", dependencies=c("Depends", "Imports", "LinkingTo"))
}










