*! rscript 1.0.3 23mar2020 by David Molitor and Julian Reif
* 1.0.3: added support for "~" pathnames
* 1.0.2: stderr is now parsed by Mata instead of Stata
* 1.0.1: Updated error handling

program define rscript, nclass

	version 13.0

	tempfile shell out err
	tempname shellfile

	syntax using/, [rpath(string) args(string asis) force]
	
	****************
	* Error checking
	****************	
	confirm file "`using'"
	
	* If user does not specify the location of the R executable, set the default to what is stored in RSCRIPT_PATH
	if mi(`"`rpath'"') local rpath "$RSCRIPT_PATH"
	
	if mi(`"`rpath'"') {
		di as error "Location of R executable must be specified using option rpath() or using the global RSCRIPT_PATH"
		exit 198
	}
	
	confirm file "`rpath'"
	
	* Calling a script using "~" notation causes a fatal error with shell (Unix/Mac). Avoid by converting to absolute path.
	qui if strpos("`using'","~") {
		mata: pathsplit(st_local("using"), path = "", fname = "")
		mata: st_local("path", path)
		mata: st_local("fname", fname)
		
		local workdir_orig "`c(pwd)'"
		cd `"`path'"'
		local using "`c(pwd)'/`fname'"
		cd "`workdir_orig'"
		confirm file "`using'"
	}
	
	****************
	* Run the script. Redirect stdout to `out' and stderr to `err'
	****************

	di as result `"Running R script: `using'"'
	if !mi(`"`args'"') di as result `"Args: `args'"'	
	di as result _n
		
	* Syntax for the -shell- call depends on which version of the shell is running:
	*	Unix csh:  /bin/csh
	*	Unix tcsh: /usr/local/bin/tcsh (default on NBER server)
	*	Unix bash: /bin/bash
	*	Windows
	shell echo "$0" > `shell'
	file open `shellfile' using `"`shell'"', read
	file read `shellfile' shellline
	file close `shellfile'	
	
	* Unix: tcsh or csh shell
	if strpos("`shellline'", "csh") {	
		shell ("`rpath'" "`using'" `args' > `out') >& `err'
	}
	
	* Unix: bash shell
	else if strpos("`shellline'", "bash") {
		shell "`rpath'" "`using'" `args' > `out' 2>`err'
	}
	
	* Other (including Windows)
	else {
		shell "`rpath'" "`using'" `args' > `out' 2>`err'
	}

	****************
	* Display stdout and stderr output
	****************
	di as result "Begin R output:"
	di as result "`="_"*80'"
	
	di as result "{ul:stdout}:"
	type `"`out'"'
	di as result _n
	di as result "{ul:stderr}:"
	type `"`err'"'
	
	di as result "`="_"*80'"
	di as result "...end R output"_n
	
	****************
	* If there was an "error" in the execution of the R script, notify the user (and break, unless -force- option is specified)
	****************
	cap mata: parse_stderr("`err'")
	if _rc==198 {
		display as error "`using' ended with an error"
		display as error "See stderr output above for details"
		if "`force'"=="" error 198
	}
	else if _rc {
		display as error "Encountered a problem while parsing stderr"
		display as error "Mata error code: " _rc
	}
	
	* In a few (rare) cases, a "fatal error" message will be written to stdout rather than stderr
	cap mata: parse_stdout("`out'")
	if _rc==198 {
		display as error "`using' ended with a fatal error"
		display as error "See stdout output above for details"
		if "`force'"=="" error 198
	}
	else if _rc {
		display as error "Encountered a problem while parsing stdout"
		display as error "Mata error code: " _rc
	}	
end

* Parse the stderr and stdout output files to check for errors
mata:
void parse_stderr(string scalar filename)
{
	real scalar input_fh
	string scalar line

	input_fh = fopen(filename, "r")
	
	while ((line=fget(input_fh)) != J(0,0,"")) {
		if (strpos(strlower(line), "error")!=0) exit(error(198))
	}
	
	fclose(input_fh)
}

void parse_stdout(string scalar filename)
{
	real scalar input_fh
	string scalar line

	input_fh = fopen(filename, "r")
	
	while ((line=fget(input_fh)) != J(0,0,"")) {
		if (strpos(strlower(line), "fatal error")!=0) exit(error(198))
	}
	
	fclose(input_fh)
}

end
** EOF
