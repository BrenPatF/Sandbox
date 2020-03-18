# sql_demos / knapsack
<img src="mountains.png">
This project stores the SQL code for solutions to interesting problems I have looked at on my blog, or elsewhere. It includes installation scripts with object creation and data setup, and scripts to run the SQL on the included datasets.

The knapsack subproject has SQL solutions to single and multiple knapsack problems as discussed in the following blog posts:

<a href="http://aprogrammerwrites.eu/?p=560" target="_blank">A Simple SQL Solution for the Knapsack Problem (SKP-1)</a>, January 2013<br />
<a href="http://aprogrammerwrites.eu/?p=635" target="_blank">An SQL Solution for the Multiple Knapsack Problem (SKP-m)</a>, January 2013

- [Back to main README: sql_demos](../README.md)

Pre-requisites
==============
In order to install this project you need to have SYS access to an Oracle database, minimum version 11.2, along with a suitable database server directory to use for loading data via external tables.

Install steps
=============
        
2. Update the logon script knapsack.bat with your own connect string
3. Update Install_SYS.sql with the name of an input directory on your database server that can be used for external tables to read from, and place all the files in db_server_input there
4. Run Install_SYS.sql in SYS schema from SQL*Plus, or other SQL client, to set up the bren
common schema, and the problem-specific schemas
5. Run Install_bren.sql in bren schema to create the bren schema common objects
6. Run the install script for each schema to create the schema objects:
- knapsack:      install_knapsack.sql
- bal_num_part:  install_bal_num_part.sql
- fan_foot:      install_fan_foot.sql
- tsp:           install_tsp.sql
- shortest_path: install_shortest_path.sql
7. Run main_*.sql as desired in the specific schemas to run the SQL for the different datasets and
get execution plans and results logs. For example, for fan_foot: main_bra.sql and main_eng.sql are the driving scripts
