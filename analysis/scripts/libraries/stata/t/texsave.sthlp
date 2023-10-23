{smcl}
{hi:help texsave}
{hline}
{title:Title}

{p 4 4 2}{cmd:texsave} {hline 2} Save dataset in LaTeX format.


{title:Syntax}

{p 8 14 2}{cmd:texsave} [{it:varlist}] {cmd:using} {it:filename} [if] [in] [, {cmd:title(}{it:string}{cmd:)} {cmd:footnote(}{it:footnote_suboptions}{cmd:)} 
 {cmd:autonumber} {cmdab:varlab:els} {cmd:hlines(}{help numlist:numlist}{cmd:)} 
 {cmd:label(}{it:string}{cmd:)} {cmd:size(}{it:string}{cmd:)} {cmdab:land:scape}   {cmd:replace} 
{it:spacing_options} {it:code_options} {it:format_options} {it:other_options}]

{p 4 4 2}where

{p 8 14 2}{it:footnote_suboptions} are

{p 12 14 2}{cmd:footnote(}{it:string} [, {cmd:size(}{it:string}{cmd:)} {cmd:addlinespace(}{it:string}{cmd:)} {cmd:width(}{it:string}{cmd:)}]{cmd:)}

{p 8 14 2}{it:spacing_options} are

{p 12 14 2} {cmdab:geo:metry(}{it:string}{cmd:)} 
{cmd:width(}{it:string}{cmd:)} {cmd:headersep(}{it:string}{cmd:)} 
{cmd:rowsep(}{it:string}{cmd:)}  {cmd:rowstretch(}{it:#}{cmd:)} {cmd:rowheight(}{it:string}{cmd:)} 
{cmd:colwidth(}{it:string}{cmd:)}

{p 8 14 2}{it:code_options} are

{p 12 14 2} {cmd:preamble(}{it:stringlist}{cmd:)} {cmd:headlines(}{it:stringlist}{cmd:)} 
{cmd:tablelines(}{it:stringlist}{cmd:)} {cmd:headerlines(}{it:stringlist}{cmd:)} 
{cmd:footlines(}{it:stringlist}{cmd:)}

{p 8 14 2}{it:format_options} are

{p 12 14 2} {cmd:nofix} {cmd:noendash} {cmdab:decimal:align} 
{cmd:bold(}{it:stringlist}{cmd:)} {cmd:italics(}{it:stringlist}{cmd:)} 
{cmd:underline(}{it:stringlist}{cmd:)} {cmd:slanted(}{it:stringlist}{cmd:)} {cmd:smallcaps(}{it:stringlist}{cmd:)}
{cmd:sansserif(}{it:stringlist}{cmd:)} {cmd:monospace(}{it:stringlist}{cmd:)} {cmd:emphasis(}{it:stringlist}{cmd:)}

{p 8 14 2}and {it:other_options} are

{p 12 14 2} {cmdab:valuelab:els} {cmd:nonames} {cmd:frag} {cmd:dataonly} {cmdab:loc:ation(}{it:string}{cmd:)}
{cmd:align(}{it:string}{cmd:)} 


{title:Description}

{p 4 4 2}{cmd:texsave} outputs the dataset currently in memory to {it:filename} in LaTeX format. It uses the {it:booktabs}, {it:tabularx}, and {it:geometry} packages
to produce publication-quality tables. To link the table to an existing LaTeX document, follow these two steps:

{p 8 10 2}
1. Add the line {it:\usepackage{standalone}} to the document's preamble.

{p 8 10 2}
2. Add the line {it:\input{filename}} to the place where you want the table to appear in the document.

{title:Options}

{p 4 8 2}
{cmd:title(}{it:string}{cmd:)} writes out {it:string} as a caption above the table.


{p 4 8 2}
{cmd:footnote(}{it:string} [, {cmd:size(}{it:string}{cmd:)} {cmd:width(}{it:string}{cmd:)}] {cmd:addlinespace(}{it:string}{cmd:)}{cmd:)} writes out {it:string}
in a left-justified footnote at the bottom of the table.  The suboptions allow you to set the size and width of the 
footnote, using the same syntax described above by the {cmd:size(}{it:string}{cmd:)} and {cmd:width(}{it:string}{cmd:)} options. The {cmd:addlinespace(}{it:string}{cmd:)}
suboption writes out "\addlinespace[{it:string}]" just prior the footnote, allowing you to control the 
amount of spacing between the table and the footnote. (See {cmd:rowsep()} for examples of valid units.)
The default is "\addlinespace[\belowrulesep]".


{p 4 8 2}
{cmd:autonumber} writes out "(1)", "(2)"... in the first row of the table header, beginning with column two.  
This is useful when outputting regression results stored by a command like {help regsave:regsave} (if installed).


{p 4 8 2}
{cmd:varlabels} specifies that variable labels be written in the table header instead of variable names.


{p 4 8 2}
{cmd:hlines(}{help numlist:numlist}{cmd:)} draws horizontal lines below each row specified in {help numlist:numlist}.  Specify a row's number twice to output a double line. Negative 
values are interpreted as the distance from the end of the table.


{p 4 8 2}
{cmd:label(}{it:string}{cmd:)} uses LaTeX's {it:\label} option to mark your table with the key {it:string}.


{p 4 8 2}
{cmd:size(}{it:string}{cmd:)} specifies the size of your table.  Valid size options are tiny, scriptsize, footnotesize, small, normalsize, large, Large, LARGE, huge, and Huge.  
Alternatively, the user may specify a numeric value between 1 and 10, where 1 corresponds to tiny and 10 corresponds to Huge.


{p 4 8 2}
{cmd:landscape} specifies a landscape orientation instead of a portrait orientation. This requires the {it:pdflscape} package.


{p 4 8 2}
{cmd:replace} overwrites {it:filename}.


{p 4 8 2}
{it:spacing_options}:

{p 12 14 2}
{cmd:geometry(}{it:string}{cmd:)} specifies the page dimensions using the {it:geometry} package. The default is "margin=1in".

{p 12 14 2}
{cmd:width(}{it:string}{cmd:)} specifies the width of your table. Lengths can be specified in the same way as for {cmd:rowsep} (see below). The default is {it:\linewidth}.

{p 12 14 2}
{cmd:headersep(}{it:string}{cmd:)} adds vertical spacing of length {it:string} between the header row and the data rows via the {it:\addlinespace} command.
It uses the same syntax as {cmd:rowsep(}{it:string}{cmd:)}.
The default is "\addlinespace[\belowrulesep]".

{p 12 14 2}
{cmd:rowsep(}{it:string}{cmd:)} adds vertical spacing of length {it:string} to the rows via the {it:\addlinespace} command. 
The length can be expressed in the following units: {it:cm} (centimetres), {it:em} (the width of the letter M in the current font), {it:ex} 
(the height of the letter x in the current font), {it:in} (inches), {it:pc} (picas), {it:pt} (points) or {it:mm} (millimetres). 
For example, {cmd:rowsep(}{it:1cm}{cmd:)} adds one centimeter of vertical space between rows.

{p 12 14 2}
{cmd:rowstretch(}{it:#}{cmd:)} injects vertical space above and below cell text: "\renewcommand{\arraystretch}{#}". The default value is 1. Values larger than 1 increase spacing, values smaller than 1 decrease spacing.

{p 12 14 2}
{cmd:rowheight(}{it:string}{cmd:)} injects vertical space only above cell text: "\setlength\extrarowheight{{it:string}}". Lengths can be specified in the same way as for {cmd:rowsep}.

{p 12 14 2}
{cmd:colwidth(}{it:string}{cmd:)} modifies the column width: "\setlength{\tabcolsep}{{it:string}". Lengths can be specified in the same way as for {cmd:rowsep}. See also {cmd:align()}.


{p 4 8 2}
{it:code_options} insert customized LaTeX code into different parts of the table (see {ul:{bf:Notes}} section below for table structure):

{p 12 14 2}
{cmd:preamble(}{it:stringlist}{cmd:)} specifies lines of LaTeX code to appear before "\begin{document}".  Each line of code should be surrounded by quotation marks (see example 4 below).

{p 12 14 2}
{cmd:headlines(}{it:stringlist}{cmd:)} specifies lines of LaTeX code to appear between "\begin{document}" and "\begin{table}".  Each line of code should be surrounded by quotation marks (see example 4 below).

{p 12 14 2}
{cmd:tablelines(}{it:stringlist}{cmd:)} specifies lines of LaTeX code to appear between "\begin{table}" and "\begin{tabularx}".  Each line of code should be surrounded by quotation marks (see example 4 below).

{p 12 14 2}
{cmd:headerlines(}{it:stringlist}{cmd:)} specifies lines of LaTeX code to appear between "\begin{tabularx}" and the table header.  Each line of code should be surrounded by quotation marks (see example 5 below). 
By default, {cmd:headerlines()} appends "\tabularnewline" to the end of each string.
Use the alternative option {cmd:headerlines2(}{it:stringlist}{cmd:)} if you don't want to append "\tabularnewline".

{p 12 14 2}
{cmd:footlines(}{it:stringlist}{cmd:)} specifies lines of LaTeX code to appear after "\end{table}".  Each line of code should be surrounded by quotation marks (see example 4 below).


{p 4 8 2}
{it:format_options}:

{p 12 14 2}
{cmd:nofix} instructs {cmd:texsave} not to add a backslash ("\") in front of the following non-alphanumeric characters: _ % # $ & ~  ^ \ { }.
Adding the backslash is often required in order to avoid LaTeX compilation errors.

{p 12 14 2}
{cmd:noendash} specifies that negative signs ("-") not be converted to en dashes ("--") in the dataset.

{p 12 14 2}
{cmd:decimalalign} aligns numeric values at the decimal point using the {it:siunitx} package.

{p 12 14 2}
{cmd:bold(), italics(), underline(), slanted(), smallcaps(), sansserif(), monospace(),} and {cmd:emphasis()} allow you to format the data values in your table.  
For example, {cmd:underline(}{it:"word1" "word2"}{cmd:)} underlines all data values containing either {it:"word1"} or {it:"word2"}.


{p 4 8 2}
{it:other_options}:

{p 12 14 2}
{cmd:valuelabels} specifies that value labels of labeled variables be outputted instead of numeric values.

{p 12 14 2}
{cmd:nonames} specifies that variable names not be added to the table header.

{p 12 14 2}
{cmd:frag} omits from the output LaTeX code like {it:\begin{c -(}document{c )-}} that is needed to create a standalone document. This makes {it:filename} a fragment, which
is useful if you want to use LaTeX's {it:\input{c -(}table{c )-}} command to include your table as a subfile.
An alternative is to use the LaTeX package {browse "http://ctan.org/pkg/standalone":standalone}, which instructs LaTeX to skip extra preambles when including subfiles. 

{p 12 14 2}
{cmd:dataonly} is a programmer's option that outputs only the contents of the dataset.
It omits variable names, footnotes, and all other LaTeX code that surrounds the contents of the table. 
The resulting output will not compile into a table.

{p 12 14 2}
{cmd:location(}{it:string}{cmd:)} specifies the location of your table in the document.  It consists of one or more of the following specifiers:

{p 16 18 2}h - "Here": at the position in the text where the environment appears

{p 16 18 2}t - "Top": at the top of a text page

{p 16 18 2}b - "Bottom": at the bottom of a text page

{p 16 18 2}p - "Page": on a separate page containing no text, only figures and tables

{p 16 18 2}The default is {cmd:location(}{it:tbp}{cmd:)}.

{p 12 14 2}
{cmd:align(}{it:string}{cmd:)} specifies the column formatting. It generally consists of a sequence of the following specifiers, at least one for each of the columns: 

{p 16 18 2}l - a column of left-aligned items

{p 16 18 2}r - a column of right-aligned items

{p 16 18 2}c - a column of centered items

{p 16 18 2}L - a column of ragged-right items; text will wrap around

{p 16 18 2}R - a column of ragged-left items; text will wrap around

{p 16 18 2}C - a column of centered items; text will wrap around

{p 16 18 2}S - a column of numbers aligned at the decimal point; requires {cmd:decimalalign} option

{p 16 18 2}| - a vertical line the full height and depth of the environment. 
If there are three columns, specify {cmd:align(}{it:|l|C|C|}{cmd:)} to surround all columns with vertical lines.

{p 16 18 2}The default is to left-justify the first column and center and distribute space equally across the rest of the columns, which in the case of three columns corresponds to 
{cmd:align(}{it:lCC}{cmd:)}.


{title:Remarks}

{p 4 8 2} It is sometimes difficult to make {cmd:texsave} output a literal "$" because this can be interpreted by Stata as a global macro.
For example, "$R^2$" will be incorrectly outputted as "^2$".  You can avoid this problem by using the alternative LaTeX syntax "\(R^2\)".

{p 4 8 2} If your dataset includes LaTeX code, you will probably want to instruct {cmd:texsave} not to modify it by specifying the {cmd:nofix} option.

{p 4 8 2} {cmd:texsave} performs some basic error checking. For example, it issues an error if you specify horizontal lines at row values that do not exist. 
However, it does not check that tables with lots of alignment specifications etc. will compile correctly. 
It is your responsibility to ensure that you are supplying valid LaTeX code when specifying options such as {cmd:headlines()}, {cmd:align()} etc. 
See {browse "http://en.wikibooks.org/wiki/LaTeX/Tables"} to learn more about writing LaTeX code for tables.

{p 4 8 2} Occasionally you may want to modify a line in the output file that can't be automated using {cmd:texsave}'s options. 
The {help filefilter:filefilter} command is helpful in these cases. For example, the following command will remove the "\centering" from the first line of the table output:

{col 12}{cmd:. filefilter "myfile1.tex" "myfile2.tex", from("\begin{table}[tbp] \centering") to("\begin{table}[tbp]")}


{title:Notes}

{p 4 8 2}{cmd:texsave} creates a LaTeX table using the following basic structure:

{space 9}{it:\documentclass{article}}
{space 9}{it:\usepackage{booktabs}}
{space 9}{it:\usepackage{tabularx}}
{space 9}{it:\usepackage[margin=1in]{geometry}}
{space 9}{cmd:preamble(}{it:stringlist}{cmd:)}

{space 9}{it:\begin{document}}
{space 9}{cmd:headlines(}{it:stringlist}{cmd:)}

{space 9}{it:\begin{table}[tbp] \centering}
{space 9}{cmd:tablelines(}{it:stringlist}{cmd:)}
{space 9}{it:\newcolumntype{C}{>{\centering\arraybackslash}X}}
{space 9}{cmd:title(}{it:string}{cmd:)}

{space 9}\begin{tabularx}{\linewidth}{@{}lC...C@{}}
{space 9}{it:\toprule}
{space 9}{cmd:autonumber}
{space 9}{cmd:headerlines(}{it:stringlist}{cmd:)}

{space 9}[variable names]
{space 9}{it:\midrule\addlinespace[}{cmd:headersep(}{it:string}{cmd:)}{it:]}
{space 9}[data]

{space 9}{it:\bottomrule} \addlinespace[\belowrulesep]
{space 9}{it:\end{tabularx}}

{space 9}{it:\parbox{\linewidth}}{{it:\footnotesize} {cmd:footnote(}{it:string}{cmd:)}}
{space 9}{it:\end{table}}

{space 9}{cmd:footlines(}{it:stringlist}{cmd:)}
{space 9}{it:\end{document}}


{title:Examples}

{p 4 4 2}1.  Output a table with a title and a footnote.

{col 8}{cmd:. {stata sysuse auto.dta, clear}}

{col 8}{cmd:. {stata texsave make mpg trunk if price > 8000 using "example1.tex", title(MPG and trunk space) footnote(Variable trunk measured in cubic feet) replace}}


{p 4 4 2}2.  Output a table with a small font size and some horizontal lines.

{col 8}{cmd:. {stata sysuse auto.dta, clear}}

{col 8}{cmd:. {stata texsave make mpg trunk weight length displacement turn using "example2.tex" in 1/30, size(2) hlines(3 10/13 19 23 25 -2 30) replace}}


{p 4 4 2}3.  Output a table with non-variable name headers and LaTeX math code in the footnote.

{col 8}{cmd:. {stata sysuse auto.dta, clear}}

{col 8}{cmd:. {stata label var make "Car make"}}

{col 8}{cmd:. {stata label var mpg "Miles per gallon"}}

{col 8}{cmd:. {stata label var trunk "Trunk space"}}

{col 8}{cmd:. {stata texsave make mpg trunk if price > 8000 using "example3.tex", title(MPG and trunk space) varlabels footnote("Variable trunk measured in ft\(^3\)") nofix replace}}


{p 4 4 2}4. Output a table with additional LaTeX code.

{col 8}{cmd:. sysuse auto.dta, clear}

{col 8}{cmd:. texsave make mpg trunk if price > 8000 using "example4.tex", loc(h) preamble("\usepackage{amsfonts}") headlines("\begin{center}" "My headline" "\end{center}") footlines("My footline") replace}


{p 4 4 2}5. Output a table with a complicated header and bold-face the first observation.

{col 8}{cmd:. sysuse auto.dta, clear}

{col 8}{cmd:. texsave make mpg trunk if price > 8000 using "example5.tex", bold("Buick") headerlines("& \multicolumn{2}{c}{\textbf{Data}}" "\cmidrule{2-3}\addlinespace[-2ex]") nofix replace}


{title:Author}

{p 4 4 2}Julian Reif, University of Illinois

{p 4 4 2}jreif@illinois.edu


{p 4 4 2}Thanks to Kit Baum for helpful suggestions and feedback.


{title:Also see}

{p 4 4 2}
{help regsave:regsave} (if installed),
{help sortobs:sortobs} (if installed),
{help filefilter:filefilter}

