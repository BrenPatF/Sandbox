@..\install_prereq\initspool install_tsp
/***************************************************************************************************
GitHub Project: sql_demos - Brendan's repo for interesting SQL
                https://github.com/BrenPatF/sql_demos

Author:         Brendan Furey, 12 November 2017
Description:    Installation script for TSP schema for the project. Schema TSP is for the
                SQL problem described in the article below. It creates and populates the tables used
                by the two different example problems; gathers schema statistics

Further details: 'SQL for the Travelling Salesman Problem', July 2013
                 http://aprogrammerwrites.eu/?p=896
***************************************************************************************************/
@..\c_syns_all

@setup_eml
@setup_usc
EXECUTE DBMS_Stats.Gather_Schema_Stats(ownname => 'TSP');
@..\install_prereq\endspool
