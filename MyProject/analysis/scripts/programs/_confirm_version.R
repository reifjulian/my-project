########
# This script enforces version control by confirming that the user's R version is sufficiently new
# It also checks whether the tidyverse and estimatr libraries have been installed
########

# Check that users have installed R version 3.6.0 or later
if (as.numeric(paste0(version$major, version$minor)) < 36) {
  vers_ex_msg = paste0("This analysis requires R 3.6.0 or later. Your current version is ",
                    version$major, ".", version$minor, ".\n",
                    "Please download a new version of R before continuing: https://www.r-project.org"
                    )
  stop(vers_ex_msg)
}


# Check that the following packages have been installed
packages <- c("tidyverse", "estimatr")
installed <- packages %in% installed.packages()[, "Package"]
if(any(!installed)) {
	vers_ex_msg = paste0("This analysis requires the following add-on R package(s):\n",
					paste(packages[!installed], collapse = ', '),
					"\n\nPlease install these packages before continuing. To install, type install.packages(\"X\") at the R prompt, where X is the name of the package.")
	stop(vers_ex_msg)
}

# Ensure that tidyverse is version 1.3.0 or later
if (packageVersion("tidyverse") < "1.3.0") {
  vers_ex_msg = paste0("The R analysis requires tidyverse 1.3.0 or later. Your current version is ",
                    packageVersion("tidyverse"), ".\n",
                    "Please download the latest version of tidyverse before continuing: https://tidyverse.tidyverse.org/"
                    )
  stop(vers_ex_msg)
}

##EOF


