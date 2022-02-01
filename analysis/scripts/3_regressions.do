************
* SCRIPT: 3_regressions.do
* PURPOSE: estimates regression models and saves the resulting output
************

* Preamble (unnecessary when executing run.do)
run "$MyProject/scripts/programs/_config.do"

************
* Code begins
************

tempfile results
use "$MyProject/processed/auto.dta", clear

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
compress
save "$MyProject/results/intermediate/my_regressions.dta", replace

* R regressions. First argument: input file. Second argument: output file.
if "$DisableR"!="1" rscript using "$MyProject/scripts/programs/regressions.R", args("$MyProject/processed/auto.dta" "$MyProject/results/intermediate/my_lm_regressions.dta")

** EOF
