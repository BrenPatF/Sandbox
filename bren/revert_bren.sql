@initspool revert_bren
/***************************************************************************************************
GitHub Project: sql_demos - Brendan's repo for interesting SQL
                https://github.com/BrenPatF/sql_demos

Author:         Brendan Furey, 11 November 2017
Description:    Install reversion script for library schema, bren, for the sql_demos GitHub project for
                the common components

***************************************************************************************************/

REM Run this script from schema bren to drop the common objects

DROP PACKAGE timer_set
/
DROP PACKAGE utils
/
PROMPT Drop type L1_chr_arr
DROP TYPE L1_chr_arr
/
PROMPT Drop type L1_num_arr
DROP TYPE L1_num_arr
/
PROMPT Drop sequence log_lines_s
DROP SEQUENCE log_lines_s
/
PROMPT Drop tables log_lines and log_headers
DROP TABLE log_lines
/
DROP TABLE log_headers
/
@endspool
