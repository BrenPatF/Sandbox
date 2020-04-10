@..\install_prereq\initspool install_fan_foot
/***************************************************************************************************
GitHub Project: sql_demos - Brendan's repo for interesting SQL
                https://github.com/BrenPatF/sql_demos

Author:         Brendan Furey, 11 November 2017
Description:    Installation script for fan_foot schema for the project. Schema fan_foot is for the
                SQL problem described in the article below. It creates and populates the tables used
                by the two different example problems; gathers schema statistics; creates the
                 package used by the pipelined function solution.

Further details: 'SQL for the Fantasy Football Knapsack Problem', June 2013
                 http://aprogrammerwrites.eu/?p=878
***************************************************************************************************/

@..\c_syns_all

@setup_bra
@setup_eng
@setup_sml
EXECUTE DBMS_Stats.Gather_Schema_Stats(ownname => 'FAN_FOOT');
@item_cats.pks
@item_cats.pkb
@..\install_prereq\endspool
