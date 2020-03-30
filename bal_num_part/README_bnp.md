# sql_demos / bal_num_part
<img src="../mountains.png">
This project stores the SQL code for solutions to interesting problems I have looked at on my blog, or elsewhere. It includes installation scripts with component creation and data setup, and scripts to run the SQL on the included datasets.
<br><br>

The bal_num_part subproject has SQL solutions to single and multiple bal_num_part problems as discussed in the following blog posts:
<br>

- [SQL for the Balanced Number Partitioning Problem, May 2013](http://aprogrammerwrites.eu/?p=803)

[Back to main README: sql_demos](../README.md)
## In this README...
- [Prerequisites](https://github.com/BrenPatF/Sandbox/blob/master/bal_num_part/README.md#prerequisites)
- [Install steps](https://github.com/BrenPatF/Sandbox/blob/master/bal_num_part/README.md#install-steps)
- [bal_num_part problems](https://github.com/BrenPatF/Sandbox/blob/master/bal_num_part/README.md#bal_num_part-problems)
	- [One-bal_num_part problem](https://github.com/BrenPatF/Sandbox/blob/master/bal_num_part/README.md#one-bal_num_part-problem)
	- [Multi-bal_num_part problem](https://github.com/BrenPatF/Sandbox/blob/master/bal_num_part/README.md#multi-bal_num_part-problem)

## Prerequisites
In order to install this subproject you need to have executed the first two parts of the installation in [main README: sql_demos](../README.md), i.e. `Install prerequisite modules` and `Create sql_demos common components`. If you executed the third part, `Subproject install steps`, you will have already installed this subproject and can run the scripts directly, see `Running the script` sections below.

## Install steps
- Update the login script bal_num_part.bat with your own connect string
- Run script from slqplus:
```
SQL> @install_bal_num_part
```
## Balanced Number Partitioning problems

Balanced Number Partitioning problems are a form of bin-fitting problem in which the aim is to distribute numbers across a fixed number of bins in such a way that the nin totals are as close as possible. An interesting article in American Scientist, <a href="http://www.americanscientist.org/issues/pub/2002/3/the-easiest-hard-problem" target="_blank">The Easiest Hard Problem</a>, notes that the problem is <em>NP-complete</em>, or <em>certifiably hard</em>, but that simple <em>greedy</em> heuristics often produce a good solution, including one used by schoolboys to pick football teams.

The blog post considers three variants of the *greedy* algorithm and implements them variously using recursive SQL and PL/SQL. The three variants, which are explained in the blog post, are named as follows:

- Greedy Algorithm (GDY)
- Greedy Algorithm with Batched Rebalancing (GBR)
- Greedy Algorithm with No Rebalancing – or, Team Picking Algorithm (TPA)

I illustrated the problem and the results from applying the different algorithm variants on two small example problems:

Example: Four Items

<img src="Binfit, v1.3 - 4-items.jpg">

Here we see that the Greedy Algorithm finds the perfect solution, with no difference in bin size, but the two variants have a difference of two.

Example: Six Items

<img src="Binfit, v1.3 - 6-items.jpg">

Here we see that none of the algorithms finds the perfect solution. Both the standard Greedy Algorithm and its batched variant give a difference of two, while the variant without rebalancing gives a difference of four.


#### [Schema: bal_num_part; Folder: bal_num_part] Running the multi-bal_num_part script
The script solves the small example problem using several methods, and includes automatically generated execution plans.
```
SQL> @main_sml
SQL> @main_big
```
