************
* SCRIPT: 4_make_tables_figures.do
* PURPOSE: creates the LaTeX tables and PDF figures for the paper
************

* Preamble (unnecessary when executing run.do)
run "$MyProject/scripts/programs/_config.do"

************
* Code begins
************

********************************
* Price histogram              *
********************************

use "$MyProject/processed/auto.dta", clear
format price %12.0fc
histogram price, frequency xtitle("Price (1978 dollars)") graphregion(fcolor(white))
graph export "$MyProject/results/figures/price_histogram.pdf", as(pdf) replace

********************************
* Descriptive statistics table *
********************************
tempfile tmp
preserve
local run_no = 0
foreach v in price mpg weight {

	assert inlist(imp_`v',0,1)
	gen non_missing = 1 - imp_`v'

	collapse (mean) mean=`v' (sd) sd=`v' (min) min=`v' (max) max=`v' (sum) count=non_missing, fast

	gen var = "`v'"
	if `run_no'>0 append using "`tmp'"
	save "`tmp'", replace
	local run_no = `run_no'+1
	restore, preserve
}
restore, not
use "`tmp'", clear
order var

* Page 2: "The average price of automobiles in this dataset is $6,165."
assert abs(mean-6165.26)<0.01 if var=="price"

tostring mean sd min max, format(%9.3gc) replace force
tostring count, format(%9.0gc) replace

label var mean "Mean"
label var sd "Stdev."
label var min "Min"
label var max "Max"
label var count "Count"

* Run Stata program (stored in /programs)
clean_vars var

local fn "Notes: Count reports the number of non-missing values for the variable."
local title "Summary statistics"

texsave using "$MyProject/results/tables/my_summary_stats.tex", replace varlabels marker(tab:my_summary_stats) title("`title'") footnote("`fn'")


***************************
* Create regression table *
***************************
tempfile my_table
use "$MyProject/results/intermediate/my_regressions.dta", clear

* Merge together the four regressions into one table
local run_no = 1
local replace replace
foreach orig in "Domestic" "Foreign" {
	foreach rhs in "mpg" "mpg weight" {
		
		regsave_tbl using "`my_table'" if origin=="`orig'" & rhs=="`rhs'", name(col`run_no') asterisk(10 5 1) parentheses(stderr) sigfig(3) `replace'
		
		local run_no = `run_no'+1
		local replace append
	}
}

***
* Format the table
***
use "`my_table'", clear
drop if inlist(var,"_id","rhs","origin") | strpos(var,"_cons") | strpos(var,"tstat") | strpos(var,"pval")

* texsave will output these labels as column headers
label var col1 "Spec 1"
label var col2 "Spec 2"
label var col3 "Spec 1"
label var col4 "Spec 2"

* Display R^2 in LaTeX math mode
replace var = "\(R^2\)" if var=="r2"

* Clean variable names
replace var = subinstr(var,"_coef","",1)
replace var = "" if strpos(var,"_stderr")
clean_vars var

local title "Association between automobile price and fuel efficiency"
local headerlines "& \multicolumn{2}{c}{Domestic cars} & \multicolumn{2}{c}{Foreign cars} " "\cmidrule(lr){2-3} \cmidrule(lr){4-5}"
local fn "Notes: Outcome variable is price (1978 dollars). Columns (1) and (2) report estimates of \(\beta\) from equation (\ref{eqn:model}) for domestic automobiles. Columns (3) and (4) report estimates for foreign automobiles. Robust standard errors are reported in parentheses. A */**/*** indicates significance at the 10/5/1\% levels."
texsave using "$MyProject/results/tables/my_regressions.tex", autonumber varlabels hlines(-2) nofix replace marker(tab:my_regressions) title("`title'") headerlines("`headerlines'") footnote("`fn'")
preserve


***************************
* Create regression table: R *
***************************
if "$DisableR"!="1" {
tempfile my_table_r
use "$MyProject/results/intermediate/my_lm_regressions.dta", clear

ren term var
ren estimate coef
ren std_error stderr
ren p_value pval
drop statistic conf* df outcome

* Merge together the four regressions into one table
local run_no = 1
local replace replace
foreach orig in "Domestic" "Foreign" {
	foreach rhs in "mpg" "mpg weight" {
		
		regsave_tbl using "`my_table_r'" if origin=="`orig'" & rhs=="`rhs'", name(col`run_no') asterisk(10 5 1) parentheses(stderr) sigfig(3) `replace'
		
		local run_no = `run_no'+1
		local replace append
	}
}
	
* Format the table
use "`my_table_r'", clear
drop if inlist(var,"_id","rhs","origin") | strpos(var,"(Intercept)") | strpos(var,"tstat") | strpos(var,"pval")

label var col1 "Spec 1"
label var col2 "Spec 2"
label var col3 "Spec 1"
label var col4 "Spec 2"

replace var = "\(R^2\)" if var=="r2"
replace var = subinstr(var,"_coef","",1)
replace var = "" if strpos(var,"_stderr")

* Append to prior table, reformat, and output
save "`my_table_r'", replace
restore
append using "`my_table_r'"
drop if var=="N" | strpos(var,"R^2")
ingap 1 5

replace var = "A. Stata output (regress)" in 1 if mi(var)
replace var = "B. R output (lm\_robust)" in 6 if mi(var)

* Run Stata program (stored in /functions)
clean_vars var

* Same output as previous table above, so reuse the same footnote and headerlines
local title "Association between automobile price and fuel efficiency, Stata and R"
texsave using "$MyProject/results/tables/my_regressions_with_r.tex", autonumber varlabels hlines(1 6) nofix replace marker(tab:my_regressions_with_r) title("`title'") headerlines("`headerlines'") footnote("`fn'") bold("A." "B.")
}


** EOF
