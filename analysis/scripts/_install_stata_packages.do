*******
* This script installs all necessary Stata packages into /libraries/stata
* To do a fresh install of all Stata packages, delete the entire /libraries/stata folder
* Note: this script has been provided for pedagogical purposes only. It should NOT be included as part of your replication materials, since these add-ons are already available in /libraries/stata
*******

* Create and define a local installation directory for the packages
cap mkdir "$MyProject/scripts/libraries"
cap mkdir "$MyProject/scripts/libraries/stata"
net set ado "$MyProject/scripts/libraries/stata"


* Install latest developer's version of the package from GitHub
foreach p in regsave texsave rscript {
	net install `p', from("https://raw.githubusercontent.com/reifjulian/`p'/master") replace
}


* Install packages from SSC
foreach p in ingap {
	local ltr = substr(`"`p'"',1,1)
	qui net from "http://fmwww.bc.edu/repec/bocode/`ltr'"
	net install `p', replace
}



** EOF
