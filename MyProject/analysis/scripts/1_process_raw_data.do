************
* Preamble: these two lines of code are included so that individual scripts can be run standalone (if desired)
************
adopath ++ "$MyProject/analysis/scripts/libraries/stata"
adopath ++ "$MyProject/analysis/scripts/programs"

************
* SCRIPT: 1_process_raw_data.do
* PURPOSE: imports the raw data and saves it in Stata readable format
************



cap mkdir "$MyProject/analysis/data/proc"
cap mkdir "$MyProject/analysis/data/proc/intermediate"


insheet using "$MyProject/analysis/data/raw/auto.csv", comma clear

compress
save "$MyProject/analysis/data/proc/intermediate/auto_uncleaned.dta", replace

** EOF
