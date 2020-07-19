########
# This script enforces version control by checking the user's base R version
# It also checks whether the tidyverse and estimatr libraries have been installed
########

# Up to 4 arguments accepted:
# 1. minimum R version
# 2. maximum R version
# 3. enforce minimum with hard break
# 4. enforce the maximum with hard break


# Syntax 1 example: require an exact version of R
# _confirm_version 3.6.0

# Syntax 2 example: check that R is between 3.4 and 3.6, and issue warning if not
# _confirm_version 3.4 3.6 0 0

args = commandArgs(trailingOnly = "TRUE")
if (length(args)) {
  rmin <- args[1]
  rmax <- args[2]
  enforcemin <- as.numeric(args[3])
  enforcemax <- as.numeric(args[4])
  
  if (length(args) == 1) rmax <- rmin
  if (length(args) > 4) stop('Too many arguments.')

} else stop('Arguments required.')

# Default: hard break if version control not met
if(is.na(enforcemin)) enforcemin <- 1
if(is.na(enforcemax)) enforcemax <- 1

###
# Base R version control
###

rcurrent <- packageVersion("base")

# Minimum version requirements
if (rcurrent < rmin) {
  vers_ex_msg = paste0("This is version ", rcurrent, " of R; it may not be able to correctly run code written for version ", rmin ,
                       ".\nYou can download a newer version of R by visiting: https://www.r-project.org"
                    )
  if(enforcemin) stop(vers_ex_msg)
  else cat(paste("Warning: ", vers_ex_msg))
}

# Maximum version requirements
if (rcurrent > rmax) {
  vers_ex_msg = paste0("This is version ", rcurrent, " of R; it may not be able to correctly run code written for version ", rmax ,
                       ".\nYou can download an older version of R by visiting: https://www.r-project.org"
  )
 
  if(enforcemax) stop(vers_ex_msg)
  else cat(paste("Warning: ", vers_ex_msg))
}


###
# Check that add-on packages are present
###

# Check that the following packages have been installed
packages <- c("tidyverse", "estimatr")
installed <- packages %in% installed.packages()[, "Package"]
if(any(!installed)) {
	vers_ex_msg = paste0("This analysis requires the following add-on R package(s):\n",
					paste(packages[!installed], collapse = ', '),
					"\n\nPlease install these packages before continuing. To install, type install.packages(\"X\") at the R prompt, where X is the name of the package.\nAlternatively, run the script /programs/_install_R_packages.R")
	stop(vers_ex_msg)
}

###
# Add-on package version control
###

# Ensure that tidyverse is version 1.3.0 or later
if (packageVersion("tidyverse") < "1.3.0") {
  vers_ex_msg = paste0("The R analysis requires tidyverse 1.3.0 or later. Your current version is ",
                    packageVersion("tidyverse"), ".\n",
                    "Please download the latest version of tidyverse before continuing: https://tidyverse.tidyverse.org/"
                    )
  stop(vers_ex_msg)
}

##EOF


