CREATE OR REPLACE PACKAGE BODY Packing_PLF IS
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

FUNCTION Best_Fits (p_weight_limit NUMBER) RETURN SYS.ODCIVarchar2List PIPELINED IS

  TYPE item_type IS RECORD (
                        item_id                 PLS_INTEGER,
                        item_index_parent       PLS_INTEGER,
                        weight_to_node          NUMBER);
  TYPE item_tree_type IS        TABLE OF item_type;
  g_solution_list               SYS.ODCINumberList;

  g_timer                       PLS_INTEGER := Timer_Set.Construct ('Pipelined Recursion');

  i                             PLS_INTEGER := 0;
  j                             PLS_INTEGER := 0;
  g_item_tree                   item_tree_type;
  g_item                        item_type;
  l_weight                      PLS_INTEGER;
  l_weight_new                  PLS_INTEGER;
  l_best_profit                 PLS_INTEGER := -1;
  l_sol                         VARCHAR2(4000);
  l_sol_cnt                     PLS_INTEGER := 0;

  FUNCTION Add_Node (  p_item_id               PLS_INTEGER,
                       p_item_index_parent     PLS_INTEGER, 
                       p_weight_to_node        NUMBER) RETURN PLS_INTEGER IS
  BEGIN

    g_item.item_id := p_item_id;
    g_item.item_index_parent := p_item_index_parent;
    g_item.weight_to_node := p_weight_to_node;
    IF g_item_tree IS NULL THEN

      g_item_tree := item_tree_type (g_item);

    ELSE

      g_item_tree.Extend;
      g_item_tree (g_item_tree.COUNT) := g_item;

    END IF;
    RETURN g_item_tree.COUNT;

  END Add_Node;

  PROCEDURE Do_One_Level (p_tree_index PLS_INTEGER, p_item_id PLS_INTEGER, p_tot_weight PLS_INTEGER, p_tot_profit PLS_INTEGER) IS

    CURSOR c_nxt IS
    SELECT id, item_weight, item_profit
      FROM items
     WHERE id > p_item_id
       AND item_weight + p_tot_weight <= p_weight_limit;
    l_is_leaf           BOOLEAN := TRUE;
    l_index_list        SYS.ODCINumberList;

  BEGIN

    FOR r_nxt IN c_nxt LOOP
      Timer_Set.Increment_Time (g_timer,  'Do_One_Level/r_nxt');

      l_is_leaf := FALSE;
      Do_One_Level (Add_Node (r_nxt.id, p_tree_index, r_nxt.item_weight + p_tot_weight), r_nxt.id, p_tot_weight + r_nxt.item_weight, p_tot_profit + r_nxt.item_profit);
      Timer_Set.Increment_Time (g_timer,  'Do_One_Level/Do_One_Level');

    END LOOP;

    IF l_is_leaf THEN

      IF p_tot_profit > l_best_profit THEN

        g_solution_list := SYS.ODCINumberList (p_tree_index);
        l_best_profit := p_tot_profit;

      ELSIF p_tot_profit = l_best_profit THEN

        g_solution_list.Extend;
        g_solution_list (g_solution_list.COUNT) := p_tree_index;

      END IF;

    END IF;
    Timer_Set.Increment_Time (g_timer,  'Do_One_Level/leaves');

  END Do_One_Level;

BEGIN

  FOR r_itm IN (SELECT id, item_weight, item_profit FROM items) LOOP

    Timer_Set.Increment_Time (g_timer,  'Root fetches');
    Do_One_Level (Add_Node (r_itm.id, 0, r_itm.item_weight), r_itm.id, r_itm.item_weight, r_itm.item_profit);

  END LOOP;

  FOR i IN 1..g_solution_list.COUNT LOOP

    j := g_solution_list(i);
    l_sol := NULL;
    l_weight := g_item_tree (j).weight_to_node;
    WHILE j != 0 LOOP

      l_sol := l_sol || g_item_tree (j).item_id || ', ';
      j :=  g_item_tree (j).item_index_parent;

    END LOOP;
    l_sol_cnt := l_sol_cnt + 1;
    PIPE ROW ('Solution ' || l_sol_cnt || ' (profit ' || l_best_profit || ', weight ' || l_weight || ') : ' || RTrim (l_sol, ', '));

  END LOOP;

  Timer_Set.Increment_Time(g_timer,  'Write output');
  Utils.W(Timer_Set.Format_Results(g_timer));

EXCEPTION
  WHEN OTHERS THEN
    Utils.W(Timer_Set.Format_Results(g_timer));
    RAISE;

END Best_Fits;

END Packing_PLF;
/
SHO ERR