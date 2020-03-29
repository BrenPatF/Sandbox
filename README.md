# sql_demos - Brendan's repo for interesting SQL<div id="topOfVisibleArea"></div>
<img src="mountains.png">
This project stores the SQL code for solutions to interesting problems I have looked at on my blog, or elsewhere. It includes installation scripts with object creation and data setup, and scripts to run the SQL on the included datasets.

:file_cabinet: :slot_machine: :question: :outbox_tray:

The idea is that anyone with the prerequisites should be able to reproduce my results within a few minutes of downloading the repo.

The installation scripts will create a common components schema, lib, and a separate schema, with its own folder, for each problem, of which there are five at present.

## In this README...
- [Subproject README and Blog Links](https://github.com/BrenPatF/Sandbox#subproject-readme-and-blog-links)
- [Execution Plans and Code Timing](https://github.com/BrenPatF/Sandbox#execution-plans-and-code-timing)
- [Prerequisites](https://github.com/BrenPatF/Sandbox#prerequisites)
- [Installation](https://github.com/BrenPatF/Sandbox#installation)
- [Operating System/Oracle Versions](https://github.com/BrenPatF/Sandbox#operating-systemoracle-versions)

## Subproject README and Blog Links
- [In this README...](https://github.com/BrenPatF/Sandbox#in-this-readme)

- [README: knapsack](knapsack/README.md)
	- [A Simple SQL Solution for the Knapsack Problem (SKP-1), January 2013](http://aprogrammerwrites.eu/?p=560)
	- [An SQL Solution for the Multiple Knapsack Problem (SKP-m), January 2013](http://aprogrammerwrites.eu/?p=635)

- [README: bal_num_part](bal_num_part/README.md)
	- [SQL for the Balanced Number Partitioning Problem, May 2013](http://aprogrammerwrites.eu/?p=803)

- [README: fan_foot](fan_foot/README.md)
	- [SQL for the Fantasy Football Knapsack Problem, June 2013](http://aprogrammerwrites.eu/?p=878)

- [README: tsp](tsp/README.md)
	- [SQL for the Travelling Salesman Problem, July 2013](http://aprogrammerwrites.eu/?p=896)

- [README: shortest_path](shortest_path/README.md)
	- [SQL for Shortest Path Problems, April 2015](http://aprogrammerwrites.eu/?p=1391)
	- [SQL for Shortest Path Problems 2: A Branch and Bound Approach, May 2015](http://aprogrammerwrites.eu/?p=1415)

Here is a summary article that embeds all of the above plus another couple of relevant articles:

[Knapsacks and Networks in SQL, December 2017](http://aprogrammerwrites.eu/?p=2232)

## Execution Plans and Code Timing
- [In this README...](https://github.com/BrenPatF/Sandbox#in-this-readme)
- [Getting the SQL query execution plan](https://github.com/BrenPatF/Sandbox#getting-the-sql-query-execution-plan)
- [PL/SQL Code timing](https://github.com/BrenPatF/Sandbox#plsql-code-timing)

In performance analysis of SQL and PL/SQL code, Oracle provides a number of useful tools, including a package for displaying a query execution plan, and access to CPU and elapsed times. The prerequisite modules provide wrappers to facilitate the use of these features.

### Getting the SQL query execution plan
- [Execution Plans and Code Timing](https://github.com/BrenPatF/Sandbox#execution-plans-and-code-timing)

Oracle provides a package DBMS_XPlan that allows you to obtain the execution plan actually followed for a given query, identified by the `sql_id`. You get the sql_id by querying the system view v$sql and identifying the correct row for your query.

The prerequisite [Utils](https://github.com/BrenPatF/oracle_plsql_utils) module includes a function Get_XPlan that generates the plan automatically by searching v$sql for the last instance of a marker string, then passing the sql_id into the DBMS_XPlan call.

In order for Oracle to provide actual row and other useful statistics in the plan, the hint `gather_plan_statistics` may be included in the query. If a marker string, say 'FF_PL' is also included, then passing this string into the Utils function allows the correct sql_id to be identified:

`Utils.Get_XPlan(p_sql_marker => 'FF_PLF')`

Here is an example of the query and function call from the fanfoot subproject, followed by the resulting output plan:

	SELECT /*+ gather_plan_statistics FF_PLF */
	       t.sol_profit, 
	       t.sol_price,
	       Dense_Rank() OVER (ORDER BY t.sol_profit DESC, t.sol_price) RNK,
	       p.position_id,
	       t.item_id, 
	       p.player_name,
	       p.club_name,
	       p.price,
	       p.avg_points
	  FROM TABLE (Item_Cats.Best_N_Sets (
	                  p_keep_size => :KEEP_NUM, 
	                  p_max_calls => 10000000,
	                  p_n_size => 10, 
	                  p_max_price => :MAX_PRICE,
	                  p_cat_cur => CURSOR (
	                      SELECT id, min_players, max_players
	                        FROM positions
	                       ORDER BY CASE WHEN id != 'AL' THEN 0 END, id
	                      ), 
	                  p_item_cur => CURSOR (
	                      SELECT id, price, avg_points, position_id
	                        FROM players
	                       ORDER BY position_id, avg_points DESC
	                      )
	             )) t
	  JOIN players p
	    ON p.id = t.item_id
	  ORDER BY t.sol_profit DESC, t.sol_price, p.position_id, t.item_id
	/
	EXECUTE Utils.W(Utils.Get_XPlan(p_sql_marker => 'FF_PLF'));

#### Output

	Plan hash value: 1973281990
	------------------------------------------------------------------------------------------------------------------------------------------
	| Id  | Operation                           | Name          | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
	------------------------------------------------------------------------------------------------------------------------------------------
	|   0 | SELECT STATEMENT                    |               |      1 |        |    110 |00:16:30.39 |      36 |       |       |          |
	|   1 |  WINDOW SORT                        |               |      1 |   5543 |    110 |00:16:30.39 |      36 | 20480 | 20480 |18432  (0)|
	|*  2 |   HASH JOIN                         |               |      1 |   5543 |    110 |00:16:30.19 |      36 |  1115K|  1115K| 1306K (0)|
	|*  3 |    TABLE ACCESS FULL                | EPL_PLAYERS   |      1 |    575 |    576 |00:00:00.01 |      15 |       |       |          |
	|   4 |    COLLECTION ITERATOR PICKLER FETCH| BEST_N_SETS   |      1 |   8168 |    110 |00:16:30.18 |      21 |       |       |          |
	|   5 |     SORT ORDER BY                   |               |      0 |      5 |      0 |00:00:00.01 |       0 | 73728 | 73728 |          |
	|   6 |      TABLE ACCESS FULL              | EPL_POSITIONS |      0 |      5 |      0 |00:00:00.01 |       0 |       |       |          |
	|   7 |     SORT ORDER BY                   |               |      0 |    575 |      0 |00:00:00.01 |       0 | 73728 | 73728 |          |
	|*  8 |      TABLE ACCESS FULL              | EPL_PLAYERS   |      0 |    575 |      0 |00:00:00.01 |       0 |       |       |          |
	------------------------------------------------------------------------------------------------------------------------------------------
	Predicate Information (identified by operation id):
	---------------------------------------------------
	2 - access("ID"=TO_NUMBER(SYS_OP_ATG("KOKBF$0"."SYS_NC_ROWINFO$",2,3,2)))
	3 - filter("POINTS">0)
	8 - filter("POINTS">0)

### PL/SQL Code timing
- [Execution Plans and Code Timing](https://github.com/BrenPatF/Sandbox#execution-plans-and-code-timing)

The prerequisite [Timer_Set](https://github.com/BrenPatF/timer_set_oracle) module allows you to obtain CPU and elapsed timings, as well as numbers of calls, for sections of PL/SQL code. Here is an example of the formatted output from timing within the fan_foot function Item_Cats.Best_N_Sets:

	Timer Set: Best_N_Sets, Constructed at 26 Mar 2020 11:49:48, written at 12:12:08
	================================================================================
	Timer            Elapsed         CPU       Calls       Ela/Call       CPU/Call
	------------  ----------  ----------  ----------  -------------  -------------
	Pop_Arrays          0.01        0.01           1        0.00500        0.01000
	Try_Position     1340.70     1329.08           1     1340.69500     1329.08000
	Write_Sols          0.00        0.00           1        0.00000        0.00000
	Pipe                0.00        0.00           1        0.00100        0.00000
	(Other)             0.00        0.00           1        0.00000        0.00000
	------------  ----------  ----------  ----------  -------------  -------------
	Total            1340.70     1329.09           5      268.14020      265.81800
	------------  ----------  ----------  ----------  -------------  -------------
	[Timer timed (per call in ms): Elapsed: 0.01111, CPU: 0.01222]

It's also possible to do more general profiling of PL/SQL code using some standard Oracle tools, which I wrote about in:

[Notes on Profiling Oracle PL/SQL, March 2013](http://aprogrammerwrites.eu/?p=703).

## Prerequisites
In order to install this project you need to have sys access to an Oracle database, minimum version 11.2, along with a suitable database server directory to use for loading data via external tables.

## Installation
- [In this README...](https://github.com/BrenPatF/Sandbox#in-this-readme)
- [Install 1: Install prerequisite modules](https://github.com/BrenPatF/Sandbox#install-1-install-prerequisite-modules)
- [Install 2: Create sql_demos common components](https://github.com/BrenPatF/Sandbox#install-2-create-sql_demos-common-components)
- [Install 3: Subproject install steps](https://github.com/BrenPatF/Sandbox#install-3-subproject-install-steps)

### Install 1: Install prerequisite modules
- [Installation](https://github.com/BrenPatF/Sandbox#installation)

The install depends on the prerequisite modules Utils and Timer_Set, and `lib` schema refers to the schema in which they are installed.

The prerequisite modules can be installed by following the instructions for each module at the module root pages listed in the `See also` section below. This allows inclusion of the examples and unit tests for those modules. Alternatively, the next section shows how to install these modules directly without their examples or unit tests here.

#### [Schema: sys; Folder: install_prereq] Create lib and app schemas and Oracle directory
The install_sys.sql script creates an Oracle directory, `input_dir`, pointing to 'c:\input'. Update this if necessary to a folder on the database server with read/write access for the Oracle OS user
- Run script from slqplus:
```
SQL> @install_sys
```
This install creates an app schema, which is not used by the current project so will be dropped later, in the main install.

#### [Schema: lib; Folder: install_prereq\lib] Create lib components
- Run script from slqplus:
```
SQL> @install_lib_all
```

### Install 2: Create sql_demos common components
- [Installation](https://github.com/BrenPatF/Sandbox#installation)
#### [Schema: sys; Folder: (root)] Drop app schema, create subproject schemas and grant privilege
The install_sys.sql script drops the app schema that is not needed, creates a schema for each subproject and grants privileges to the new schemas.
- Run script from slqplus:
```
SQL> @install_sys
```

#### [Schema: lib; Folder: lib] Create lib components (grants to subproject schemas)
- Run script from slqplus:
```
SQL> @install_lib_all
```

### Install 3: Subproject install steps
- [Installation](https://github.com/BrenPatF/Sandbox#installation)

The subproject READMEs have the install and run steps, which are summarised below:
- Run the install script for each schema (as desired) to create the schema objects (you may need to update the login scripts `schema`.bat):
	- bal_num_part:  install_bal_num_part.sql
	- fan_foot:      install_fan_foot.sql
	- knapsack:      install_knapsack.sql
	- shortest_path: install_shortest_path.sql
	- tsp:           install_tsp.sql
- Run main_*.sql as desired in the specific schemas to run the SQL for the different datasets and get execution plans and results logs. For example, for fan_foot: main_bra.sql and main_eng.sql are the driving scripts

## Video
The installation is demonstrated in a short video (8 minutes). It doesn't cover the most recent schemas but the same pattern is followed for those. As it is 170MB in size I placed it in a shared Microsoft One-Drive location:
https://1drv.ms/v/s!AtGOr6YOZ-yVh_1a6_g7XwX0TTBTgA

## Operating System/Oracle Versions
- [In this README...](https://github.com/BrenPatF/Sandbox#in-this-readme)

These are the OS and database versions most recently tested on, but the code should work from Oracle v11.2 on and should be OS-independent.
### Windows
Windows 10
### Oracle
Oracle Database Version 19.3.0.0.0

## See also
- [Utils - Oracle PL/SQL general utilities module](https://github.com/BrenPatF/oracle_plsql_utils)
- [Timer_Set - Oracle PL/SQL code timing module](https://github.com/BrenPatF/timer_set_oracle)

## License
MIT
