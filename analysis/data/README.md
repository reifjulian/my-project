# Files
auto.csv

# Source
Stata built-in dataset

Dataset was obtained by opening Stata 16 and executing the following code:

```stata
sysuse auto, clear
outsheet using "auto.csv", comma
```
