########
# This script installs the R packages necessary to run the R portion of the analysis.
# Alternatively, user can do this manually by typing install.packages("X") at the R prompt, where X is the name of the package.
########

# Specify packages to install
packages <- c("tidyverse","estimatr")

# Set repository from which R packages will be downloaded
# Note: the RStudio package manager enables users to install all packages from binary, including for Linux
options(repos = "https://packagemanager.rstudio.com/all/latest")

# Install new packages to first element of .libPaths() or, if path is not writeable, to default user library path
lib <- .libPaths()[1]
if (!dir.create(lib, showWarnings = FALSE)[1]) {
  lib <- Sys.getenv("R_LIBS_USER")
  dir.create(lib, showWarnings = FALSE, recursive = TRUE)
}


########
# Sample code to install packages locally into /scripts/libraries/R/os instead of usual library path
# This code is provided for pedagogical purposes and has been commented out
# Note: R packages such as tidyverse are large (>100 megabytes)
########

# Function to determine whether user is running os is osx, linux, or something else
#get_os <- function(){
#  sysinf <- Sys.info()
#  if (!is.null(sysinf)){
#    os <- sysinf['sysname']
#    if (os == 'Darwin')
#      os <- "osx"
#  } else { ## mystery machine
#    os <- .Platform$OS.type
#    if (grepl("^darwin", R.version$os))
#      os <- "osx"
#    if (grepl("linux-gnu", R.version$os))
#      os <- "linux"
#  }
#  tolower(os)
#}
# os <- get_os()

#proj_dir <- Sys.getenv(c("MyProject"))
#dir.create(file.path(proj_dir, "scripts/libraries"))
#dir.create(file.path(proj_dir, "scripts/libraries/R"))
#dir.create(file.path(proj_dir, paste0("scripts/libraries/R/",os)))
#lib <-     file.path(proj_dir, paste0("scripts/libraries/R/",os))

########
# End of sample code
########

# Install packages from binary
lapply(packages, install.packages, lib = lib, dependencies=c("Depends", "Imports", "LinkingTo"))