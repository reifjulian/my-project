******
* This script configures the Stata library environment and displays the value of system parameters
******
* Stata version control
version 15

* The local macro ProjectDir must point to the folder path that contains the /scripts folder
local ProjectDir "$MyProject"

cap assert !mi("`ProjectDir'")
if _rc {
	noi di as error "Error: need to define project directory in scripts/programs/_config.do"
	error 9
}

* Ensure Stata uses only local libraries and programs
tokenize `"$S_ADO"', parse(";")
while `"`1'"' != "" {
  if `"`1'"'!="BASE" cap adopath - `"`1'"'
  macro shift
}
adopath ++ "`ProjectDir'/scripts/libraries/stata"
adopath ++ "`ProjectDir'/scripts/programs"
mata: mata mlib index

* Display system parameters and record the date and time
cap program drop _print_timestamp 
program define _print_timestamp 
	di "{hline `=min(79, c(linesize))'}"

	di "Date and time: $S_DATE $S_TIME"
	di "Stata version: `c(stata_version)'"
	di "Updated as of: `c(born_date)'"
	di "Variant:       `=cond( c(MP),"MP",cond(c(SE),"SE",c(flavor)) )'"
	di "Processors:    `c(processors)'"
	di "OS:            `c(os)' `c(osdtl)'"
	di "Machine type:  `c(machine_type)'"
	local hostname : env HOSTNAME
	local shell : env SHELL
	if !mi("`hostname'") di "Hostname:      `hostname'"
	if !mi("`shell'") di "Shell:         `shell'"
	
	di "{hline `=min(79, c(linesize))'}"
end
noi _print_timestamp

* Create directories for output files
cap mkdir "`ProjectDir'/processed"
cap mkdir "`ProjectDir'/processed/intermediate"
cap mkdir "`ProjectDir'/results"
cap mkdir "`ProjectDir'/results/figures"
cap mkdir "`ProjectDir'/results/intermediate"
cap mkdir "`ProjectDir'/results/tables"

* Additional code you want automatically executed
set varabbrev off
set more off

** EOF
