# Sample replication package

This repository includes a short paper and its accompanying replication code. Download this repository by clicking on the green "Clone or download" button above, or click [here](https://github.com/reifjulian/my-project/archive/master.zip). The folder [analysis](analysis) replicates the figures and tables for the manuscript located in folder [paper](paper). 

The analysis was written in Stata and includes a subroutine written in *R*. If you don't want to install *R*, set `global DisableR = 0` in **run.do**. More information is available in the [README](analysis/README.pdf).

This sample replication package serves several purposes:
1. Provide supporting materials for an accompanying [Stata coding guide](https://reifjulian.github.io/guide).
1. Provide [example Stata code](analysis/scripts/4_make_tables_figures.do) that automates the creation of tables and figures for a manuscript
1. Provide an example of a cross-platform, standalone replication package that is compliant with the AEA's [data and code availability policy](https://www.aeaweb.org/journals/policies/data-code)
1. Provide a template LaTeX manuscript

## Notes

The [paper](paper) folder is included for pedagogical purposes: it shows how to incorporate the [tables](analysis/results/tables) and [figures](analysis/results/figures) produced by the analysis into a LaTeX manuscript.

## Author

[Julian Reif](http://www.julianreif.com)
<br>University of Illinois
<br>jreif@illinois.edu
