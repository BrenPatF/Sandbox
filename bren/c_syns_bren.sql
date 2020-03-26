DEFINE lib=&1
/***************************************************************************************************
Name: c_syns_bren.sql                  Author: Brendan Furey                       Date: 19-Mar-2020

Creates synonyms for common components in app-i (subproject) schema to bren schema.

Synonyms created:

    Synonym             Object Type
    ==================  ============================================================================
    log_headers         Table
    log_lines           Table
    Utils               Package
    Timer_Set           Package
    L1_num_arr          Type

***************************************************************************************************/
CREATE OR REPLACE SYNONYM log_headers FOR &lib..log_headers
/
CREATE OR REPLACE SYNONYM log_lines FOR &lib..log_lines
/
CREATE OR REPLACE SYNONYM Utils FOR &lib..Utils
/
CREATE OR REPLACE SYNONYM Timer_Set FOR &lib..Timer_Set
/
CREATE OR REPLACE SYNONYM L1_num_arr FOR &lib..L1_num_arr
/
