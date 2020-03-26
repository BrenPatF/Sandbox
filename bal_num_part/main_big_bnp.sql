@..\install_prereq\initspool main_big_bnp
/***************************************************************************************************
GitHub Project:  sql_demos - Brendan's repo for interesting SQL
                 https://github.com/BrenPatF/sql_demos

Author:          Brendan Furey, 17 November 2017
Description:     Driving script for the Balanced Number Partitioning Problem with the larger data 
                 set: Sets bind variables; calls Run_Queries_Agg_BNP.sql (aggregate queries)

Further details: 'SQL for the Balanced Number Partitioning Problem', May 2013
                 http://aprogrammerwrites.eu/?p=803
***************************************************************************************************/

@pop_data_bnp 10000
@run_queries_agg_bnp 3

@..\install_prereq\EndSpool