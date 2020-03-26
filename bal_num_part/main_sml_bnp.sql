@..\install_prereq\initspool main_sml_bnp
/***************************************************************************************************
GitHub Project:  sql_demos - Brendan's repo for interesting SQL
                 https://github.com/BrenPatF/sql_demos

Author:          Brendan Furey, 12 November 2017
Description:     Driving script for the Balanced Number Partitioning Problem with the smaller data 
                 set: Sets bind variables; calls Run_Queries_BNP.sql (detail queries)

Further details: 'SQL for the Balanced Number Partitioning Problem', May 2013
                 http://aprogrammerwrites.eu/?p=803
***************************************************************************************************/

@pop_data_bnp 100
@run_queries_bnp 3

@..\install_prereq\endspool