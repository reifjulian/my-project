#delim ;
prog def ingap, rclass byable(onecall);
version 10.0;
/*
  Insert gap observations next to observations specified by a numlist
  giving positions of the observations
  within the data set or within the by-groups.
  A gap observation has values of the by-variables as in its by-group,
  a special gap row label in the row label variable if one is specified,
  and missing values for all other variables.
  Gap observations are used in a Stata set that represents a table,
  with one observation per row of the table,
  and possibly by-variables specifying pages of a multi-page table
  and a row label variable specifying table row labels.
  Such a table can be output using the -listtex- package
  for input into a TeX, LaTeX, HTML or Microsoft Word table,
  or plotted on a Stata graph with the row labels on the Y-axis,
  after the row labels have been encoded to a numeric variable using -sencode-.
*! Author: Roger Newson
*! Date: 24 April 2009
*/

syntax [ anything(name=gaplist id="gap list") ] [if] [in] [ , AFter
  ROwlabel(varlist string) GRowlabels(string asis) RString(string) GRExpression(string asis)
  Gapindicator(string) NEWOrder(string) fast ];
if `"`gaplist'"'=="" {;
  local gaplist=1;
};
else {;
  numlist `"`gaplist'"',integer;
  local gaplist `"`r(numlist)'"';
};
/*
  -after- indicates that the gap observations must be inserted
    after the observations specified in the input numlist,
    instead of before these observations (the default).
  -rowlabel- is an existing string variable used as row labels,
    to be filled in from the -growlabel- option in the gap observations.
  -growlabels- is a list of string row labels for the gap observations.
  -rstring- specifies a rule for replacing string variables in gap observations
    (labels, names, or labels if present and names otherwise).
  -grexpression- is a string expression defining gap row labels,
    and is executed after setting gap row labels to -growlabels-,
    and therefore can contain the -rowlabel- variable and/or the by-variables,
    although other variables will usually be set to missing in the gap observations
    and can be read from adjacent observations by subscripting.
  -gapindicator- is a generated gap indicator variable,
    equal to 1 if the observation is a gap and 0 otherwise.
  -neworder- specifies a generated variable
    containing the new order of an observation within the data set
    (within by-group if necessary).
  -fast- specifies that -ingap- takes no action to preserve the existing data,
    in the event of failure or if the user presses -Break-.
*/

*
 Parse generated variable options
*;
genvar_parse `neworder';
local neworder "`r(varname)'";
local neworder_replace "`r(replace)'";
genvar_parse `gapindicator';
local gapindicator "`r(varname)'";
local gapindicator_replace "`r(replace)'";

*
 Check for name clashes
*;
local genvarlist "`rowlabel `neworder' `gapindicator'";
local genvarlist: list clean genvarlist;
local ugenvarlist: list uniq genvarlist;
cap assert "`ugenvarlist'"=="`genvarlist'";
if _rc!=0 {;
  disp as error "neworder(), gapindicator() and rowlabel() options may not specify the same variable";
  error 498;
};
local byclash: list genvarlist & _byvars;
if "`byclash'"!="" {;
  disp as error "neworder(), gapindicator() and rowlabel() options may not specify by-variables";
  error 498;
};

* Preserve old data in case user presses -Break- *;
if "`fast'"=="" {;preserve;};

*
 Create macro -bybyvars- to prefix commands done by by-vars
 if by-vars are present
*;
if _by() {;
  local bybyvars `"by `_byvars':"';
};

*
 Create local macro -gindlab-
 (containing label for variable -gapindicator-)
*;
local gindlab "Gap indicator";

* Create list of existing variables *;
unab existvar: *;

* Check that row label variables are not by-variables *;
if (`"`rowlabel'"'!="") & _by() {;
  foreach X of var `rowlabel' {;
    foreach Y of var `_byvars' {;
      if "`X'"=="`Y'" {;
        disp as error "Error: row label variable `X' is a by-variable";
        error 498;
      };
    };
  };
};

* Mark sample for use *;
marksample touse;

*
 Create temporary variable -seqord- containing original order,
 temporary variable -wbseqord- containing order within by-groups,
 temporary variable -wbtotal- containing number in current by-group,
 temporary variable -ntodup- to contain number of duplicates to -expand- by,
 and temporary variable -gapseq- to contain gap sequence order for gap observations,
*;
tempvar seqord wbseqord wbtotal ntodup gapseq;
qui {;
  gene long `seqord'=_n;
  `bybyvars' gene long `wbseqord'=_n;
  `bybyvars' gene long `wbtotal'=_N;
  gene long `ntodup'=.;
  gene long `gapseq'=.;
};

* Initialise -gapindicator- variable *;
if `"`gapindicator'"'=="" {;tempvar gapindicator;};
else {;
  if "`gapindicator_replace'"=="replace" {;cap drop `gapindicator';};
  confirm new var `gapindicator';
  local ngapi:word count `gapindicator';
  if `ngapi'>1 {;
    disp as error "Invalid multiple gap indicator variables: `gapindicator'";
    error 498;
  };
};
qui gene byte `gapindicator'=0;
lab var `gapindicator' "Gap observation indicator";

*
 Add gap observations for each gap
*;
local ngap:word count `gaplist';
local Norig=_N;
forv i1=1(1)`ngap' {;
  local gapcur:word `i1' of `gaplist';
  local growlcur:word `i1' of `growlabels';
  local Noldcur=_N;
  qui {;
    replace `ntodup'=1;
    if `gapcur'>=0 {;
      * Count gap position from beginning of data set or by-group *;
      replace `ntodup'=`ntodup'+1
        if `touse' & (_n<=`Norig') & (`wbseqord'==`gapcur');
    };
    else {;
      * count gap position from end of data set or by-group *;
      replace `ntodup'=`ntodup'+1
        if `touse' & (_n<=`Norig') & (`wbseqord'==`wbtotal'+`gapcur'+1);
    };
    expand `ntodup';
    * Replace gap indicator and row labels in new observations *;
    replace `gapindicator'=1 if _n>`Noldcur';
    replace `gapseq'=`i1' if _n>`Noldcur';
    if `"`rowlabel'"'!="" {;
      foreach L of var `rowlabel' {;
        replace `L'=`"`growlcur'"' if _n>`Noldcur';
      };
    };
  };
};

*
 Parse rstring(), setting default if necessary
*;
if "`rstring'"!="" {;
  cap confirm names `rstring';
  if _rc!=0 {;
    disp as error `"Invalid rstring() option: `rstring'"';
    error 498;
  };
  local nrstring: word count `rstring';
  if `nrstring'>2 {;
    disp as error `"Invalid rstring() option: `rstring'"';
    error 498;
  };
  local source: word 1 of `rstring';
  if !inlist("`source'","order","name","type","format","varlab","char","label","labname") {;
    disp as error `"Invalid rstring() option: `rstring'"';
    error 498;
  };
  if "`source'"=="char" {;
    local charname: word 2 of `rstring';
    if "`charname'"=="" {;
      disp as error `"Invalid rstring() option: `rstring'"'
        _n as error "No characteristic name supplied";
      error 498;
    };
  };
  local rstring `source';
};

* Set non-by, non-rowlabel variables in gap observations *;
foreach X of var `existvar' {;
  local nonbyrovar=1;
  if (`"`rowlabel'"'!="")|_by() {;
    foreach Y of var `_byvars' `rowlabel' {;
      if "`X'"=="`Y'" {;local nonbyrovar=0;};
    };
  };
  if `nonbyrovar' {;
    cap confirm string variable `X';
    if _rc==0 {;
      * String variable *;
      if "`rstring'"=="" {;
        qui replace `X'="" if `gapindicator'==1;        
      };
      else if "`rstring'"=="order" {;
        local Xlab: list posof "`X'" in existvar;
        qui replace `X'="`Xlab'" if `gapindicator'==1;
      };
      else if `"`rstring'"'=="name" {;
        qui replace `X'="`X'" if `gapindicator'==1;
      };
      else if "`rstring'"=="type" {;
        local Xlab: type `X';
        qui replace `X'=`"`Xlab'"' if `gapindicator'==1;
      };
      else if "`rstring'"=="format" {;
        local Xlab: format `X';
        qui replace `X'=`"`Xlab'"' if `gapindicator'==1;
      };
      else if inlist("`rstring'","varlab","label") {;
        local Xlab: var lab `X';
        qui replace `X'=`"`Xlab'"' if `gapindicator'==1;
      };
      else if "`rstring'"=="char" {;
        qui replace `X'=`"``X'[`charname']'"' if `gapindicator'==1;
      };
      else if "`rstring'"=="labname" {;
        local Xlab: var lab `X';
        if `"`Xlab'"'!="" {;
          qui replace `X'=`"`Xlab'"' if `gapindicator'==1;
        };
        else {;
          qui replace `X'=`"`X'"' if `gapindicator'==1;
        };
      };
      else {;
        qui replace `X'="" if `gapindicator'==1;
      };
    };
    else {;
      * Numeric variable *;
      if !inlist("`X'","`gapindicator'","`neworder'") {;
        qui replace `X'=. if `gapindicator'==1;
      };
    };
  };
};

*
 Sort to original order
 (with gap observations placed according to -after- option)
 and add -neworder()- variable if requested
*;
if "`after'"=="" {;gsort `_byvars' `seqord' -`gapindicator' `gapseq';};
else {;gsort `_byvars' `seqord' `gapindicator' `gapseq';};
if "`neworder'"=="" {;
  tempvar neworder;
};
else {;
  if "`neworder_replace'"=="replace" {;cap drop `neworder';};
  confirm new var `neworder';
};
qui `bybyvars' gene long `neworder'=_n;
qui compress `neworder';
if "`_byvars'"=="" {;lab var `neworder' "Order within dataset";};
else {;
  local maxlablen=80;
  if length("`_byvars'")+length("Order within: ")>`maxlablen' {;
    lab var `neworder' "Order within by-group";
  };
  else {;
    lab var `neworder' "Order within: `_byvars'";
  };
};
sort `_byvars' `neworder';

*
 Set row labels to value of -grexpression- in gap observations
*;
if `"`grexpression'"'!="" & "`rowlabel'"!="" {;
  qui `bybyvars' replace `rowlabel'=(`grexpression') if `gapindicator'==1;
};

* Restore old data only if error happens or user presses -Break- *;
if "`fast'"=="" {;restore,not;};

end;

prog def genvar_parse, rclass;
version 10.0;
/*
 Parse generated variable options
 and return results.
*/

syntax [ name ] [ , replace ];

return local varname "`namelist'";
return local replace "`replace'";

end;
