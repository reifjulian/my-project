########
# This script enforces version control by confirming that the user's R version is sufficiently new
# It also checks whether the tidyverse library has been installed
########

# Check that users have installed R version 3.6.0 or later
if (as.numeric(paste0(version$major, version$minor)) <36) {
  vers_ex_msg = paste0("This analysis requires R 3.6.0 or later. Your current version is ",
                    version$major, ".", version$minor, ".\n",
                    "Please download a new version of R before continuing: https://www.r-project.org"
                    )
  stop(vers_ex_msg)
}



# Check that user has installed tidyverse
if(!is.element("tidyverse", installed.packages()[,1])) {
  vers_ex_msg = paste0("This analysis requires the R tidyverse package. Please download the latest version of tidyverse before continuing: https://tidyverse.tidyverse.org/")
  stop(vers_ex_msg)
}

# Ensure that tidyverse is version 1.3.0 or later
if (packageVersion("tidyverse") < "1.3.0") {
  vers_ex_msg = paste0("This analysis requires tidyverse 1.3.0 or later. Your current version is ",
                    packageVersion("tidyverse"), ".\n",
                    "Please download the latest version of tidyverse before continuing: https://tidyverse.tidyverse.org/"
                    )
  stop(vers_ex_msg)
}

##EOF


