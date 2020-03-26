@install_prereq\initspool install_sys
/***************************************************************************************************
GitHub Project: sql_demos - Brendan's repo for interesting SQL
                https://github.com/BrenPatF/sql_demos

Description: SYS installation script for the sql_demos GitHub project

            Installation script for SYS schema to create the subproject schemas using c_user.sql
            - grant privileges on directories and UTL_File, and select on v_ system tables to 
            new subproject schemas

***************************************************************************************************/

PROMPT Drop the app user created by the install_prereq
DROP USER app CASCADE
/
@install_prereq\c_user bal_num_part
@install_prereq\c_user fan_foot
@install_prereq\c_user knapsack
@install_prereq\c_user shortest_path
@install_prereq\c_user tsp

GRANT CREATE SYNONYM TO bal_num_part, fan_foot, knapsack, shortest_path, tsp
/
GRANT SELECT ON v_$sql_plan_statistics_all TO bal_num_part, fan_foot, knapsack, shortest_path, tsp
/
@install_prereq\endspool
