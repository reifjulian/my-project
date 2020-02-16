# This script is intended to be called by Stata, which feeds it the two arguments it needs
# If run standalone, the script assumes the project directory has been set by the system variable "MyProject". 
# --- Alternatively, user can run this as a standalone script by manually editing the line "MyProject <- Sys.getenv(c("MyProject"))"
args = commandArgs(trailingOnly = "TRUE")
if (length(args)) {
  dataset <- args[1]
  output <- args[2]
  MyProject <- args[3]
} else {
  MyProject <- Sys.getenv(c("MyProject"))
  dataset <- file.path(MyProject, "analysis/data/proc/auto.dta")
  output <- file.path(MyProject, "analysis/results/intermediate/my_lm_regressions.dta")
}

# Local (non-tidyverse) libraries are stored in the project
lib = file.path(MyProject, "analysis/scripts/libraries/R")

# Load required libraries
library(tidyverse)
library(haven)
library(estimatr, lib.loc = lib)

my_data <- read_dta(dataset)

# Estimate OLS assuming HC1 standard errors (equivalent to "robust" in Stata)
ols1 <- lm_robust(price ~ mpg, data = my_data %>% filter(foreign=="Domestic"), se_type = "HC1")

ols2 <- lm_robust(price ~ mpg, data = my_data %>% filter(foreign=="Foreign"), se_type = "HC1")

ols3 <- lm_robust(price ~ mpg + weight, data = my_data %>% filter(foreign=="Domestic"), se_type = "HC1")

ols4 <- lm_robust(price ~ mpg + weight, data = my_data %>% filter(foreign=="Foreign"), se_type = "HC1")

# Format regression output and write to file
tidyols1 = add_column(tidy(ols1),origin="Domestic")
tidyols1 = add_column(tidyols1,rhs="mpg")
tidyols2 = add_column(tidy(ols2), origin ="Foreign")
tidyols2 = add_column(tidyols2,rhs="mpg")
tidyols3 = add_column(tidy(ols3), origin ="Domestic")
tidyols3 = add_column(tidyols3,rhs="mpg weight")
tidyols4 = add_column(tidy(ols4), origin ="Foreign")
tidyols4 = add_column(tidyols4,rhs="mpg weight")

tidyols_all <- bind_rows(tidyols1,tidyols2,tidyols3,tidyols4)

colnames(tidyols_all) <- gsub(".","_",colnames(tidyols_all), fixed=TRUE)

write_dta(tidyols_all,output)

## EOF