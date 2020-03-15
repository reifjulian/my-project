************
* Preamble: these two lines of code are included so that individual scripts can be run standalone (if desired)
************
adopath ++ "$MyProject/scripts/libraries/stata"
adopath ++ "$MyProject/scripts/programs"

************
* SCRIPT: 1_process_raw_data.do
* PURPOSE: imports the raw data and saves it in Stata readable format
************



cap mkdir "$MyProject/data/proc"
cap mkdir "$MyProject/data/proc/intermediate"


insheet using "$MyProject/data/raw/auto.csv", comma clear

compress
save "$MyProject/data/proc/intermediate/auto_uncleaned.dta", replace

** EOF
