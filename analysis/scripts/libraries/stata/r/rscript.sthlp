{smcl}
{hi:help rscript}
{hline}
{title:Title}

{p 4 4 2}{cmd:rscript} {hline 2} Call an R script from Stata.


{title:Syntax}

{p 8 14 2}{cmd:rscript} {cmd:using} {it:filename.R}, [{cmd:rpath(}{it:pathname}{cmd:)} {cmd:args(}{it:stringlist}{cmd:) {cmd:force}}]

{p 4 4 2}where

{p 8 14 2}{it: pathname} specifies the location of the R executable, and

{p 8 14 2}{it: stringlist} is a list of quoted strings.


{p 4 4 2}By default, {cmd:rscript} calls the R executable specified by the global macro RSCRIPT_PATH.


{title:Description}

{p 4 4 2}{cmd:rscript} calls {it:filename.R} from Stata. It displays the R output (and errors, if applicable) in the Stata console.


{title:Options}

{p 4 8 2}
{cmd:rpath(}{it:pathname}{cmd:)} specifies the location of the R executable. The default is to call the executable specified by the global macro RSCRIPT_PATH.

{p 4 8 2}
{cmd:args(}{it:stringlist}{cmd:)} specifies arguments to pass along to R.

{p 4 8 2}
{cmd:force} instructs {cmd:rscript} not to break when {it:filename.R} generates an error during execution.


{title:Notes}

{p 4 8 2}{cmd:rscript} has been tested on Windows, Mac OS X, and Unix (tcsh shell).
For ease of use, we recommend defining the global RSCRIPT_PATH in your Stata {help profile:profile}.


{title:Examples}

{p 4 4 2}1.  Call an R script using the default location specified by RSCRIPT_PATH and pass along the names of an input file and output file.

{col 8}{cmd:. global RSCRIPT_PATH "/usr/local/bin/Rscript"}
{col 8}{cmd:. rscript using my_script.R, args("input_file.txt" "output_file.txt")}


{p 4 4 2}2.  Same as Example 1, but specify the location of your R executable using the {cmd:rpath()} option.

{col 8}{cmd:. rscript using my_script.R, rpath("/usr/local/bin/Rscript") args("input_file.txt" "output_file.txt")}


{title:Authors}

{p 4 4 2}David Molitor, University of Illinois

{p 4 4 2}dmolitor@illinois.edu


{p 4 4 2}Julian Reif, University of Illinois

{p 4 4 2}jreif@illinois.edu


{title:Also see}

{p 4 4 2}{help rsource:rsource} (if installed)

