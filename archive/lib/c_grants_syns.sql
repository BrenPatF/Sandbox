DEFINE LIB=&1
DEFINE APP=&2
/***************************************************************************************************
Name: c_syns_bren.sql                  Author: Brendan Furey                       Date: 19-Mar-2020

Creates synonyms for common components in app-i (subproject) schema to bren schema.

Synonyms created:

    Synonym             Object Type
    ==================  ============================================================================

***************************************************************************************************/
@c_grants_all &APP
@c_syns_all &LIB
