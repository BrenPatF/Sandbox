@initspool revert_sys
/***************************************************************************************************
GitHub Project: sql_demos - Brendan's repo for interesting SQL
                https://github.com/BrenPatF/sql_demos

Description: sys install reversion script for the sql_demos GitHub project

             Install reversion script for sys schema to 
             - drop the bren and others schemas
             - drop directory input_dir
             - drop role demo_user

***************************************************************************************************/

PROMPT Drop users
DROP USER fan_foot CASCADE
/
DROP USER tsp CASCADE
/
DROP USER bal_num_part CASCADE
/
DROP USER shortest_path CASCADE
/
DROP USER knapsack CASCADE
/
DROP USER bren CASCADE
/

PROMPT Drop role demo_user
DROP ROLE demo_user
/
PROMPT Drop directory input_dir
DROP DIRECTORY input_dir
/
@endspool
