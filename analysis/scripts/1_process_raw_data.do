************
* SCRIPT: 1_process_raw_data.do
* PURPOSE: imports the raw data and saves it in Stata readable format
************

* Preamble (unnecessary when executing run.do)
run "$MyProject/scripts/programs/_config.do"

************
* Code begins
************

insheet using "$MyProject/data/auto.csv", comma clear

compress
save "$MyProject/processed/intermediate/auto_uncleaned.dta", replace

** EOF
