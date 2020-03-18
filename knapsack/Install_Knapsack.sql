@..\bren\initspool install_knapsack
/***************************************************************************************************
GitHub Project: sql_demos - Brendan's repo for interesting SQL
                https://github.com/BrenPatF/sql_demos

Author:         Brendan Furey, 25 November 2017
Description:    Installation script for knapsack schema for the project. Schema knapsack is for the
                SQL problems described in the articles below. It creates and populates the tables
                used by the two different example problems; gathers schema statistics; creates the
                packages used by the pipelined function solutions.

Further details: 'A Simple SQL Solution for the Knapsack Problem (SKP-1)'
                 http://aprogrammerwrites.eu/?p=560

                 'An SQL Solution for the Multiple Knapsack Problem (SKP-m)'
                 http://aprogrammerwrites.eu/?p=635
***************************************************************************************************/

@setup_knp
EXECUTE DBMS_Stats.Gather_Schema_Stats(ownname => 'KNAPSACK');
@..\c_syns_bren bren
@packing_plf.pks
@packing_plf.pkb
@multi.pks
@multi.pkb
@..\bren\endspool
