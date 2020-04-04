{smcl}
{.-}
help for {cmd:ingap} {right:(Roger Newson)}
{.-}


{title:Insert gap observations in a dataset}

{p 8 21 2}
{cmd:ingap} [ {help numlist:{it:numlist}} ] {ifin}
 [ , {cmdab:af:ter}
   {break}
   {cmdab:g:apindicator}{cmd:(}{newvar}[,{cmd:replace}]{cmd:)} {cmdab:newo:rder}{cmd:(}{newvar}[,{cmd:replace}]{cmd:)}
   {break}
   {cmdab:ro:wlabel}{cmd:(}{varname}{cmd:)} {cmdab:gr:owlabels}{cmd:(}{it:string_list}{cmd:)}
   {cmdab:gre:xpression}{cmd:(}{it:gap_row_label_expression}{cmd:)}
   {cmdab:rs:tring}{cmd:(}{it:string_replacement_option}{cmd:)}
   {cmd:fast}
 ]

{p}
where {help numlist:{it:numlist}} is an optional list of integers, {it:string_list} is a list of strings,
{it:gap_row_label_expression} is a string-valued expression,
and {it:string_replacement_option} can be

{p}
{cmd:order} | {cmd:name} | {cmd:type} | {cmd:format} | {cmd:varlab} | {cmd:char} {help char:{it:characteristic_name}} | {cmd:label} | {cmd:labname}

{p}
and {help char:{it:characteristic_name}} is the name of a {help char:variable characteristic}.

{p}
The {helpb by} prefix can be used with {cmd:ingap}; see help for {help prefix}.


{title:Description}

{p}
{cmd:ingap} inserts gap observations into a list of positions in an existing dataset.
All existing variables in the dataset (apart from {help by:by-variables})
will have missing values in the gap observations, unless the user specifies otherwise.
Often, the user specifies non-missing values in the gap observations for one particular existing string variable,
known as the row label variable.
This row label variable may then be output with a list of other variables to form a publication-ready table,
using the {helpb listtab} package (or possibly the {helpb listtex} package).
Alternatively, the row label variable may be encoded, using the {helpb sencode} package,
to form a numeric variable with {help label:value labels},
which can then be plotted on one axis of a {help graph:graph} to define axis labels.
The {helpb sencode}, {helpb listtab} and {helpb listtex} packages are downloadable from {help ssc:SSC}.

{p}
{cmd:ingap} inserts a gap observation next to (before or after) each of a list of observations
specified by the {help numlist:{it:numlist}}.
A positive number {hi:i} in the {help numlist:{it:numlist}} specifies the {hi:i}th existing observation in the dataset,
or in each by-group if the {helpb by} prefix is specified.
A negative number {hi:-i} in the {help numlist:{it:numlist}} specifies the {hi:i}th existing observation,
in reverse order, from the end of the dataset,
or from the end of each by-group if the {helpb by} prefix is specified.
A zero or out-of-range number in the {help numlist:{it:numlist}} is ignored.
The {help numlist:{it:numlist}} is set to 1 if not specified by the user.
{cmd:ingap} assumes that the dataset in memory has up to 3 classes of variables.
These are the by-variables (which define by-groups possibly representing the pages of a table),
a row label variable (possibly containing the row labels in the left margin of the table),
and the remaining variables (which may form the entries in the table rows).
A gap observation inserted by {cmd:ingap} has the same values for the by-variables
as the observation next to which it was inserted,
a row label value specified by the {cmd:growlabels()} or {cmd:grexpression()} options,
and missing values in the remaining variables (unless the user specifies otherwise).
{cmd:ingap} may also generate new variables,
indicating whether the observation is a gap observation
and/or the new order of the observation in the dataset (or by-group) after the gap observations have been inserted.


{title:Options}

{phang}
{cmd:after} specifies that each gap observation will be inserted
after the corresponding existing observation in the dataset or by-group specified in the {help numlist:{it:numlist}}.
If {cmd:after} is not specified,
then each gap observation will be inserted before the corresponding existing observation.

{phang}
{cmd:gapindicator(}{it:newvarname}[,{cmd:replace}]{cmd:)} specifies the name of a new variable to be generated,
equal to 1 for the newly-inserted gap observations and 0 for all other observations.
The {cmd:replace} suboption specifies that any existing variable with the same name will be replaced.

{phang}
{cmd:neworder(}{it:newvarname}[,{cmd:replace}]{cmd:)} specifies the name of a new variable to be generated,
equal to the new sequential order of the observation within the dataset
(or within the by-group if {help by:the by prefix} is specified),
after the gap observations have been inserted.
The new variable has no missing values.
After execution of {cmd:ingap}, the dataset in memory is sorted primarily by the by-variables (if specified),
and secondarily by the {cmd:neworder()} variable (if specified).
The {cmd:replace} suboption specifies that any existing variable with the same name will be replaced.

{phang}
{cmd:rowlabel(}{it:string_varname}{cmd:)} specifies the name of an existing string variable,
used as the row labels for a table whose rows are the observations.
In the gap observations,
this string variable is set to the value specified by the corresponding string listed in the {cmd:growlabels()} option
if that option is specified (see below),
or to a missing value otherwise.
The {cmd:rowlabel()} variable may not be a by-variable.

{pstd}
Note that the {cmd:neworder()}, {cmd:gapindicator()} and {cmd:rowlabel()} options may not specify the same variable names,
and may not specify the names of {help by:by-variables}.
Also, note that the {cmd:neworder()} and {cmd:gapindicator()} variables are always non-missing,
even in observations not included in the sample defined by the {helpb if} and {helpb in} qualifiers.
These qualifiers only specify that an observation may have observations inserted before it
(or after it, if {cmd:after} is specified),
if its sequential order in the dataset or by-group is included in the {help numlist:{it:numlist}}.

{phang}
{cmd:growlabels(}{it:string_list}{cmd:)} specifies a string value for each of the row labels in the gap observations.
The {hi:j}th string in the {it:string_list} is written to the {cmd:rowlabel} variable
in the newly-inserted  gap observation  inserted next to the {hi:j}th observation mentioned in the {help numlist:{it:numlist}}.
If the {cmd:rowlabel} option is present and the {cmd:growlabel()} option is absent,
then the {cmd:rowlabel()} variable is initialised to missing in the gap observations.

{phang}
{cmd:grexpression(}{it:gap_row_label_expression}{cmd:)} specifies a string expression,
to be evaluated in all gap observations to give the final values of the {cmd:rowlabel()} variables
in these gap observations.
If {cmd:grexpression()} and {cmd:growlabels()} are both specified,
then the result of {cmd:grexpression()} replaces any values set by {cmd:growlabels()}.
(However, the name of the {cmd:rowlabels()} variable may appear in the {cmd:grexpression()} expression,
so that the values of the {cmd:rowlabels()} variable can be modified
in ways depending on the original values set by the {cmd:growlabels()} list.)
Note that, when the {cmd:grexpression()} expression is evaluated,
all variables other than the {cmd:rowlabels()} variable have been set to their final values,
which are missing for all variables except the by-variables and the {cmd:rowlabel()} variable,
except if they have been set to other values by the {cmd:rstring()} option (see below).
However, the {cmd:grexpression()} expression may access values of variables in adjacent observations using {help subscripting}.
If by-variables are present, then any subscripts in the expression specified by {cmd:grexpression()} are defined within by-groups,
and are defined including the gap observations.
For instance, if a gap observation is inserted at the beginning of each by-group,
then the value of {hi:_n} in these gap observations will be 1.

{phang}
{cmd:rstring(}{it:string_replacement_option}{cmd:)} specifies a rule for replacing the values of
string variables (other than the by-variables and row label variables) in gap observations.
If {cmd:rstring()} is not set,
then these variables will be set to a missing value (an empty string) in the gap observations.
{cmd:rstring()} can be set to
{cmd:order}, {cmd:name}, {cmd:type}, {cmd:format}, {cmd:varlab}, {cmd:char} {help char:{it:characteristic_name}},
{cmd:label}, or {cmd:labname}.
The options {cmd:order}, {cmd:name}, {cmd:type}, {cmd:format}, {cmd:varlab} and {cmd:char} {help char:{it:characteristic_name}}
imply that the value of each string variable, in the gap observations,
will be set to the order of the variable in the existing dataset,
the {help type:storage type} of the variable,
the {help format:display format} of the variable,
the {help label:variable label} of the variable,
or the {help char:ccharacteristic} of the variable with the name {help char:{it:characteristic_name}},
respectively.
The option {cmd:label} is a synonym for {cmd:varlab}.
The option {cmd:labname} specifies that the value of each string variable, in the gap observations,
will be set to its {help label:variable label}, if that label exists,
and to its name otherwise.
(Note that numeric variables that are not by-variables, {cmd:gapindicator()} variables or {cmd:neworder()} variables
are always set to the numeric missing value {cmd:.} in gap observations.)
The {cmd:rstring()} option allows the user to add a row of column headings to a dataset of string variables,
or to add a row of column headings to each by-group of a dataset of string variables.
Note also that numeric variables may be converted to string variables using the {helpb sdecode} package,
downloadable from {help ssc:SSC},
before using {cmd:ingap} and {helpb listtab}.
This allows the user to use the {cmd:rstring()} option,
and also to format numeric variables in ways not possible using Stata formats alone,
such as adding parentheses to confidence limits.

{phang}
{cmd:fast} is an option for programmers.
It specifies that {cmd:ingap} will do no work to ensure
that the original dataset is preserved in the event that {cmd:ingap} fails,
or if the user presses {help break:the Break key}.
If {cmd:fast} is not specified,
and {cmd:ingap} fails, or the user presses {help break:the Break key},
then the original existing dataset is preserved, with no additional gap observations.


{title:Remarks}

{pstd}
{cmd:ingap} is typically used to convert a Stata dataset to a form with 1 observation per table row
(including gap rows), or 1 observation per graph axis label (including gap axis labels).
The user can then list the dataset as a TeX, LaTeX, HTML or Microsoft Word table,
using the {helpb listtab} package (downloadable from {help ssc:SSC}).
Alternatively, for immediate impact, the user can use the {helpb sencode} package
(downloadable from {help ssc:SSC}) to encode the row labels to a numeric variable,
and then plot this numeric variable against other variables using {help graph:Stata graphics programs}.
For instance, a user of Stata 8 or above might use {helpb eclplot} (downloadable from SSC)
to produce horizontal confidence interval plots, with the row labels on the vertical axis.
It is often advisable for the user to type {helpb preserve} before a sequence of commands including
{cmd:ingap}, and to type {helpb restore} after a sequence of commands using {cmd:ingap},
because {cmd:ingap} modifies the dataset by adding new observations.
It is often also advisable for the user to place the whole sequence of commands in a {help do:do-file},
and to execute this {help do:do-file},
rather than to type the sequence of commands one by one at the terminal.

{pstd}
The {helpb listtab} package is described in {help ingap##references:Newson (2012)}.
It inputs a list of variables in a Stata dataset,
and outputs a text table, in a file or on the screen,
containing these variables as columns and the observations as rows,
and formatted using a row style.
This row style may correspond to table rows in plain TeX, LaTeX, HTML, XML, or RTF tables,
or to rows of tab-delimited, column-delimited or ampersand-delimited generic text spreadsheets,
or to rows in other styles that may be invented in future.
The row style is defined using a row-beginning string, a row-end string,
and a between-column delimiter string.
{helpb listtab} is a successor to the {helpb listtex} package,
described in {help ingap##references:Newson (2006), Newson (2004) and Newson (2003)}.
The main change introduced in {helpb listtab} is that empty delimiter strings are now allowed.
Users of {help version:Stata versions} 10 and above
are advised to use {helpb listtab} in preference to {helpb listtex},
although both packages are still downloadable from SSC.


{title:Examples}

{p 8 16}{cmd:. ingap, g(toprow)}{p_end}

{p 8 16}{cmd:. ingap 1 53, g(toprow) row(make) grow("US cars" "Non-US cars")}{p_end}

{p 8 16}{cmd:. by foreign: ingap, g(gind) row(make) grow("Car model")}{p_end}

{p 8 16}{cmd:. sort foreign rep78 make}{p_end}
{p 8 16}{cmd:. by foreign rep78: ingap}{p_end}
{p 8 16}{cmd:. by foreign: ingap -1, after}{p_end}
{p 8 16}{cmd:. by foreign: ingap, row(make) grow("Car model")}{p_end}
{p 8 16}{cmd:. list}{p_end}

{p}
The following example works in the {hi:auto} data if the user has installed the {helpb listtex} package,
downloadable from {help ssc:SSC}.
It outputs to the Results window a generic ampersand-delimited text table,
which can be cut and pasted into a Microsoft Word document,
and then converted to the rows of a table inside Microsoft Word,
using the menu sequence {cmd:Table->Convert->Text to Table}.
(Note that the {helpb listtex} command can alternatively create table rows suitable for input
into a TeX, LaTeX or HTML file.)

{p 8 16}{cmd:. preserve}{p_end}
{p 8 16}{cmd:. by foreign: ingap, row(make) grexp(cond(foreign,"Non-US cars","US cars"))}{p_end}
{p 8 16}{cmd:. listtab make mpg weight, delim(&) type}{p_end}
{p 8 16}{cmd:. restore}{p_end}

{p}
The following example works in the {hi:auto} data if the user has installed the {helpb listtab} package,
and also the {helpb sdecode} package, both of which
can be downloaded from {help ssc:SSC}.)
It outputs to the Results window a generic ampersand-delimited
text table, which can be cut and pasted into a Microsoft Word document (as in the previous example),
and then converted into two tables, one for American cars and one for non-American cars, each with a title
line containing the variable labels in the {hi:auto} data.
Note that, to do this, the user must convert the numeric variables to string variables,
and this is done using {helpb sdecode}.

{p 8 16}{cmd:. preserve}{p_end}
{p 8 16}{cmd:. sdecode mpg, replace}{p_end}
{p 8 16}{cmd:. sdecode weight, replace}{p_end}
{p 8 16}{cmd:. sdecode price, replace}{p_end}
{p 8 16}{cmd:. by foreign: ingap, rstring(labname)}{p_end}
{p 8 16}{cmd:. listtab make mpg weight price, delim(&) type}{p_end}
{p 8 16}{cmd:. restore}{p_end}

{p}
The following example works in the {hi:auto} data if the user has installed
the {helpb sdecode} and {helpb sencode} packages, downloadable from {help ssc:SSC}.
It produces a graph of mileage by car type (US or non-US) and
repair record.

{p 8 16}{cmd:. preserve}{p_end}
{p 8 16}{cmd:. sdecode rep78, gene(row) miss}{p_end}
{p 8 16}{cmd:. by foreign: ingap, row(row) grexp(cond(foreign,"Others:","US cars:")) gap(gapind)}{p_end}
{p 8 16}{cmd:. sencode row, replace many gs(foreign -gapind rep78)}{p_end}
{p 8 16}{cmd:. lab var row "Repair record"}{p_end}
{p 8 16}{cmd:. scatter row mpg, yscale(reverse range(0 13)) ylab(1(1)12, valuelabel angle(0)) xlab(0(10)50)}{p_end}
{p 8 16}{cmd:. restore}{p_end}

{p}
Other examples of the use of {cmd:ingap}, together with other packages, can be found in
{help ingap##references:Newson (2012), Newson (2006), Newson (2004) and Newson (2003)}.


{title:Author}

{p}
Roger Newson, National Heart and Lung Institute, Imperial College London, UK.
Email: {browse "mailto:r.newson@imperial.ac.uk":r.newson@imperial.ac.uk}


{marker references}{title:References}

{phang}
Newson, R. B.  2012.
From resultssets to resultstables in Stata.
{it:The Stata Journal} 12(2): 191-213.
Download from {browse "http://www.stata-journal.com/article.html?article=st0254":{it:The Stata Journal} website}.

{phang}
Newson, R.  2006. 
Resultssets, resultsspreadsheets and resultsplots in Stata.
Presented at the {browse "http://ideas.repec.org/s/boc/dsug06.html" :4th German Stata User Meeting, Mannheim, 31 March, 2006}.

{phang}
Newson, R.  2004.
From datasets to resultssets in Stata.
Presented at the {browse "http://ideas.repec.org/s/boc/usug04.html" :10th United Kingdom Stata Users' Group Meeting, London, 29 June, 2004}.

{phang}
Newson, R.  2003.
Confidence intervals and {it:p}-values for delivery to the end user.
{it:The Stata Journal} 3(3): 245-269.
Download from {browse "http://www.stata-journal.com/article.html?article=st0043" :{it:The Stata Journal} website}


{title:Acknowledgement}

{p}
I would like to thank Nicholas J. Cox, of the University of Durham, U.K.,
for writing the {helpb hplot} package, downloadable from {help ssc:SSC}.
This package gave me a lot of the ideas used in {cmd:ingap},
and was also my preferred package for producing confidence interval plots under Stata Versions 6 and 7,
before I had access to the improved graphics of Stata Version 8.


{title:Also see}

{p 0 21}
{bind: }Manual:  {hi:[U] 11 Language syntax}, {hi:[D] by}, {hi:[D] expand}, {hi:[P] byable}, {hi:[R] ssc}
{p_end}
{p 0 21}
On-line:  help for {helpb by}, {helpb byprog}, {helpb expand}, {helpb ssc}
{p_end}
{p 10 21}
help for {helpb listtab}, {helpb listtex}, {helpb sencode}, {helpb sdecode}, {helpb hplot}, {helpb eclplot} if installed
{p_end}
