CREATE OR REPLACE PACKAGE Packing_PLF IS
/***************************************************************************************************
GitHub Project:  sql_demos - Brendan's repo for interesting SQL
                 https://github.com/BrenPatF/sql_demos

Author:          Brendan Furey, 1 January 2013
Description:     Brendan's pipelined function solution for the knapsack problem with one container.
                 Note that it reads the items from a view, and takes limit as parameter. This 
                 version uses a nested table with linked varray to store the solutions, and is the 
                 one used in the article below

Further details: 'A Simple SQL Solution for the Knapsack Problem (SKP-1)', January 2013
                 http://aprogrammerwrites.eu/?p=560
***************************************************************************************************/

FUNCTION Best_Fits (p_weight_limit NUMBER) RETURN SYS.ODCIVarchar2List PIPELINED;

END Packing_PLF;
/
