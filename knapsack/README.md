# sql_demos / knapsack
<img src="../mountains.png">
This project stores the SQL code for solutions to interesting problems I have looked at on my blog, or elsewhere. It includes installation scripts with object creation and data setup, and scripts to run the SQL on the included datasets.
<br><br>

The knapsack subproject has SQL solutions to single and multiple knapsack problems as discussed in the following blog posts:
<br>

- [A Simple SQL Solution for the Knapsack Problem (SKP-1), January 2013](http://aprogrammerwrites.eu/?p=560)
- [An SQL Solution for the Multiple Knapsack Problem (SKP-m), January 2013](http://aprogrammerwrites.eu/?p=635)

[Back to main README: sql_demos](../README.md)

## Prerequisites
In order to install this subproject you need to have executed the first two parts of the installation in [main README: sql_demos](../README.md), i.e. `Install prerequisite modules` and `Create sql_demos common components`. If you executed the third part, `Subproject install steps`, you will have already installed this subproject and can jump to `Running the scripts` below.

## Install steps
- Update the login script knapsack.bat with your own connect string
- Run script from slqplus:
```
SQL> @install_knapsack
```
## Running the scripts
### One-knapsack problem
```
SQL> @main_kp1
```
### Multi-knapsack problem
```
SQL> @main_kpm
```
