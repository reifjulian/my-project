******
* This script contains code that allows scripts to be run individually on a standalone basis, if the user has defined the project global in their Stata profile
* It is unnecessary when executing run.do
******

* Ensure the script uses only local libraries and programs
tokenize `"$S_ADO"', parse(";")
while `"`1'"' != "" {
  if `"`1'"'!="BASE" cap adopath - `"`1'"'
  macro shift
}
adopath ++ "$MyProject/scripts/libraries/stata"
adopath ++ "$MyProject/scripts/programs"

* Additional code you want automatically executed
assert !mi("$MyProject")
set varabbrev off

** EOF
