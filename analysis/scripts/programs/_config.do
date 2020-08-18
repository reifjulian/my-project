******
* This script contains code that allows scripts to be run individually on a standalone basis
* It is unnecessary when executing run.do
******

* Ensure the script uses only local libraries and programs
adopath ++ "$MyProject/scripts/libraries/stata"
adopath ++ "$MyProject/scripts/programs"

cap adopath - PERSONAL
cap adopath - PLUS
cap adopath - SITE
cap adopath - OLDPLACE

* Additional code you want automatically executed
assert !mi("$MyProject")
set varabbrev off

