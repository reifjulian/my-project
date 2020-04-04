# Sample replication package

This repository includes a short paper and its accompanying replication code. Download this repository by clicking on the green "Clone or download" button above, or by downloading this [zip file](https://github.com/reifjulian/my-project/archive/master.zip). The folder `MyProject/analysis` is a stand-alone analysis that replicates the figures and tables for the manuscript located in `MyProject/paper`. An accompanying Stata coding guide is available [here](https://reifjulian.github.io/guide).

The analysis was written in Stata and includes a subroutine that was written in *R*. If you don't want to install *R*, follow the instructions in the [README](analysis/README.pdf) to skip that portion of the analysis.

This sample replication package serves several purposes:
1. Provide [example Stata code](analysis/scripts/4_make_tables_figures.do) that automates the creation of tables and figures for a manuscript
1. Provide an example of a [standalone replication package](analysis) and its corresponding [manuscript materials](paper)
1. Provide supporting materials for an accompanying [Stata coding guide](https://reifjulian.github.io/guide).

## Notes

The standalone replication code is all stored in the folder [analysis](analysis). The analysis folder can be renamed without breaking the replication code. 

This repository additionally includes the folder [paper](paper) for pedagogical purposes: it allows users to see how to link the analysis output to a paper written in LaTeX.

## Author

[Julian Reif](http://www.julianreif.com)
<br>University of Illinois
<br>jreif@illinois.edu
