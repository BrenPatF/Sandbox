@initspool install_sys
/***************************************************************************************************
GitHub Project: sql_demos - Brendan's repo for interesting SQL
                https://github.com/BrenPatF/sql_demos

Description: SYS installation script for the sql_demos GitHub project

             Installation script for SYS schema to create the bren schema;
             - create directories, pointing to OS directories with read/write access on database 
                server, change the names where necessary: C:\input
             - grant privileges on directories and UTL_File, and select on v_ system tables to bren
                and new role demo_user

             To be run from SYS schema before Install_bren.sql, then problem-specific schemas:
                install_fan_foot.sql      - from fan_foot schema
                install_tsp.sql           - from tsp schema
                install_bal_num_part.sql  - from bal_num_part schema
                install_shortest_path.sql - from bal_num_part schema

Further details: 

Modification History
Who                  When        Which What
-------------------- ----------- ----- -------------------------------------------------------------
Brendan Furey        11-Nov-2017 1.0   Created with bren and fan_foot
Brendan Furey        18-Nov-2017 1.1   tsp, bal_num_part added
Brendan Furey        19-Nov-2017 1.2   shortest_path added

***************************************************************************************************/

PROMPT DIRECTORY input_dir - C:\input *** Change this if necessary, read access required ***
CREATE OR REPLACE DIRECTORY input_dir AS 'C:\input'
/
@c_schema bren
@c_schema fan_foot
@c_schema tsp
@c_schema bal_num_part
@c_schema shortest_path
@c_schema knapsack

PROMPT Grants to bren
GRANT EXECUTE ON UTL_File TO bren
/
GRANT SELECT ON v_$sql TO bren
/
GRANT SELECT ON v_$sql_plan_statistics_all TO bren
/
GRANT EXECUTE ON dbms_xplan_type_table TO bren
/
GRANT SELECT ON v_$sql_plan TO bren -- for xplan outlines
/
PROMPT Role demo_user
DROP ROLE demo_user
/
CREATE ROLE demo_user
/
GRANT ALL ON DIRECTORY input_dir TO demo_user
/
GRANT SELECT ON v_$database TO demo_user
/
GRANT SELECT ON v_$version TO demo_user
/
PROMPT Grant role demo_user to demo schemas
GRANT demo_user TO fan_foot, tsp, bal_num_part, shortest_path, knapsack
/
@endspool
