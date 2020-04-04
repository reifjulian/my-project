************
* SCRIPT: 2_clean_data.do
* PURPOSE: processes the main dataset in preparation for analysis
************

* Preamble: these two lines of code are included so scripts can be run individually (rather than called by 0_run_all.do)
adopath ++ "$MyProject/scripts/libraries/stata"
adopath ++ "$MyProject/scripts/programs"

************
* Code begins
************

use "$MyProject/processed/intermediate/auto_uncleaned.dta", clear

* Replace missing values with median for that variable
foreach v of varlist * {
	cap confirm numeric var `v'
	if _rc continue
	
	gen imp_`v' = mi(`v')
	label var imp_`v' "Imputed value for `v'"
	summ `v', detail
	replace `v' = r(p50) if mi(`v')
}

compress
save "$MyProject/processed/auto.dta", replace

** EOF
