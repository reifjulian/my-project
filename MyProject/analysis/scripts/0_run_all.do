**********************
* OVERVIEW
*   This script generates tables and figures for the paper:
*       "My Project" (Julian Reif)
*   All raw data are stored in /data/raw
*   All tables are outputted to /results/tables
*   All figures are outputted to /results/figures
* 
* SOFTWARE REQUIREMENTS
*   Analyses run on Windows using Stata version 15 and R-3.4.0
*   Install R-3.4.0 for Windows from https://cran.r-project.org/bin/windows/base/old/3.4.0/
*
* TO PERFORM A CLEAN RUN, DELETE THE FOLLOWING TWO FOLDERS:
*   /results
*   /data/proc
**********************

* User must define two global macros in order to run the analysis:
* (1) "MyProject" points to the project folder
* (2) "RSCRIPT_PATH" points to the folder containing the executables for R-3.4.0
* global MyProject "C:/Users/jdoe/MyProject"
* global RSCRIPT_PATH "C:/Program Files/R/R-3.4.0/bin/x64"

* To disable the R portion of the analysis, set the following flag to 1
global DisableR = 0

* Confirm that the globals for the project root directory and the R executable have been defined
assert !missing("$MyProject")
if "$DisableR"!="1" assert !missing("$RSCRIPT_PATH")

* Log session
clear 
set more off
cap mkdir "$MyProject/analysis/scripts/logs"
cap log close
local datetime : di %tcCCYY.NN.DD!_HH.MM.SS `=clock("$S_DATE $S_TIME", "DMYhms")'
local logfile "$MyProject/analysis/scripts/logs/log_`datetime'.smcl"
log using "`logfile'"
di "Begin date and time: $S_DATE $S_TIME"

* All required Stata packages are available in the /libraries folder
adopath ++ "$MyProject/analysis/scripts/libraries/stata"
mata: mata mlib index

* Stata programs and R scripts are stored in /functions
adopath ++ "$MyProject/analysis/scripts/functions"

* Stata and R version control
version 15
if "$DisableR"!="1" rscript using "$MyProject/analysis/scripts/functions/_confirm_version.R"

* Create directories for output files
cap mkdir "$MyProject/analysis/results"
cap mkdir "$MyProject/analysis/results/figures"
cap mkdir "$MyProject/analysis/results/intermediate"
cap mkdir "$MyProject/analysis/results/tables"

* Run project analysis
do "$MyProject/analysis/scripts/1_process_raw_data.do"
do "$MyProject/analysis/scripts/2_clean_data.do"
do "$MyProject/analysis/scripts/3_regressions.do"
do "$MyProject/analysis/scripts/4_make_tables_figures.do"

* End log
di "End date and time: $S_DATE $S_TIME"
log close

** EOF
