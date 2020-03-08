************
* PROGRAM: clean_vars.ado
* PURPOSE: formats the names of the variables reported in the tables
************

program define clean_vars, nclass

	* Program input: varname that contains the variable names
	syntax varname

	replace `varlist' = "Miles per gallon" if `varlist'=="mpg"
	replace `varlist' = "Weight (pounds)" if `varlist'=="weight"
	replace `varlist' = "Price (1978 dollars)" if `varlist'=="price"
  
end

** EOF
