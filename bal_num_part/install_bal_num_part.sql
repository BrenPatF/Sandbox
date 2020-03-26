@..\install_prereq\initspool install_bal_num_part
/***************************************************************************************************
GitHub Project:  sql_demos - Brendan's repo for interesting SQL
                 https://github.com/BrenPatF/sql_demos

Author:          Brendan Furey, 15 November 2017
Description:     Installation script for bal_num_part schema for the project. Schema bal_num_part is
                 for theSQL problem described in the article below. It creates and populates the
                 tables used by the two different example problems; gathers schema statistics

Further details: 'SQL for the Balanced Number Partitioning Problem', May 2013
                 http://aprogrammerwrites.eu/?p=803
***************************************************************************************************/
@..\c_syns_all

@setup_bnp
@bin_fit.pks
@bin_fit.pkb
@..\install_prereq\endspool
