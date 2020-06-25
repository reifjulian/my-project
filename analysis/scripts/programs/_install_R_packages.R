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

# Function to determine whether user is running osx, linux, or something else
get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin')
      os <- "osx"
  } else { ## mystery machine
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os))
      os <- "osx"
    if (grepl("linux-gnu", R.version$os))
      os <- "linux"
  }
  tolower(os)
}

########
# Sample code to install packages locally into /scripts/libraries/R/os instead of usual library path
# This code is provided for pedagogical purposes and has been commented out
# Note: R packages such as tidyverse are large (>100 megabytes)
########

#proj_dir <- Sys.getenv(c("MyProject"))
#dir.create(file.path(proj_dir, "scripts/libraries"))
#dir.create(file.path(proj_dir, "scripts/libraries/R"))
#dir.create(file.path(proj_dir, paste0("scripts/libraries/R/",get_os())))
#lib <-     file.path(proj_dir, paste0("scripts/libraries/R/",get_os()))

########
# End of sample code
########


# Install packages from binary, unless system is Unix (where source is only option)
install_type <- "binary"
if (.Platform$OS.type=="unix" & get_os()!="osx") {
  	install_type <- "source"
}

lapply(packages, install.packages, lib = lib, type = install_type, dependencies=c("Depends", "Imports", "LinkingTo"))