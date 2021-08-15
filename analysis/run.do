**********************
* OVERVIEW
*   This script generates tables and figures for the paper:
*       "My Project" (by Julian Reif)
*   All raw data are stored in /data
*   All tables are outputted to /results/tables
*   All figures are outputted to /results/figures
*
* SOFTWARE REQUIREMENTS
*   Analyses run on Windows using Stata version 15 and R-3.6.0
*
* TO PERFORM A CLEAN RUN, DELETE THE FOLLOWING TWO FOLDERS:
*   /processed
*   /results
**********************

* User must set the global macro MyProject to the path of the folder that includes run.do
* global MyProject "C:/Users/jdoe/MyProject"

* To disable the R portion of the analysis, set the following flag to 1
global DisableR = 0

* Confirm that the global for the project root directory has been defined
assert !missing("$MyProject")

* Initialize log and record system parameters
clear
set more off
cap mkdir "$MyProject/scripts/logs"
cap log close
local datetime : di %tcCCYY.NN.DD!-HH.MM.SS `=clock("$S_DATE $S_TIME", "DMYhms")'
local logfile "$MyProject/scripts/logs/`datetime'.log.txt"
log using "`logfile'", text

di "Begin date and time: $S_DATE $S_TIME"
di "Stata version: `c(stata_version)'"
di "Updated as of: `c(born_date)'"
di "Variant:       `=cond( c(MP),"MP",cond(c(SE),"SE",c(flavor)) )'"
di "Processors:    `c(processors)'"
di "OS:            `c(os)' `c(osdtl)'"
di "Machine type:  `c(machine_type)'"

* All required Stata packages are available in the /libraries/stata folder
tokenize `"$S_ADO"', parse(";")
while `"`1'"' != "" {
  if `"`1'"'!="BASE" cap adopath - `"`1'"'
  macro shift
}
adopath ++ "$MyProject/scripts/libraries/stata"
mata: mata mlib index

* R packages can be installed manually (see README) or installed automatically by uncommenting the following line
* if "$DisableR"!="1" rscript using "$MyProject/scripts/programs/_install_R_packages.R"

* Stata programs and R scripts are stored in /programs
adopath ++ "$MyProject/scripts/programs"

* Stata and R version control
version 15
if "$DisableR"!="1" rscript, rversion(3.6) require(tidyverse estimatr)

* Create directories for output files
cap mkdir "$MyProject/processed"
cap mkdir "$MyProject/processed/intermediate"
cap mkdir "$MyProject/results"
cap mkdir "$MyProject/results/figures"
cap mkdir "$MyProject/results/intermediate"
cap mkdir "$MyProject/results/tables"

* Run project analysis
do "$MyProject/scripts/1_process_raw_data.do"
do "$MyProject/scripts/2_clean_data.do"
do "$MyProject/scripts/3_regressions.do"
do "$MyProject/scripts/4_make_tables_figures.do"

* End log
di "End date and time: $S_DATE $S_TIME"
log close

** EOF
