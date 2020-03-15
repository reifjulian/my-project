************
* Preamble: these two lines of code are included so that individual scripts can be run standalone (if desired)
************
adopath ++ "$MyProject/scripts/libraries/stata"
adopath ++ "$MyProject/scripts/programs"

************
* SCRIPT: 3_regressions.do
* PURPOSE: estimates regression models and saves the resulting output
************

tempfile results
use "$MyProject/data/proc/auto.dta", clear

local replace replace
foreach rhs in "mpg" "mpg weight" {
	
	* Domestic cars
	reg price `rhs' if foreign=="Domestic", robust
	regsave using "`results'", t p autoid `replace' addlabel(rhs,"`rhs'",origin,Domestic) 
	local replace append
	
	* Foreign cars
	reg price `rhs' if foreign=="Foreign", robust
	regsave using "`results'", t p autoid append addlabel(rhs,"`rhs'",origin,"Foreign") 
		
}

use "`results'", clear
save "$MyProject/results/intermediate/my_regressions.dta", replace

* R regressions. First argument: input file. Second argument: output file.
if "$DisableR"!="1" rscript using "$MyProject/scripts/programs/regressions.R", args("$MyProject/data/proc/auto.dta" "$MyProject/results/intermediate/my_lm_regressions.dta")

** EOF
