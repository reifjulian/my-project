# Sample replication package

This repository includes a short paper and its accompanying replication code. Download this repository by clicking on the green "Clone or download" button above, or by downloading this [zip file](https://github.com/reifjulian/my-project/archive/master.zip). The folder [analysis](analysis) replicates the figures and tables for the manuscript located in folder [paper](paper). An accompanying Stata coding guide is available [here](https://reifjulian.github.io/guide).

The analysis was written in Stata and includes a subroutine written in *R*. If you don't want to install *R*, follow the instructions in the [README](analysis/README.pdf) to skip that portion of the analysis.

This sample replication package serves several purposes:
1. Provide [example Stata code](analysis/scripts/4_make_tables_figures.do) that automates the creation of tables and figures for a manuscript
1. Provide an example of a [standalone replication package](analysis) and its corresponding [manuscript materials](paper)
1. Provide supporting materials for an accompanying [Stata coding guide](https://reifjulian.github.io/guide).

## Notes

The [analysis](analysis) folder can be renamed without breaking the replication code. 

The folder [paper](paper) is included for pedagogical purposes: it shows how to incorporate the [tables](analysis/results/tables) and [figures](analysis/results/figures) produced by the analysis into a LaTeX manuscript.

## Author

[Julian Reif](http://www.julianreif.com)
<br>University of Illinois
<br>jreif@illinois.edu
