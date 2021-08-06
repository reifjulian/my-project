{smcl}
{hi:help rscript}
{hline}
{title:Title}

{p 4 4 2}{cmd:rscript} {hline 2} Call an R script from Stata.


{title:Syntax}

{p 8 14 2}{cmd:rscript} {cmd:using} {it:filename.R}, [{cmd:rpath(}{it:pathname}{cmd:)} {cmd:args(}{it:stringlist}{cmd:)}
{cmd:rversion(}{it:# [#]}{cmd:)} {cmd:require(}{it:stringlist}{cmd:)} {cmd:force}]

{p 4 4 2}where

{p 8 14 2}{it: pathname} specifies the location of the R executable, and

{p 8 14 2}{it: stringlist} is a list of quoted strings.

{p 4 4 2}The R executable can be specified by {cmd:rpath()} or by the global macro RSCRIPT_PATH.
Otherwise, {cmd:rscript} will search for the R executable on its own. 


{title:Description}

{p 4 4 2}{cmd:rscript} calls {it:filename.R} from Stata. It displays the R output (and errors, if applicable) in the Stata console.


{title:Options}

{p 4 8 2}
{cmd:rpath(}{it:pathname}{cmd:)} specifies the location of the R executable. 
If not specified, {cmd:rscript} will use the location specified by the global macro RSCRIPT_PATH.
If {cmd:rpath()} is not specified and RSCRIPT_PATH is undefined, then {cmd:rscript} will search for the R executable on its own.

{p 4 8 2}
{cmd:args(}{it:stringlist}{cmd:)} specifies arguments to pass along to R.

{p 4 8 2}
{cmd:rversion(}{it:# [#]}{cmd:)} instructs {cmd:script} to break if the R version is less than {it:#}. You can also optionally provide a second {it:#}, which generates a break if the R version is greater than {it:#}.

{p 4 8 2}
{cmd:require(}{it:stringlist}{cmd:)} specifies a list of required R packages and generates a break if any are missing from the user's default library.

{p 4 8 2}
{cmd:force} instructs {cmd:rscript} not to break when {it:filename.R} generates an error during execution.


{title:Notes}

{p 4 8 2}
{cmd:rscript} has been tested on Windows, Mac OS X, and Unix (tcsh shell).

{p 4 8 2}
The options {cmd:rversion()} and {cmd:require()} can be used without specifying {cmd:using} {it:filename.R}. 
For example, to ensure that the R installation is version 3.6 or higher, type:

{col 8}{cmd:. rscript, rversion(3.6)}

{title:Stored results}

{p 4 4 2}{cmd: rscript} stores the following in {cmd: r()}:

{p 4 4 2}Macros

{p 8 8 2}{cmd:r(path)}     {space 5} location of the R executable


{title:Examples}

{p 4 4 2}1.  Call an R script using the default location specified by RSCRIPT_PATH and pass along the names of an input file and output file.

{col 8}{cmd:. global RSCRIPT_PATH "/usr/local/bin/Rscript"}
{col 8}{cmd:. rscript using my_script.R, args("input_file.txt" "output_file.txt")}


{p 4 4 2}2.  Same as Example 1, but specify the location of your R executable using the {cmd:rpath()} option.

{col 8}{cmd:. rscript using my_script.R, rpath("/usr/local/bin/Rscript") args("input_file.txt" "output_file.txt")}


{p 4 4 2}3.  Same as Example 1, but generate a break if the user's R version is less than 4.0.1 or does not include the 'tidyverse' package.

{col 8}{cmd:. rscript using my_script.R, args("input_file.txt" "output_file.txt") rversion(4.0.1) require(tidyverse)}


{title:Authors}

{p 4 4 2}David Molitor, University of Illinois

{p 4 4 2}dmolitor@illinois.edu


{p 4 4 2}Julian Reif, University of Illinois

{p 4 4 2}jreif@illinois.edu


{title:Also see}

{p 4 4 2}{help rsource:rsource} (if installed), {help rcall:rcall} (if installed)

