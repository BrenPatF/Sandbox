@..\install_prereq\initspool install_knapsack
/***************************************************************************************************
GitHub Project: sql_demos - Brendan's repo for interesting SQL
                https://github.com/BrenPatF/sql_demos

Author:         Brendan Furey, 25 November 2017
Description:    Installation script for knapsack schema for the project. Schema knapsack is for the
                SQL problems described in the articles below. It creates and populates the tables
                used by the two different example problems; gathers schema statistics; creates the
                packages used by the pipelined function solutions.

Components created:

    Tables              Description
    =============       ===============================================================================
    items               Items
    containers          Containers

    Types               Description
    ==========          ==================================================================================
    con_itm_type        Container object (container and item ids)
    con_itm_list_type   (Varray) array of container object

    Packages            Description
    ================    ============================================================================
    Packing_PLF         Pipelined function solution for 1 container knapsack problem (varray version)
    Packing_Hash_PLF    Pipelined function solution for 1 container knapsack problem (hash version)
    Multi               Split_String pipelined function used in multi-container knapsack problem

    Statistics          Description
    ================    ===============================================================================
    KNAPSACK            Schema statistics

Further details: 'A Simple SQL Solution for the Knapsack Problem (SKP-1)'
                 http://aprogrammerwrites.eu/?p=560

                 'An SQL Solution for the Multiple Knapsack Problem (SKP-m)'
                 http://aprogrammerwrites.eu/?p=635
***************************************************************************************************/
@..\c_syns_all

PROMPT Create Single- and Multi-Container Knapsack tables...
PROMPT Table items
DROP TABLE items
/
CREATE TABLE items (
        id                NUMBER PRIMARY KEY,
        item_weight       NUMBER,
        item_profit       NUMBER
)
/
PROMPT Table containers
DROP TABLE containers
/
CREATE TABLE containers (
        id                NUMBER PRIMARY KEY,
        name              VARCHAR2(30),
        max_weight        NUMBER
)
/
DROP TYPE con_itm_list_type
/
CREATE OR REPLACE TYPE con_itm_type AS OBJECT (con_id NUMBER, itm_id NUMBER)
/
CREATE TYPE con_itm_list_type AS VARRAY(100) OF con_itm_type
/
EXECUTE DBMS_Stats.Gather_Schema_Stats(ownname => 'KNAPSACK');
@packing_plf.pks
@packing_plf.pkb
@packing_hash_plf.pks
@packing_hash_plf.pkb
@multi.pks
@multi.pkb
@..\install_prereq\endspool
