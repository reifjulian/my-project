**********************
* OVERVIEW
*   This script generates tables and figures for the paper:
*       "My Project" (Julian Reif)
*   All raw data are stored in /data/raw
*   All tables are outputted to /results/tables
*   All figures are outputted to /results/figures
* 
* SOFTWARE REQUIREMENTS
*   Analyses run on Windows using Stata version 15 and R-3.6.0
*
* TO PERFORM A CLEAN RUN, DELETE THE FOLLOWING TWO FOLDERS:
*   /results
*   /data/proc
**********************

* User must define two global macros in order to run the analysis:
* (1) "MyProject" points to the project folder
* (2) "RSCRIPT_PATH" points to the folder containing the executables for R-3.6.0 (or newer)
* global MyProject "C:/Users/jdoe/MyProject"
* global RSCRIPT_PATH "C:/Program Files/R/R-3.6.0/bin/x64"

* To disable the R portion of the analysis, set the following flag to 1
global DisableR = 0

* Confirm that the globals for the project root directory and the R executable have been defined
assert !missing("$MyProject")
if "$DisableR"!="1" assert !missing("$RSCRIPT_PATH")

* Initialize log and record system parameters
clear 
set more off
cap mkdir "$MyProject/scripts/logs"
cap log close
local datetime : di %tcCCYY.NN.DD!_HH.MM.SS `=clock("$S_DATE $S_TIME", "DMYhms")'
local logfile "$MyProject/scripts/logs/log_`datetime'.smcl"
log using "`logfile'"

di "Begin date and time: $S_DATE $S_TIME"
di "Stata version: `c(stata_version)'"
di "Updated as of: `c(born_date)'"
di "Variant:       `=cond( c(MP),"MP",cond(c(SE),"SE",c(flavor)) )'"
di "Processors:    `c(processors)'"
di "OS:            `c(os)' `c(osdtl)'"
di "Machine type:  `c(machine_type)'"

* All required Stata packages are available in the /libraries/stata folder
adopath ++ "$MyProject/scripts/libraries/stata"
mata: mata mlib index

* R packages can be installed manually (see README) or installed automatically by uncommenting the following line
* if "$DisableR"!="1" rscript using "$MyProject/scripts/programs/_install_R_packages.R"

* Stata programs and R scripts are stored in /programs
adopath ++ "$MyProject/scripts/programs"

* Stata and R version control
version 15
if "$DisableR"!="1" rscript using "$MyProject/scripts/programs/_confirm_version.R"

* Create directories for output files
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
