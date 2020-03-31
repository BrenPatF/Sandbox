# sql_demos / bal_num_part
<img src="../mountains.png">
This project stores the SQL code for solutions to interesting problems I have looked at on my blog, or elsewhere. It includes installation scripts with component creation and data setup, and scripts to run the SQL on the included datasets.
<br><br>

The `bal_num_part` subproject has SQL solutions to balanced number partitioning problems problems as discussed in the following blog post:
<br>

- [SQL for the Balanced Number Partitioning Problem, May 2013](http://aprogrammerwrites.eu/?p=803)

[Back to main README: sql_demos](../README.md)
## In this README...
- [Prerequisites](https://github.com/BrenPatF/Sandbox/blob/master/bal_num_part/README.md#prerequisites)
- [Install steps](https://github.com/BrenPatF/Sandbox/blob/master/bal_num_part/README.md#install-steps)
- [Balanced Number Partitioning problems](https://github.com/BrenPatF/Sandbox/blob/master/bal_num_part/README_bnp.md#balanced-number-partitioning-problems)
	- [Example: Four Items](https://github.com/BrenPatF/Sandbox/blob/master/bal_num_part/README_bnp.md#example-four-items)
	- [Example: Six Items](https://github.com/BrenPatF/Sandbox/blob/master/bal_num_part/README_bnp.md#example-six-items)
	- [Running the bal_num_part scripts](https://github.com/BrenPatF/Sandbox/blob/master/bal_num_part/README_bnp.md#running-the-bal_num_part-scripts)

## Prerequisites
In order to install this subproject you need to have executed the first two parts of the installation in [main README: sql_demos](../README.md), i.e. `Install prerequisite modules` and `Create sql_demos common components`. If you executed the third part, `Subproject install steps`, you will have already installed this subproject and can run the scripts directly, see `Running the script` sections below.

## Install steps
- Update the login script bal_num_part.bat with your own connect string
- Run script from slqplus:
```
SQL> @install_bal_num_part
```
## Balanced Number Partitioning problems

Balanced Number Partitioning problems are a form of bin-fitting problem in which the aim is to distribute numbers across a fixed number of bins in such a way that the bin totals are as close as possible. An interesting article in American Scientist, <a href="http://www.americanscientist.org/issues/pub/2002/3/the-easiest-hard-problem" target="_blank">The Easiest Hard Problem</a>, notes that the problem is <em>NP-complete</em>, or <em>certifiably hard</em>, but that simple <em>greedy</em> heuristics often produce a good solution, including one used by schoolboys to pick football teams.

The blog post considers three variants of the *greedy* algorithm and implements them variously using recursive SQL and PL/SQL. The three variants, which are explained in the blog post, are named as follows:

- Greedy Algorithm (GDY)
- Greedy Algorithm with Batched Rebalancing (GBR)
- Greedy Algorithm with No Rebalancing – or, Team Picking Algorithm (TPA)

I illustrated the problem and the results from applying the different algorithm variants on two small example problems:

### Example: Four Items

<img src="Binfit, v1.3 - 4-items.jpg">

Here we see that the Greedy Algorithm finds the perfect solution, with no difference in bin size, but the two variants have a difference of two.

### Example: Six Items

<img src="Binfit, v1.3 - 6-items.jpg">

Here we see that none of the algorithms finds the perfect solution. Both the standard Greedy Algorithm and its batched variant give a difference of two, while the variant without rebalancing gives a difference of four.

### Running the bal_num_part scripts
[Schema: bal_num_part; Folder: bal_num_part]

The scripts solve randomly generated problems using several methods, and include automatically generated execution plans. The two driver scripts call pop_data_bnp.sql passing an N_ITEMS parameter to generate N_ITEMS items with a random value between 0 and N_ITEMS. They then call a script to run the queries, passing an N_BINS parameter for the number of bins, currently set to 3 for both scripts.

The first script is for a smaller value of N_ITEMS = 100, and the query script lists the full solutions.
```
SQL> @main_sml
```
The above script runs the following two lines:
```
	@pop_data_bnp 100
	@run_queries_bnp 3
```

The second script is for a larger value of N_ITEMS = 10000, and the query script lists the solutions grouped by bin.
```
SQL> @main_big
```
The above script runs the following two lines:
```
	@pop_data_bnp 10000
	@run_queries_agg_bnp 3
```
