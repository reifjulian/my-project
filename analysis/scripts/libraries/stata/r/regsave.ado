*! regsave 1.4.9 4mar2021 by Julian Reif
* 1.4.9: fixed minor bug when N was stored as non-integer
* 1.4.8: added rtable option.
* 1.4.7: fixed bug that caused large scalars outside the normal integer range to be stored as missing, when using the detail() option.
* 1.4.6: N stored as double/long for large datasets.
* 1.4.5: added sigfig() option. Edited df() option to allow missing.
* 1.4.4: fixed bug when saving a table to a folder names with space
* 1.4.3: fixed bug with blank addlabels
* 1.4.2: added saveold option
* 1.4.1: default set to e(b_mi) and e(v_mi) when using -mi estimate- without the post suboption
* 1.4  : allnumeric is now correctly set to "allnumeric" in the case where the addlabel options include only numeric labels. Updated autoid option. (These only affects table suboptions)
* 1.3.9: fixed rreturn bug
* 1.3.8: fixed addlabel bug
* 1.3.7: fixed bug where tsvarnames weren't allowed with covar option
* 1.3.6: make label a missing value when user specifies "." instead of a string
* 1.3.5: added better support for tsvarlists
* 1.3.4: minor bug fix for asterisks. Issue macro truncation warning.
* 1.3.3: fixed bug related to when df is not available
* 1.3.2: added df option and fixed Stata 8 related bugs
* 1.3.1: added autoid option
* 1.3:   added support for factor variables. Fixed wildard bug.
* 1.2.8: added support for confidence intervals
* 1.2.7: added backwards compatability for Stata 8.2
* 1.2.6: order() option now applies to appending datasets and doesn't require a namelist
* 1.2.5: asterisk() option now allows you to specify signficance levels
* 1.2.4: coefmat and varmat options now allow matrices that aren't e-class. Fixed ts varname bug.
* 1.2.3: added coefmat and varmat options. New defaults for dprobit.
* 1.2.2: fixed bug with -using- and wildcards
* 1.2.1: wildcards allowed now
* 1.2:   changed syntax for table options, and put table code into separate module (regsave_tbl). Added asterisk option.
* 1.1.3: added support for ts varnames and improved formatting code
* 1.1.2: added support for equation names for e(b) and e(V)
* 1.1.1: addlabel now stores "" instead of "," if no label is present
* 1.1:   table option now requires column name and creates only one column. nose, order, format, cmdline, bracket and parentheses options added.

program define regsave, rclass
	version 8.2
	syntax [anything] [using/] [, Tstat Pval ci Level(real $S_level) noSE CMDline autoid covar(string) detail(name min=1) double ADDLABel(string asis) addvar(string) table(string) coefmat(string) varmat(string) rtable df(numlist min=1 max=1 >0 missingokay) append replace saveold(numlist integer min=1 max=1 >=11)]
				
	* Hold onto using filename in case it gets reset by further syntax commands
	local hold_using `"`using'"'
	
	* Unabbreviate varnames if wildcards are specified (we can't use -varlist- above in -syntax- because some specified regressors may not actually be vars, e.g., _cons)
	foreach input in anything covar {
		if strpos(`"``input''"',"*")!=0 | strpos(`"``input''"',"~")!=0 | strpos(`"``input''"',"?")!=0 | strpos(`"``input''"',"-")!=0 | strpos(`"``input''"',".")!=0{

			tokenize `"``input''"'
			while `"`1'"' != "" {
				if strpos(`"`1'"',"*")!=0 | strpos(`"`1'"',"~")!=0 | strpos(`"`1'"',"?")!=0 | strpos(`"`1'"',"-")!=0 | strpos(`"`1'"',".")!=0 {
					local 0 `"`1'"'
					cap syntax varlist(ts)
					if !_rc local `input' : subinstr local `input' "`1'" "`varlist'"
				}
				macro shift
			}
			local using `"`hold_using'"'
		}
	}
	
	* Saveold options, if specified
	local save save
	local saveold_opts ""
	if "`saveold'"!="" {
		local save "saveold"
		local saveold_opts "version(`saveold')"
		
		* Reuse in regsave_tbl subcommand:
		local sv_old "saveold(`saveold')"
	}
	
	* Apply namelist parsing syntax to anything, correcting for ts and fv varnames.  (-syntax namelist- doesn't have a ts or fv option unfortunately)
	* orig_namelist holds unchanged names, so it includes time series operators etc.
	local orig_namelist `"`anything'"' 
	
	* Table suboptions
	if "`table'"!= "" {
						
		local 0 `"`table'"'
		local tbl_command `"`0'"'
		syntax namelist(max=1) [, order(string) format(string) sigfig(numlist integer min=1 max=1 >=1 <=16) PARENtheses(namelist max=4) BRACKets(namelist max=4) *]
		local table `"`namelist'"'
		
		local 0 `", `options'"'
		syntax [, ASTERisk(numlist descending integer min=0 max=3 >=0 <=100)]
		
		* Detect if the asterisk option was specified; set defaults if significance levels were not specified by user
		local aster_defaults "10 5 1"
		if "`asterisk'"!="" local asterisk "asterisk(`asterisk')"
		if strpos(`"`0'"',"aster")!=0  & `"`asterisk'"'=="" local asterisk "asterisk(`aster_defaults')"
		
		* Asterisk option not allowed with nose, no pval, no tstat
		if "`asterisk'"!="" & "`pval'`tstat'"=="" & "`se'"!="" {
			di as error "Asterisk option requires presence of standard errors, pvals, or tstats"
			exit 198					
		}
	}
	
	local using `"`hold_using'"'

	**********************************
	* Error check option selections  *
	**********************************
	* File options
	if "`append'`replace'`sv_old'"!="" & "`using'"=="" {
		di as error "Must specify a filename with `append'`replace' `sv_old'"
		exit 198
	}
	
	* CI options
	if `level' < 10 | `level' > 99.99 {
		di as error "level() must be between 10 and 99.99 inclusive"
		exit 198
	}

	* Detail options
	if !inlist(`"`detail'"',"all","scalars","macros","") {
		di as error `"The only valid choices for the detail option are "all", "scalars", or "macros""'
		exit 198		
	}
	
	* dprobit has a special default for coefmat and varmat
	if `"`e(cmd)'"'=="dprobit" & "`coefmat'"=="" local coefmat "e(dfdx)"
	if `"`e(cmd)'"'=="dprobit" & "`varmat'"=="" local varmat "e(se_dfdx)"

	* mi estimate has a special default, if post suboption is not specified
	if `"`e(cmd)'"'=="mi estimate" & "`coefmat'"=="" local coefmat "e(b_mi)"
	if `"`e(cmd)'"'=="mi estimate" & "`varmat'"=="" local varmat "e(V_mi)"
		
	* If rtable option specified, then use that as the default for coef, var, t, p, and ci.
	if "`rtable'"!="" {
	
		if "`coefmat'`varmat'`covar'"!="" {
			di as error "Cannot specify the rtable option together with coefmat, varmat, or covar options"
			exit 198			
		}
		
		tempname rtablemat rtable_coefmat rtable_semat rtable_tmat rtable_pvalmat rtable_llmat rtable_ulmat
		confirm matrix r(table)
		matrix `rtablemat' = r(table)
		
		matrix `rtable_coefmat' = `rtablemat'["b",.]
		matrix `rtable_semat' = `rtablemat'["se",.]
		
		* some commands report t-stats, others report z-stats
		cap    matrix `rtable_tmat' = `rtablemat'["t",.]
		if _rc matrix `rtable_tmat' = `rtablemat'["z",.]
		
		if "`pval'"!="" matrix `rtable_pvalmat' = `rtablemat'["pvalue",.]
		if "`ci'"!="" matrix `rtable_llmat' = `rtablemat'["ll",.]
		if "`ci'"!="" matrix `rtable_ulmat' = `rtablemat'["ul",.]
		
		local coefmat "`rtable_coefmat'"
		local varmat "`rtable_semat'"
	}
	
	* Else, the coefmat, varmat, and df defaults are e(b), e(V), and e(df_r)
	if "`coefmat'"=="" local coefmat "e(b)"
	if "`varmat'"=="" local varmat "e(V)"
	if "`df'"=="" local df = e(df_r)
	
	confirm matrix `coefmat'
	confirm matrix `varmat'
	
	* Order and format options
	if "`format'" != "" { 
		if strpos("`format'", "s")!=0 { 
			di as err "use numeric format in format() option" 
			exit 198 
		} 	
		capture di `format' 12345.67890
		if _rc {
			di as err "format() option invalid"
			exit 198
		}
	}
	
	* sigfig not allowed with format option
	if "`sigfig'"!="" & "`format'"!=""  {
		di as error "Cannot specify both the sigfig and format options"
		exit 198					
	}	
	
	* Parentheses and bracket options
	foreach option in parentheses brackets {
		if "``option''"!="" {
			tokenize "``option''"
			while "`1'" != "" {
				if !inlist("`1'","coef","stderr","tstat","pval","ci_upper","ci_lower") {
					di as error "`1' is not a valid section for `option'"
					exit 198
				}
				macro shift
			}
		}
	}
	
	* set more off if not already
	local more_setting `c(more)'
	set more off
	
	**********************************
	* Store results			  		 *
	**********************************

	* Preserve if user is saving to a file
	if "`using'" != "" preserve

	* Grab point estimates
	tempname coef covars vars temp
	matrix `coef' = `coefmat'
	
	* Grab standard errors/variances and covars
	matrix `vars' = `varmat'
	if rowsof(`vars')==1 {		
		if "`covar'"!="" {
			di as error `"covar() is not a valid option because `varmat' does not contain covariances"'
			exit 198		
		}
	}
	else {
		matrix `covars' = `varmat'
		if "`rtable'"=="" matrix `vars' = vecdiag(`covars')
	}
	
	* Grab varnames. Check for the case where we have equation names (happens with, for example, the heckman command)
	local matnames : colfullnames `coef'
	if strpos(`"`matnames'"',":")!=0 local eqnames = 1

	* Error check that names supplied by the user are valid, but don't worry about eqnames here.  Note that matrices store "L1." as "L."; same with F and S.
	local matnames_nmchk : colnames `coef'
	local matnames_nmchk : subinstr local matnames_nmchk ":" "_", all
	local orig_namelist : subinstr local orig_namelist "L1." "L."
	local orig_namelist : subinstr local orig_namelist "F1." "F."
	local orig_namelist : subinstr local orig_namelist "S1." "S."
	
	foreach var in `orig_namelist' `covar' {
				
		local match = 0
		foreach nm of local matnames_nmchk {
			if "`var'"=="`nm'" {
				local match = 1
			}
		}
		if `match'==0 {
			di as error "No estimation results available for variable `var'"
			exit 111
		}
		
		if "`var'"=="_id" & "`autoid'"!="" {
			di as error "Cannot specify autoid option when also retrieving estimates for a variable called {it:_id}"
			exit 198			
		}
	}
	
	* Save estimation results into dataset, and take the square root of variances (if variances, not se's, are reported)
	drop _all
	label drop _all
	matrix `coef' = `coef''	
	matrix `vars' = `vars''	
	cap svmat `double' `coef'
	cap svmat `double' `vars'
	ren `vars'1 stderr
	ren `coef'1 coef
	if strpos("`varmat'","se")==0 & "`rtable'"=="" qui replace stderr = sqrt(stderr) // Assumes that r(table) reports std errors, and that a user-specified varmat with "se" in its name reports std errors

	* Gen varname variable
	qui gen var = ""
	local row = 1
	foreach nm of local matnames {
		qui replace var = "`nm'" in `row'
		local row = `row'+1
	}

	* Grab covariances, if specified
	foreach v of local covar {
		local num_rows = rowsof(`covars')
		cap matrix `temp' = `covars'[1..`num_rows',"`v'"]
		if _rc!= 0 {
			if _rc==111 di as error "`v' is not a valid regressor"
			exit _rc
		}
		local covar_nm : subinstr local v "." "", all
		cap svmat `double' `temp', names(`covar_nm')
		qui ren `covar_nm'1 covar_`covar_nm'

	}
	
	***
	* tstat, p-vals, and ci if specified
	***
	* Method 1. Obtain from r(table), if specified by user
	if "`rtable'"!="" {

		if "`tstat'"!="" {
			matrix `rtable_tmat' = `rtable_tmat''
			svmat `double' `rtable_tmat'
			ren `rtable_tmat'1 tstat
		}
		
		if "`pval'"!="" {
			matrix `rtable_pvalmat' = `rtable_pvalmat''
			svmat `double' `rtable_pvalmat'
			ren `rtable_pvalmat'1 pval		
		}

		if "`ci'"!="" {
			matrix `rtable_llmat' = `rtable_llmat''
			svmat `double' `rtable_llmat'
			ren `rtable_llmat'1 ci_lower		
			
			matrix `rtable_ulmat' = `rtable_ulmat''
			svmat `double' `rtable_ulmat'
			ren `rtable_ulmat'1 ci_upper				
		}	
	}

	* Method 2. Else obtain from e(b) and e(V)
	else {
		qui gen `double' tstat = coef/stderr
		if `level'<0 local cilevel = `c(level)'
		else local cilevel = `level'

		if "`pval'`ci'"!="" {
			if "`df'"=="." {
				qui gen `double' pval = 2*(1-normprob(abs(tstat)))
				qui gen `double' t_ci = invnorm(1-(1-`cilevel'/100)/2)
			}
			else {
				qui gen `double' pval = tprob(`df', abs(tstat))
				qui gen `double' t_ci = abs(invttail(`df', (1-`cilevel' /100)/2))
			}
		}
		if "`ci'"!="" {
			qui gen `double' ci_lower = coef - t_ci*stderr
			qui gen `double' ci_upper = coef + t_ci*stderr
		}
		cap drop t_ci
	}
	
	
	if "`pval'"=="" cap drop pval
	if "`tstat'"=="" cap drop tstat
	if "`se'"!="" drop stderr
	else local stderr stderr	

	* Addvar option
	tempname _keep
	qui gen byte `_keep'=0
	if `"`addvar'"'!="" {
		
		tokenize `"`addvar'"', parse(",")
		while "`1'" != "" {

			if "`1'"=="," {
				di as error "Invalid syntax for addvar()"
				exit 198
			}
			
			* Increase obs by one
			local row_num = _N+1
			qui set obs `row_num'

			* Varname
			qui cap replace var = "`1'" in `row_num'
			if "`1'"!="," macro shift
			if "`1'"=="," macro shift
			
			* Coef
			qui cap replace coef = `1' in `row_num'
			if "`1'"!="," macro shift
			if "`1'"=="," macro shift
			
			* std error
			qui cap replace stderr = `1' in `row_num'
			if "`1'"!="," macro shift
			macro shift
			
			* Make sure observation is not dropped
			qui replace `_keep' = 1 in `row_num'
		}
	}

	* Keep only specified variables
	if "`orig_namelist'"!="" {
		foreach var of local orig_namelist {
			if "`eqnames'"=="" qui replace `_keep'=1 if var=="`var'"
			else qui replace `_keep'=1 if strpos(var,"`var'")!=0 // eqnames are stored as eqname:var
		}
		qui keep if `_keep'==1
	}
	qui drop `_keep'
	
	
	**********************************
	* Fill in remaining data		 *
	**********************************


	* N, R^2, and regression command. Always store N as a double, to avoid rounding issues with big data.
	* Note: sometimes commands like ivregress incorrectly report N as a non-integer, and it get stored as such when in double format.
	qui if e(N)!=. {
		gen double N = e(N)
		if abs(round(N)-N)<c(epsfloat) replace N = round(N)
	}
	if e(r2)!=. qui gen `double' r2 = e(r2)
	if `"`e(cmdline)'"'!="" & "`cmdline'"!="" {
		qui gen cmdline = `"`e(cmdline)'"'
	}
	
	* Detailed statistics
	if "`detail'"!="" {
		
		* Scalars
		if "`detail'"=="all" | "`detail'"=="scalars" {
			local scalar_vars : e(scalars)
			foreach v of local scalar_vars {
				capture confirm integer number `e(`v')'
				if _rc==0 & inrange(`e(`v')', -32767, 32740) qui cap gen int `v' = e(`v')
				else qui cap gen `double' `v' = e(`v')
			}
		}
		
		* Macros
		if "`detail'"=="all" | "`detail'"=="macros" {
			local macro_vars : e(macros)
			foreach v of local macro_vars {
				qui cap gen `v' = `"`e(`v')'"'
			}
		}
	}
	
	* autoid
	local autoid_default = -99987
	if "`autoid'"!="" {
		if "`append'" == "" qui gen _id = 1
		else qui gen _id = `autoid_default'
		cap label var _id "Regression ID number"
	}
	
	
	* Data are allnumeric by default unless parentheses etc. are specified. Also, allnumeric is turned off in the label loop below if at least one of the labels are string.
	local allnumeric allnumeric
	if "`detail'`parentheses'`brackets'`cmdline'`asterisk'"!="" local allnumeric

	* Label option
	tokenize `"`addlabel'"', parse(",")
	local i = 1
	while "``i''" != "" {
		
		* Certain labelnames are not allowed
		if inlist(`"``i''"',"if","in") {
			di as error `"``i'' is an invalid name for a label"'
			exit 198
		}
		
		* Get varname, fix Stata 8 compatibility issue
		if substr("`c(version)'",1,2)=="8." confirm new variable ``i''
		else confirm new variable ``i'', exact
		cap confirm name ``i''
		if _rc {
			di as error "Invalid variable name specified for addlabel()"
			exit 198
		}
		local varname = "``i''"
		
		* Advance forward two spots, so index points to data contents.
		if "``i''"!="," local i = `i'+1
		if "``i''"=="," local i = `i'+1
		
		* Get data and generate new var. If label is '.' make it a number
		capture confirm number ``i''
		if _rc==0 | `"`=trim("``i''")'"'=="." qui gen `double' `varname' = ``i''
		else {
			* If user inputted a blank, ``i'' holds a comma, so fix that
			if "``i''"=="," qui gen `varname' = ""
			else qui gen `varname' = "``i''"
			local allnumeric
		}
		if "``i''"!="," local i = `i'+1
		local i = `i'+1
	}

	qui compress
	
	* Convert data to table format, if specified
	if "`table'"!="" {
				
		* Grab passthru values (asterisk option was handled separately up above)
		local 0 `"`tbl_command'"'
		syntax namelist(max=1) [, order(passthru) format(passthru) sigfig(passthru) PARENtheses(passthru) BRACKets(passthru) *]
		if `"`hold_using'"'!= "" local using `"using "`hold_using'""'
		
		* Create table		
		regsave_tbl `using', name("`table'") `order' `format' `sigfig' `parentheses' `brackets' `asterisk' `allnumeric' `append' `replace' df(`df') `autoid' `sv_old'
		
		* Restore using val (it is reset by the syntax command above)
		local using `"`hold_using'"'		
	}
	

	**********************************
	* Label vars and clean up		 *
	**********************************


	* Label vars
	cap label var var "Variable"
	cap label var coef "Coefficient"
	cap label var stderr "Standard error"
	cap label var tstat "t-statistic"
	cap label var pval "Two-tailed p-value"
	cap label var N "Number of observations"
	cap label var r2 "R-squared"
	cap label var r2_a "Adjusted R-squared"
	cap label var cmdline "Estimation command code"
	cap label var df_m "Model degrees of freedom"
	cap label var df_r "Residual degrees of freedom"
	cap label var F "F statistic"
	cap label var rmse "Root mean squared error"
	cap label var rss "Residual sum of squares"
	cap label var mss "Model sum of squares"
	cap label var ll "Log likelihood"
	cap label var ll_0 "Log likelihood, constant only model"
	cap label var model "Model name"
	cap label var vce "Variance-covariance estimation type"
	cap label var N_clust "Number of clusters"
	cap label var chi2 "Chi-squared"
	cap label var r2_p "Pseudo-R-squared"
	cap label var N_cdf "Number of completely determined successes"
	cap label var N_cds "Number of completely determined failures"
	cap label var chi2type "Type of model chi-squared test"
	cap label var ci_lower "`level'% confidence interval (lower bound)"
	cap label var ci_upper "`level'% confidence interval (upper bound)"

	* Save results if specified (regsave_tbl has already saved results if that code was run, so we need to only take care of non-table situations)
	cap order var
	qui compress
	if "`using'"!= "" & "`table'"=="" {
		if "`append'"!= "" {
				append using "`using'"
				local replace replace
				
				* Generate autoid identifier
				if "`autoid'"!="" {
					qui summ _id
					if `r(max)'< 0 qui replace _id = 1 if _id == `autoid_default'
					else qui replace _id = `r(max)'+1 if _id == `autoid_default'
				}
		}
		`save' "`using'", `replace' `saveold_opts'
	}
	
	* Return shape of new dataset
	return clear
	qui count
	return scalar N = `r(N)'
	unab all_vars : *
	local num_vars : word count `all_vars'
	return scalar k = `num_vars'	
	
	* Restore data, and set more back on if it was on before
	if "`using'" != "" restore
	set more `more_setting'

end

** EOF
