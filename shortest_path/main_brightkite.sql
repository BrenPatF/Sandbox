@..\install_prereq\initspool main_brightkite
/***************************************************************************************************
GitHub Project:  sql_demos - Brendan's repo for interesting SQL
                 https://github.com/BrenPatF/sql_demos

Author:          Brendan Furey, 19 November 2017
Description:     Driving script for the Brightkite dataset: Creates the view; calls 
                 Run_Queries_SP.sql (script implementing ideas in second post below)

Further details: 'SQL for Shortest Path Problems', April 2015
                 http://aprogrammerwrites.eu/?p=1391

                 'SQL for Shortest Path Problems 2: A Branch and Bound Approach', May 2015
                 http://aprogrammerwrites.eu/?p=1415

***************************************************************************************************/
PROMPT Point view to arcs_brightkite
CREATE OR REPLACE VIEW arcs_v AS
SELECT src, dst
  FROM arcs_brightkite
/
REM 0 big 51944 small
@run_queries_sp 51944 5

@..\install_prereq\endspool