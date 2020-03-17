# Sample replication package

This repository includes a short paper and its accompanying replication code. Download this repository by clicking on the green "Clone or download" button above, or by downloading this [zip file](https://github.com/reifjulian/coding-example/archive/master.zip). The folder `MyProject/analysis` is a stand-alone analysis that replicates the figures and tables for the manuscript located in `MyProject/paper`. An accompanying Stata coding guide is available [here](https://reifjulian.github.io/guide).

The analysis was written in Stata and includes a subroutine that was written in *R*. If you don't want to install *R*, follow the instructions in the [README](MyProject/analysis/README.pdf) to skip that portion of the analysis.

This sample replication package serves several purposes:
1. Provide [example Stata code](MyProject/analysis/scripts/4_make_tables_figures.do) that automates the creation of tables and figures for a manuscript
1. Provide an example of a [standalone replication package](MyProject/analysis) and its corresponding [manuscript materials](MyProject/paper)
1. Provide supporting materials for an accompanying [Stata coding guide](https://reifjulian.github.io/guide).

## Notes

A typical publication would only publish the folder `MyProject/analysis`. (Note that the `analysis` folder can be renamed without breaking the code.) This repository additionally includes `MyProject/paper` so that users can see how to link the output from `MyProject/analysis` to a paper written in LaTeX.

## Author

[Julian Reif](http://www.julianreif.com)
<br>University of Illinois
<br>jreif@illinois.edu
