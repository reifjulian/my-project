************
* Preamble: these two lines of code are included so that individual scripts can be run standalone (if desired)
************
adopath ++ "$MyProject/scripts/libraries/stata"
adopath ++ "$MyProject/scripts/programs"

************
* SCRIPT: 2_clean_data.do
* PURPOSE: processes the main dataset in preparation for analysis
************

use "$MyProject/data/proc/intermediate/auto_uncleaned.dta", clear

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
save "$MyProject/data/proc/auto.dta", replace

** EOF
