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

* User must uncomment the following line ("global ...") and set the filepath equal to the folder containing this run.do file 
* global MyProject "C:/Users/jdoe/MyProject"
local ProjectDir "$MyProject"

* To disable the R portion of the analysis, set the following flag to 1
global DisableR = 0

* Confirm that the globals for the project root directory have been defined
cap assert !mi("`ProjectDir'")
if _rc {
	noi di as error "Error: need to define the global in run.do"
	error 9
}

* Initialize log
clear
set more off
cap mkdir "`ProjectDir'/scripts/logs"
cap log close
local datetime : di %tcCCYY.NN.DD!-HH.MM.SS `=clock("$S_DATE $S_TIME", "DMYhms")'
local logfile "`ProjectDir'/scripts/logs/`datetime'.log.txt"
log using "`logfile'", text

* Configure Stata's library environment and record system parameters
run "`ProjectDir'/scripts/programs/_config.do"

* R packages can be installed manually (see README) or installed automatically by uncommenting the following line
* if "$DisableR"!="1" rscript using "$MyProject/scripts/programs/_install_R_packages.R"

* Stata and R version control
version 15
if "$DisableR"!="1" rscript, rversion(3.6) require(tidyverse estimatr)

* Create directories for output files
cap mkdir "`ProjectDir'/processed"
cap mkdir "`ProjectDir'/processed/intermediate"
cap mkdir "`ProjectDir'/results"
cap mkdir "`ProjectDir'/results/figures"
cap mkdir "`ProjectDir'/results/intermediate"
cap mkdir "`ProjectDir'/results/tables"

* Run project analysis
do "`ProjectDir'/scripts/1_process_raw_data.do"
do "`ProjectDir'/scripts/2_clean_data.do"
do "`ProjectDir'/scripts/3_regressions.do"
do "`ProjectDir'/scripts/4_make_tables_figures.do"

* End log
di "End date and time: $S_DATE $S_TIME"
log close

** EOF
