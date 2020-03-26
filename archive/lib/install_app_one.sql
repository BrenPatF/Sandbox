DEFINE LIB=&1
DEFINE APP=&2
/***************************************************************************************************
GitHub Project: sql_demos - Brendan's repo for interesting SQL
                https://github.com/BrenPatF/sql_demos

Description: SYS installation script for the sql_demos GitHub project

            Installation script for SYS schema to create the subproject schemas using c_user.sql
            - grant privileges on directories and UTL_File, and select on v_ system tables to 
            new subproject schemas

***************************************************************************************************/
PROMPT Executing install_app_one for parameters &LIB and &APP
@c_grants_all &APP
CONNECT &APP/&APP@orclpdb

@c_syns_all &LIB
@..\&APP\install_&APP

CONNECT &LIB\&LIB@orclpdb
