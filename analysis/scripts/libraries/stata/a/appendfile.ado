*! appendfile 1.0.1 05may2015 by Julian Reif

* 1.0.1: Changed `line' to `macval(line)' to accommodate problematic characters

program define appendfile
	version 8.2

	args source dest

	confirm file `"`source'"'
	confirm file `"`dest'"'
	
	* Files cannot be the same
	if `"`source'"'==`"`dest'"' {
		di as error "Files must be different"
		exit 198
	}

	tempname src
	tempname dst
	file open `src' using "`source'", read
	file open `dst' using "`dest'", write append
	
	file read `src' line
	while r(eof)==0 {
		file write `dst' `"`macval(line)'"'_n
		file read `src' line
	}
	file close `src'
	file close `dst'
end
**EOF**
