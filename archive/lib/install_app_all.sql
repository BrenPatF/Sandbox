@..\install_prereq\initspool install_app_all
/***************************************************************************************************
GitHub Project: sql_demos - Brendan's repo for interesting SQL
                https://github.com/BrenPatF/sql_demos

Description: SYS installation script for the sql_demos GitHub project

            Installation script for SYS schema to create the subproject schemas using c_user.sql
            - grant privileges on directories and UTL_File, and select on v_ system tables to 
            new subproject schemas

***************************************************************************************************/

rem @install_app_one lib bal_num_part
rem @install_app_one lib fan_foot
@install_app_one lib knapsack
rem @install_app_one lib shortest_path
rem @install_app_one lib tsp

@..\install_prereq\endspool
