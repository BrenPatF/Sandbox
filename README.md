# sql_demos - Brendan's repo for interesting SQL<div id="topOfVisibleArea"></div>
<img src="mountains.png">
This project stores the SQL code for solutions to interesting problems I have looked at on my blog, or elsewhere. It includes installation scripts with object creation and data setup, and scripts to run the SQL on the included datasets.

:file_cabinet: :slot_machine: :question: :outbox_tray:

The idea is that anyone with the pre-requisites should be able to reproduce my results within a few minutes of downloading the repo.

The installation scripts will create a common objects schema, bren, and a separate schema for each problem, of which there are five at present. The sys and bren objects are in the folder bren, with the problem-specific scripts in a separate folder for each one.

## Subproject README and Blog Links

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

## Install Steps
### Common install steps (including creation of subproject schemas)
- Update install_sys.sql with the name of an input directory on your database server that can be used for external tables to read from (initially set to 'C:\input')
- Place all the files in the db_server_input folder there
#### [Schema: sys; Folder: bren] Create schemas
- Update the login script sys.bat for your own credentials for the sys schema (if necessary)
- Run script from slqplus, or other SQL client, to set up the bren common schema, and the problem-specific schemas:
```
SQL> @install_sys
```
#### [Schema: bren; Folder: bren] Create common components in bren schema
- Update the login script bren.bat for your own credentials for the bren schema (if necessary)
- Run script from slqplus, or other SQL client, to set up the bren common components:
```
SQL> @install_bren
```
### Subproject install steps
The subproject READMEs have the install and run steps, which are summarised below:
- Run the install script for each schema (as desired) to create the schema objects (you may need to update the login scripts `schema`.bat):
	- knapsack:      install_knapsack.sql
	- bal_num_part:  install_bal_num_part.sql
	- fan_foot:      install_fan_foot.sql
	- tsp:           install_tsp.sql
	- shortest_path: install_shortest_path.sql
- Run main_*.sql as desired in the specific schemas to run the SQL for the different datasets and get execution plans and results logs. For example, for fan_foot: main_bra.sql and main_eng.sql are the driving scripts

## Video
The installation is demonstrated in a short video (8 minutes). It doesn't cover the most recent schemas but the same pattern is followed for those. As it is 170MB in size I placed it in a shared Microsoft One-Drive location:
https://1drv.ms/v/s!AtGOr6YOZ-yVh_1a6_g7XwX0TTBTgA

## Operating System/Oracle Versions
These are the OS and database versions most recently tested on, but the code should work from Oracle v11.2 on and should be OS-independent.
### Windows
Windows 10
### Oracle
Oracle Database Version 19.3.0.0.0

## License
MIT
