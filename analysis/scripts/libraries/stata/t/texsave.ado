*! texsave 1.5 2nov2020 by Julian Reif 
* 1.5: added decimalalign option
* 1.4.6: added label option (replaces marker function, which is now deprecated)
* 1.4.5: added new endash option (enabled by default)
* 1.4.4: added headersep() option
* 1.4.3: width default changed from \textwidth to \linewidth, to improve landscape tables. Added addlinespace() as footnote suboption. Changed default to \addlinespace[\belowrulesep]
* 1.4.2: added preamble option.
* 1.4.1: added footnote width option.
* 1.4: geometry package now required. footnote parameters edited. landscape and geometry options added.
* 1.3.3: -fix- option now also corrects "_" in column names
* 1.3.2: make -autonumber- option stack with, rather than replace, column names.
* 1.3.1: hlines now allows negative numbers
* 1.3: booktabs and tabularx packages now required. 'H' allowed as location option (for subfig package). Headerlines option now enabled when nonames option is requested. Fixed hlines bug when numlist was unsorted. SW options turned off by default.
* 1.2.2: added headerlines option
* 1.2.1: added extra space after \hline to make tables look nicer. Added -rowsep- option to set row height spacing.
* 1.2: added booktab package and formatting options.
* 1.1.1: changed default align option to 8cm (so SWP will no longer error on this).
* 1.1: new hlines, autonumber options, and footnotes suboptions.  Added '&' to badchar list. Align option now allows any table spec argument.
* 1.0.3: integer values now allowed for size option
* 1.0.2: added size option
* 1.0.1: added location option

program define texsave, nclass
	version 10

	syntax [varlist] using/ [if] [in] [, noNAMES SW noFIX noENDASH title(string) DELIMITer(string) footnote(string asis) headerlines(string asis) headlines(string asis) preamble(string asis) footlines(string asis) frag align(string) LOCation(string) size(string) width(string) marker(string) label(string) bold(string) italics(string) underline(string) slanted(string) smallcaps(string) sansserif(string) monospace(string) emphasis(string) VARLABels hlines(numlist) autonumber rowsep(string) headersep(string) LANDscape GEOmetry(string) DECIMALalign replace]

	* Check if appendfile is installed
	cap appendfile
	if _rc==199 {
		di as error "appendfile not installed. Type -ssc install appendfile-"
		exit _rc
	}
	
	* nonames cannot be specified together with varlabels
	if "`varlabels'"!="" & "`names'"!="" {
		di as error "option varlabels not allowed with option nonames"
		exit 198
	}

	
	* Error check hlines
	if "`hlines'"!="" {
		numlist "`hlines'", integer sort
		local hlines "`r(numlist)'"
		local num_hlines : word count `hlines'
		local max : word `num_hlines' of `hlines'
		local min : word 1 of `hlines'
		qui count `if' `in'
		local num_rows = `r(N)'
		if `num_rows' < abs(`max') | `num_rows' < abs(`min') {
			di as error "hlines() cannot cannot include values larger than `r(N)', the size of the table"
			exit 198
		}
		
		* Any negative numbers are interpreted as coming from the bottom of the table
		local tmp_hlines
		foreach v of local hlines {
			local tmp = `v'
			if `tmp' < 0 local tmp =`num_rows'+`tmp'
			local tmp_hlines "`tmp_hlines' `tmp'"
		}
		local hlines "`tmp_hlines'"
		numlist "`hlines'", integer sort
		local hlines "`r(numlist)'"
	}
	
	* Define a horizontal line
	local horiz_line "\midrule"
	
	* Define row and header separation spacing if applicable. (rowsep uses "\BS" since it is implemented via filefilter)
	if `"`rowsep'"'!="" local rowsep `" \BSaddlinespace[`rowsep']"'
	
	if `"`headersep'"'!="" local headersep `" \addlinespace[`headersep']"'
	else local headersep `" \addlinespace[\belowrulesep]"'
	
	* Append .tex extension if no extension present
	if strpos(`"`using'"',".") == 0 local using `"`using'.tex"'

	* Get number of vars/columns
	local num_vars : word count `varlist'
	
	* Label option overloads the marker option
	if !mi(`"`label'"') {
		if !mi(`"`marker'"') {
			di as error "Cannot specify both the label and marker options"
			exit 198	
		}
		local marker `"`label'"'
	}

	* Error check the location option.  Set default to "tbp"
	if `"`location'"'!="" {
		* Only allowed chracters are 'H', 'h', 't', 'b', 'p' and ' ' (blank)
		local location: subinstr local location " " "", all
		forval x = 1/`=length(`"`location'"')' {
			local char = substr(`"`location'"',`x',1)
			if !inlist(`"`char'"', "h", "t", "b", "p", "H") {
				di as error "location() option contains invalid characters"
				exit 198
			}
		}		
	}
	else local location "tbp"
	
	* Set table width
	if "`width'"=="" local width "\linewidth"
	
	* Set default values for delimiter.  Determine what the end-of-line character is for the machine (needed for filefilter command below)
	if `"`delimiter'"'=="" local delimiter "&"
	if "`c(os)'" == "MacOSX" {
		if "`c(eolchar)'"=="mac" local eol_char = "\M"
		else local eol_char = "\U"
	}
	else if "`c(os)'" == "Windows" local eol_char = "\W"
	else local eol_char = "\U"
	
	*****************************
	***** FOOTNOTE OPTIONS   ****
	*****************************
	
	* Pull out footnotesize and footnote width options if specified. Save the options that apply to the table so they don't get overwritten here.
	foreach v in using size width varlist if in {
		local hold_`v' `"``v''"'
	}
	local 0 `"`footnote'"'	
	gettoken footnote 0 : 0, parse(,)
		cap syntax, [size(string) width(string) addlinespace(string)] 
		if _rc!=0 {
			di as error "Invalid syntax for footnote() option"
			exit 198
		}
	local footnotesize `"`size'"'
	local footnotewidth `"`width'"'
	foreach v in using size width varlist if in {
		local `v' `"`hold_`v''"'
	}
	
	* Footnote spacing option. Default (no footnote) is blank. Default (footnote, user did not specify spacing) is \belowrulesep (suggestion by booktabs package)
	* http://mirror.utexas.edu/ctan/macros/latex/contrib/booktabs/booktabs.pdf
	if `"`footnote'"'!=""                          local footnotespace  "\addlinespace[\belowrulesep]"
	if `"`footnote'"'!="" & `"`addlinespace'"'!="" local footnotespace `"\addlinespace[`addlinespace']"'
		
	* Error check the size and footnotesize options. Set default for footnotesize.
	if "`footnotesize'"=="" local footnotesize "footnotesize"

	foreach opt in "size" "footnotesize" {
		if "``opt''"!="" {

			* If size number is given...
			cap confirm integer number ``opt''
			if _rc == 0 {
				if ``opt''>10 | ``opt''<1 {
					di as error "`opt'() value must be between 1 and 10"
					exit 198				
				}
				if ``opt''==1 local size2 "tiny"
				if ``opt''==2 local size2 "scriptsize"
				if ``opt''==3 local size2 "footnotesize"
				if ``opt''==4 local size2 "small"
				if ``opt''==5 local size2 "normalsize"
				if ``opt''==6 local size2 "large"
				if ``opt''==7 local size2 "Large"
				if ``opt''==8 local size2 "LARGE"
				if ``opt''==9 local size2 "huge"
				if ``opt''==10 local size2 "Huge"
				assert "`size2'"!=""
				local `opt' "`size2'"
			}
		
			* Else user specified string
			else {
				if !inlist(`"``opt''"', "tiny","scriptsize","footnotesize","small","normalsize","large","Large","LARGE","huge") & "`size'"!="Huge" {
					di as error "``opt'' is an invalid option for `opt'()"
					exit 198
				}
			}
		}
	}
	
	*****************************
	** Table column alignment  **
	*****************************

	* Default is to have first column left-justified and the rest centered.
	if `"`align'"'=="" {
		local align "l"
		forval x = 2/`num_vars' {
			if "`decimalalign'"!="" local align "`align'S"
			else local align "`align'C"
		}
	}


	*****************************
	** 		  HEADER   **
	*****************************

	* Headerlines (user-specified code)
	if `"`headerlines'"' != "" {
		tokenize `"`headerlines'"'
		while `"`1'"' != "" {
			local header_headerlines `"`header_headerlines' \tabularnewline `1'"'
			macro shift
		}		
		* Strip out the first \tabularnewline
		local header_headerlines : subinstr local header_headerlines `" \tabularnewline "' ""
		local header_headerlines `"`header_headerlines' \tabularnewline"'
	}

	* Autonumber - no number in the first column
	if "`autonumber'"!="" {
		local run_no = 1
		foreach v of local varlist {
			if `run_no'>1  local header_autonumber `"`header_autonumber'`delimiter'{(`=`run_no'-1')}"'
			local run_no = `run_no'+1
		}
		local header_autonumber `"`header_autonumber' \tabularnewline"'
		
		* If variable names are also being written out, add an additional horizontal line
		if "`names'"=="" local header_autonumber `"`header_autonumber' `horiz_line'"'
	}
	
	* Column names (either varlabels or Stata column names) - don't write these out if user specifies -nonames-
	if "`names'"=="" {
		foreach v of local varlist {
			if "`varlabels'"!="" {
				local lbl : variable label `v'
				local header_colnames `"`header_colnames'`delimiter'{`lbl'}"'
			}
			else local header_colnames `"`header_colnames'`delimiter'{`v'}"'	
		}		
		* Strip out the first delimiter
		local header_colnames : subinstr local header_colnames `"`delimiter'"' ""
		local header_colnames `"`header_colnames' \tabularnewline"'
	}

	*****
	* Correct chars that cause problems in LaTeX; add bold, italics, underline etc. tags as necessary
	*****
	
	* Header, title, and footer corrections
	if "`fix'"=="" {		
		
		foreach str in "header_colnames" "footnote" "title" {
		    
			* Note: $ substitution here does not work
			foreach symbol in _ % # $ & ~ {
				if "`str'"=="header_colnames" & "`symbol'"=="&" continue				// Allow &'s in headers since they are delimiters
				local `str' : subinstr local `str' `"`symbol'"' `"\\`symbol'"', all
			}
			
			* We have braces in the header sometimes so skip that one
			if "`str'"!="header_colnames" local `str' : subinstr local `str' "{" `"\{"', all
			if "`str'"!="header_colnames" local `str' : subinstr local `str' "}" "\}", all
			
			* '^' is handled specially
			local `str' : subinstr local `str' `"^"' `"\^{}"', all
		}
	}
	
	* Dataset corrections
	if "`fix'"=="" | "`endash'"=="" | `"`bold'`italics'`underline'`slanted'`smallcaps'`sansserif'`monospace'`emphasis'"'!="" | "`decimalalign'"!="" {
		
		tempvar index_neg isreal
		local renamed = "yes"
		
		* Variables - create new temporary ones that have bad chars stripped out of them and are formatted as specified by user
		foreach v of local varlist {
			tempname `v'temp
			qui ren `v' ``v'temp'
			qui gen `v' = ``v'temp'
			
			capture confirm string var `v'
			if _rc==0 {
								
				* Fix problematic symbols 
				if "`fix'"=="" {
					foreach symbol in _ % # $ & ~ {
						qui replace `v' = subinstr(`v',"`symbol'","\\`symbol'",.)
					}
					qui replace `v' = subinstr(`v',"{","\{",.)
					qui replace `v' = subinstr(`v',"}","\}",.)
					qui replace `v' = subinstr(`v',"^","\^{}",.)
				}
				
				* Reformat negative signs from "-" to "--" (en-dash), unless decimalalign option is specified
				* Only reformat negative signs if they are followed by a number and not preceded by an alphabetic character or negative sign
				if "`endash'"=="" & "`decimalalign'"=="" {
				    qui gen `index_neg' = strpos(`v',"-")
					qui replace `v' = subinstr(`v',"-","--",1) if real(substr(`v',`index_neg'+1,1))!=. & regexm(substr(`v',`index_neg'-1,1),"[A-Za-z\-]")!=1
					drop `index_neg'
				}
				
				* Formatting options
				local tex_code "\textbf{ \textit{ \underline{ \textsl{ \textsc{ \textsf{ \texttt{ \emph{"
				local run_no = 1
				foreach opt in bold italics underline slanted smallcaps sansserif monospace emphasis {
					
					local command : word `run_no' of `tex_code'
					
					tokenize `"``opt''"'
					while `"`1'"' != "" {
						qui replace `v' = "`command'" + `v' + "}" if strpos(`v',`"`1'"')!=0
						macro shift
					}
					
					local run_no = `run_no'+1
				}
				
				* For decimalalign option, when variable is a formatted string, surround text data with "{...}" but not numeric data
				if "`decimalalign'"!="" {
					qui gen `isreal' = real(`v')
					replace `v' = "{" + `v' + "}" if mi(`isreal')
					drop `isreal'
				}
			}			
		}
	}

	******
	** Open the file
	******
	tempfile data1 data2 end_file
	tempname fh
	qui file open `fh' using "`using'", write `replace'

	******
	** Table start
	******
	if "`frag'" == "" {
		file write `fh' "\documentclass{article}" _n
		file write `fh' "\usepackage{booktabs}" _n
		file write `fh' "\usepackage{tabularx}" _n
		file write `fh' "\usepackage[margin=1in]{geometry}" _n
		if "`landscape'"!=""    file write `fh' "\usepackage{pdflscape}" _n
		if "`decimalalign'"!="" file write `fh' "\usepackage{siunitx}" _n
	}
	* Preamble option. This is always outputted, whether or not frag option is specified
	if `"`preamble'"' != "" {
		tokenize `"`preamble'"'
		while `"`1'"' != "" {
			file write `fh' `"`1'"' _n
			macro shift
		}
	}	
	if "`frag'" == "" file write `fh' "\begin{document}" _n(2)
	
	if "`landscape'"!="" file write `fh' "\begin{landscape}" _n
	if `"`geometry'"'!="" file write `fh' `"\newgeometry{`geometry'}"' _n
	
	* Headlines option
	if `"`headlines'"' != "" {
		tokenize `"`headlines'"'
		while `"`1'"' != "" {
			file write `fh' `"`1'"' _n
			macro shift
		}
	}
	
		if "`sw'"!="" file write `fh' "%TCIMACRO{\TeXButton{B}{\begin{table}[`location'] \centering}}" _n
		if "`sw'"!="" file write `fh' "%BeginExpansion" _n
	file write `fh' "\begin{table}[`location'] \centering" _n
	file write `fh' "\newcolumntype{C}{>{\centering\arraybackslash}X}" _n(2)
		if "`sw'"!="" file write `fh' "%EndExpansion" _n
	if `"`title'"'!="" file write `fh' `"\caption{`title'}"' _n
	if `"`marker'"'!="" file write `fh' `"\label{`marker'}"' _n
	if `"`size'"'!="" file write `fh' `"{\\`size'"' _n
	file write `fh' "\begin{tabularx}{`width'}{`align'}" _n(2)

	* Create double-line or thick line, depending on booktabs
	file write `fh' "\toprule" _n
	
	
	********
	** Header, if specified. headerlines, autonumber, and colnames all stack together
	********
	
	if "`autonumber'"!="" 		    qui file write `fh' "`header_autonumber'" _n
	if `"`header_headerlines'"'!="" qui file write `fh' "`header_headerlines'" _n
	if "`header_colnames'"!=""	    qui file write `fh' "`header_colnames'" _n

	* Only write out a horizontal line if there is a header	
	if `"`header_headerlines'`autonumber'`header_colnames'"'!="" qui file write `fh' "`horiz_line'`headersep'" _n
	file close `fh'
	
	*********
	** Data
	*********
	* If hlines() option is specified, need to split up dataset and insert hlines
	if "`hlines'"!="" {
		tempvar dummy rownum touse
		tempfile tmp
		
		qui gen byte `touse' = 1 `if' `in'
		qui replace `touse' = 0 if mi(`touse')

		* Generate table rownumbers
		qui gen byte `dummy' = 1
		qui gen `rownum' = sum(`dummy') `if' `in'

		* Outsheet the groups one by one
		tokenize `hlines'
		forval grp = 1/`=`num_hlines'+1' {
			
			* First group
			if `grp'==1 {
				qui outsheet `varlist' if `touse'==1 & inrange(`rownum',1,``grp'') using "`data1'", replace delimiter(`delimiter') nonames noquote
			}
			
			* Rest of groups
			else {
				* Append hline
				qui file open `fh' using "`data1'", write append
				file write `fh' "`horiz_line' "
				qui file close `fh'				
	
				if `grp' == `=`num_hlines'+1' {
					local g1 = ``=`grp'-1'' + 1	  // This allows for double/triple lines etc since it will make inrange(x+1,x)
					local g2 .
				}
				else {
					local g1 = ``=`grp'-1'' + 1
					local g2 ``grp''
				}
				
				* Append next group
				qui outsheet `varlist' if `touse'==1 & inrange(`rownum',`g1',`g2') using "`tmp'", replace delimiter(`delimiter') nonames noquote
				appendfile "`tmp'" "`data1'"
			}
		}		
	}
	
	else qui outsheet `varlist' `if' `in' using "`data1'", replace delimiter(`delimiter') nonames noquote
	filefilter "`data1'" "`data2'", from("`eol_char'") to(" \BStabularnewline`rowsep'`eol_char'") replace

	*********
	** Table end
	*********
	qui file open `fh' using "`end_file'", write `replace'	
	
	* SW has a bug with \bottomrule that requires you to output an extra \\
	file write `fh' `"\bottomrule `footnotespace'"' _n(2)	

	* Footnote style #1 only done if user specifies width option: this aligns with columns and needs to go before \end{tabularx}
	if `"`footnote'"'!="" & `"`footnotewidth'"'!="" file write `fh' `"\multicolumn{`num_vars'}{`footnotewidth'}{\begin{`footnotesize'} `footnote'\end{`footnotesize'}}"' _n	
	
	file write `fh' "\end{tabularx}" _n

	* Footnote style #2: just a simple flush left after the end of the table
	if `"`footnote'"'!="" & `"`footnotewidth'"'=="" {
		file write `fh' `"\begin{flushleft}"' _n
		file write `fh' `"\\`footnotesize' `footnote'"' _n
		file write `fh' `"\end{flushleft}"' _n
	}
	
	
	if `"`size'"'!="" file write `fh' "}" _n
		if "`sw'"!="" file write `fh' "%TCIMACRO{\TeXButton{E}{\end{table}}}%" _n
		if "`sw'"!="" file write `fh' "%BeginExpansion" _n
	file write `fh' "\end{table}" _n
		if "`sw'"!="" file write `fh' "%EndExpansion" _n
		
	* Footlines option
	if `"`footlines'"' != "" {
		tokenize `"`footlines'"'
		while `"`1'"' != "" {
			file write `fh' `"`1'"' _n
			macro shift
		}
	}
	if `"`geometry'"'!="" file write `fh' "\restoregeometry" _n
	if "`landscape'"!="" file write `fh' "\end{landscape}" _n
	
	* End the tex document
	if "`frag'"=="" file write `fh' "\end{document}" _n
	
	* Close the file
	file close `fh'
	
	********
	** Append table start ("using"), data, and table end together
	********
	appendfile "`data2'" "`using'"
	appendfile "`end_file'" "`using'"
	
	* Return vars to original state
	if "`renamed'"=="yes" {
				
		* Variables
		foreach v of local varlist {
			qui drop `v'
			qui ren ``v'temp' `v'
		}
	}		

end
**EOF	
