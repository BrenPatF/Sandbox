# sql_demos - Brendan's repo for interesting SQL<div id="topOfVisibleArea"></div>
<img src="mountains.png">
This project stores the SQL code for solutions to interesting problems I have looked at on my blog, or elsewhere. It includes installation scripts with object creation and data setup, and scripts to run the SQL on the included datasets.

:file_cabinet: :slot_machine: :question: :outbox_tray:

The idea is that anyone with the pre-requisites should be able to reproduce my results within a few minutes of downloading the repo.

The installation scripts will create a common components schema, lib, and a separate schema for each problem, of which there are five at present. The sys and lib components are in the folder lib, with the problem-specific scripts in a separate folder for each one.

## In this README...
- [Subproject README and Blog Links](https://github.com/BrenPatF/Sandbox#subproject-readme-and-blog-links)
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

Here is a summary article that embeds all of the above plus another couple of relevant articles: <a href="http://aprogrammerwrites.eu/?p=2232" target="_blank">Knapsacks and Networks in SQL</a>, December 2017

## Prerequisites
In order to install this project you need to have sys access to an Oracle database, minimum version 11.2, along with a suitable database server directory to use for loading data via external tables.

## Installation
- [In this README...](https://github.com/BrenPatF/Sandbox#in-this-readme)
- [Install 1: Install prerequisite module](https://github.com/BrenPatF/Sandbox#install-1-install-prerequisite-module)
- [Install 2: Create sql_demos common components](https://github.com/BrenPatF/Sandbox#install-2-create-sql_demos-common-components)
- [Install 3: Subproject install steps](https://github.com/BrenPatF/Sandbox#install-3-subproject-install-steps)

The install depends on the prerequisite module Utils and `lib` schema refers to the schema in which Utils is installed.

### Install 1: Install prerequisite module
- [Installation](https://github.com/BrenPatF/Sandbox#installation)

The prerequisite module can be installed by following the instructions at [Utils on GitHub](https://github.com/BrenPatF/oracle_plsql_utils). This allows inclusion of the example and unit tests for the module. Alternatively, the next section shows how to install the modules directly without the example or unit tests here.

#### [Schema: sys; Folder: install_prereq] Create lib and app schemas and Oracle directory
install_sys.sql creates an Oracle directory, `input_dir`, pointing to 'c:\input'. Update this if necessary to a folder on the database server with read/write access for the Oracle OS user
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
- install_sys.sql drops the app schema that is not needed, creates a schema for each subproject and grants privileges to the new schemas.
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

## License
MIT
