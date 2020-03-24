************
* SCRIPT: 1_process_raw_data.do
* PURPOSE: imports the raw data and saves it in Stata readable format
************

* Preamble: these two lines of code are included so scripts can be run individually (rather than called by 0_run_all.do)
adopath ++ "$MyProject/scripts/libraries/stata"
adopath ++ "$MyProject/scripts/programs"

************
* Code begins
************

cap mkdir "$MyProject/data/proc"
cap mkdir "$MyProject/data/proc/intermediate"

insheet using "$MyProject/data/raw/auto.csv", comma clear

compress
save "$MyProject/data/proc/intermediate/auto_uncleaned.dta", replace

** EOF
