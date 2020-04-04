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

insheet using "$MyProject/data/auto.csv", comma clear

compress
save "$MyProject/processed/intermediate/auto_uncleaned.dta", replace

** EOF
