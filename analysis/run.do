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

* Record start time and initialize log
local datetime1 = clock("$S_DATE $S_TIME", "DMYhms")
clear
cap mkdir "`ProjectDir'/scripts/logs"
cap log close
local logdate : di %tcCCYY.NN.DD!_HH.MM.SS `datetime1'
local logfile "`ProjectDir'/scripts/logs/`logdate'.log.txt"
log using "`logfile'", text

* Configure Stata's library environment and record system parameters
run "`ProjectDir'/scripts/programs/_config.do"

* R packages can be installed manually (see README) or installed automatically by uncommenting the following line
* if "$DisableR"!="1" rscript using "$MyProject/scripts/programs/_install_R_packages.R"

* R version control
if "$DisableR"!="1" rscript, rversion(3.6) require(tidyverse estimatr)

* Run project analysis
do "`ProjectDir'/scripts/1_process_raw_data.do"
do "`ProjectDir'/scripts/2_clean_data.do"
do "`ProjectDir'/scripts/3_regressions.do"
do "`ProjectDir'/scripts/4_make_tables_figures.do"

* Display runtime and end the script
local datetime2 = clock("$S_DATE $S_TIME", "DMYhms")
di "Runtime (hours): " %-12.2fc (`datetime2' - `datetime1')/(1000*60*60)
log close

** EOF
