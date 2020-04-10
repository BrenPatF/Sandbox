@..\install_prereq\initspool main_sml
/***************************************************************************************************
GitHub Project:  sql_demos - Brendan's repo for interesting SQL
                 https://github.com/BrenPatF/sql_demos

Author:          Brendan Furey, 22 June 2013
Description:     Driving script for the Brazil dataset for the fantasy football problem: Creates the
                 view; sets bind variables; calls Run_Queries.sql

Further details: 'SQL for the Fantasy Football Knapsack Problem', June 2013
                 http://aprogrammerwrites.eu/?p=878
***************************************************************************************************/

PROMPT Point view at small tables and set small bind variables
CREATE OR REPLACE VIEW positions(
        id,
        min_players,
        max_players
) AS SELECT
        id,
        min_items,
        max_items
  FROM small_categories
/
DROP VIEW players
/
CREATE OR REPLACE VIEW players(
        id,
        club_name,
        player_name,
        position_id,
        price,
        avg_points,
        appearances
) AS
SELECT  id,
        '',
        item_name,
        category_id,
        price,
        value,
        0
  FROM small_items
/
VAR KEEP_NUM NUMBER
VAR MAX_PRICE NUMBER
BEGIN
  :KEEP_NUM := 40;
  :MAX_PRICE := 5;
END;
/
START run_queries_fft
@..\install_prereq\EndSpool