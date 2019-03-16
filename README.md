# Log_Set
Oracle logging framework.

The framework consists of 3 tables, 6 object types and 3 PL/SQL packages that support the writing of messages to log tables, along with various optional data items that may be specified as parameters or read at runtime via system calls.

The framework is designed to be as simple as possible to use in default mode, while allowing for a high degree of configuration. A client program first constructs a log pointing to a configuration key, then puts lines to the log conditionally depending on the line minimum put level being at least equal to the configuration put level. By creating new versions of the keyed configuration the amount and type of information put can be varied without code changes to support production debugging and analysis.

Multiple logs can be processed simultaneously within and across sessions without interference.

In order to maximise performance, puts are buffered, and only the log header uses an Oracle sequence for its unique identifier, with lines being numbered sequentially in PL/SQL.

## Usage (extract from main_col_group.sql)
```sql
DECLARE
  l_log_id               PLS_INTEGER := Log_Set.Construct;
BEGIN

  Log_Set.Put_List(p_log_id => l_log_id, p_line_lis => Utils.Heading(p_name));
.
  Log_Set.Put_Line(p_log_id => l_log_id, p_line_text  => '');
.
  RAISE NO_DATA_FOUND; -- Example of unexpected error handling in others
  Log_Set.Close_Log(p_log_id => l_log_id); -- will be closed by Write_Other_Error

EXCEPTION
  WHEN OTHERS THEN
    Log_Set.Write_Other_Error(p_log_id => l_log_id);
    RAISE;
END;
/
SELECT line_num lno, Nvl(err_msg, line_text) text
  FROM log_lines
 WHERE log_id = (SELECT MAX(h.id) FROM log_headers h)
 ORDER BY line_num
/

```
This will create a log of the results from an example program, with listing at the end:
```
   1 As Is
   2 =====
   3 Team                             Apps
   4 ------------------------------  -----
   5 team_name_2                         1
   6 Blackburn                          33
...
  89 QPR                              1517
  90
  91 ORA-01403: no data found
```
To run the example in a slqplus session from app subfolder (after installation):

SQL> @main_col_group

## API - Log_Set
There are several versions of the log constructor function, and of the log writer methods, and calls are simplified by the use of two record types to group parameters, for which constructor functions are included. The parameters of these types have default records and so can be omitted, as in the example calls above, in which case the field values are as defaulted in the type definitions. These field level defaults are also taken when any of the record fields are not set explicitly. Field defaults are mentioned below where not null.

All commits are through autonomous transactions.

### l_con_rec Log_Set.con_rec := Log_Set.Con_Construct_Rec(`optional parameters`)
Returns a record to be passed to a Construct function, with parameters as follows (all optional):

* `p_config_key`: references configuration in log_configs table, of which there should be one active version; defaults to 'DEF_CONFIG'
* `p_description`: log description
* `p_put_lev_min`: minimum put level: Log not put if the put_lev in log_configs is lower; defaults to 0
* `p_do_close`: boolean, True if the log is to be closed immediately; defaults to False

### l_line_rec Log_Set.line_rec := Log_Set.Con_Line_Rec(`optional parameters`)
Returns a record to be passed to a method that puts lines, with parameters as follows (all optional):

* `p_line_type`: log line type, eg 'ERROR' etc., not validated
* `p_plsql_unit`: PL/SQL package name, as given by $$PLSQL_UNIT
* `p_plsql_line`: PL/SQL line number, as given by $$PLSQL_LINE
* `p_group_text`: free text that can be used to group lines
* `p_action`: action that can be used as the action in DBMS_Application_Info.Set_Action, and logged with a line
* `p_put_lev_min`: minimum put level: Log line not put if the put_lev in log_configs is lower; also affects indp_ividual fields that have their own level, eg put_lev_stack; defaults to 0
* `p_err_num`: error number when passed explicitly, also set to SQLCODE by Write_Other_Error
* `p_err_msg`: error message when passed explicitly, also set to SQLERRM by Write_Other_Error
* `p_call_stack`: call stack set by Write_Other_Error using DBMS_Utility.Format_Call_Stack
* `p_error_backtrace`: error backtrace set by Write_Other_Error using DBMS_Utility.Format_Error_Backtrace
* `p_do_close`: boolean, True if the log is to be closed after writing line or list of lines; defaults to False

### l_log_set   PLS_INTEGER := Log_Set.Construct(`optional parameters`)
Constructs a new log with integer handle `l_log_set`.

`optional parameters`
* `p_construct_rec`: construct parameters record of type Log_Set.line_rec, as defined above, default CONSTRUCT_DEF

### l_log_set   PLS_INTEGER := Log_Set.Construct(p_line_text, `optional parameters`)
Constructs a new log with integer handle `l_log_set`, passing line of text to be put to the new log.

* `p_line_text`: line of text to write

`optional parameters`
* `p_construct_rec`: construct parameters record of type Log_Set.line_rec, as defined above, default CONSTRUCT_DEF

### l_log_set   PLS_INTEGER := Log_Set.Construct(p_line_lis, `optional parameters`)
Constructs a new log with integer handle `l_log_set`, passing a list of lines of text to be put to the new log.

* `p_line_lis`: list of lines of text to write, of type L1_chr_arr

`optional parameters`
* `p_construct_rec`: construct parameters record of type Log_Set.con_rec, as defined above, default CONSTRUCT_DEF
* `p_line_rec`: line parameters record of type Log_Set.line_rec, as defined above, default LINE_DEF

### Log_Set.Put_Line(p_line_text, `optional parameters`)
Writes a line of text to the new log.

* `p_line_text`: line of text to write

`optional parameters`
* `p_log_id`: id of log to write to; if omitted, a single log with config value of singleton_yn = 'Y' must have been constructed, and that log will be used
* `p_line_rec`: line parameters record of type Log_Set.line_rec, as defined above, default LINE_DEF

### Log_Set.Put_List(p_line_lis, `optional parameters`)
Writes a list of lines of text to the new log.

* `p_line_lis`: list of lines of text to write, of type L1_chr_arr

`optional parameters`
* `p_log_id`: id of log to write to; if omitted, a single log with config value of singleton_yn = 'Y' must have been constructed, and that log will be used
* `p_line_rec`: line parameters record of type Log_Set.line_rec, as defined above, default LINE_DEF

### Log_Set.Close_Log(`optional parameters`)
Closes a log, after saving any unsaved buffer lines.

`optional parameters`
* `p_log_id`: id of log to close; if omitted, a single log with config value of singleton_yn = 'Y' must have been constructed, and that log will be used

### Log_Set.Raise_Error(p_err_msg, `optional parameters`)
Raises an error via Oracle procedure RAISE_APPLICATION_ERROR, first writing the message to a log, if the log id is passed.

* `p_err_msg`: error message

`optional parameters`
* `p_log_id`: id of log to write to
* `p_line_rec`: line parameters record of type Log_Set.line_rec, as defined above, default LINE_DEF
* `p_do_close`: boolean, True if the log is to be closed after writing error details; defaults to True

### Log_Set.Write_Other_Error(p_log_id, `optional parameters`)
Raises an error via Oracle procedure RAISE_APPLICATION_ERROR, first writing the message to a log, if the log id is passed, and using p_line_rec.err_msg as the message.

* `p_log_id`: id of log to write to

`optional parameters`
* `p_line_text`: line of text to write, default null
* `p_line_rec`: line parameters record of type Log_Set.line_rec, as defined above, default LINE_DEF
* `p_do_close`: boolean, True if the log is to be closed after writing error details; defaults to True

### Log_Set.Delete_Log(p_log_id, p_session_id)
Deletes all logs matching either a single log id or a session id which may have multiple logs. Exactly one parameter must be passed. This uses an autonomous transaction.

* `p_log_id`: id of log to delete
* `p_session_id`: session id of logs to delete

## API - Log_Config
This package allows for insertion and deletion of the configuration records, with no commits.

### Log_Config.Ins_Config(`optional parameters`)
Inserts a new record in the log_configs table. If the config_key already exists, a new active version will be inserted with the old version de-activated. 

One of the columns in the table is of a custom array type, ctx_inp_arr. This is an array of objects of type ctx_inp_obj, which contain information on possible writing of system contexts in the USERENV namespace [Oracle SYS_CONTEXT](https://docs.oracle.com/en/database/oracle/oracle-database/12.2/sqlrf/SYS_CONTEXT.html#GUID-B9934A5D-D97B-4E51-B01B-80C76A5BD086). The object type has fields as follows:
        
 * `ctx_nm`: context name
 * `put_lev`: put level for the context; if header/line is put, the minimum header/line put level is compared to this for writing the context value
 * `head_line_fg`: write for 'H' - header only, 'L' - line only, 'B' - both header and line

An entry in the array should be added for each context desired.

All parameters are optional, with null defaults except where mentioned:

* `p_config_key`: references configuration in log_configs table, of which there should be one active version; default 'DEF_CONFIG'
* `p_config_type`: configuration type; if new version, takes same as previous version if not passed
* `p_description`: log description; if new version, takes same as previous version if not passed
* `p_put_lev`: put level, default 10; minimum put levels at header and line level are compared to this
* `p_put_lev_stack`: put level for call stack; if line is put, the minimum line put level is compared to this for writing the call stack field
* `p_put_lev_cpu`:  put level for CPU time; if line is put, the minimum line put level is compared to this for writing the CPU time field
* `p_ctx_inp_lis`: list of contexts to write depending on the put levels specified
* `p_put_lev_module`:  put level for module; if line is put, the minimum line put level is compared to this for writing the module field
* `p_put_lev_action`:  put level for action; if line is put, the minimum line put level is compared to this for writing the action field
* `p_put_lev_client_info`:  put level for client info; if line is put, the minimum line put level is compared to this for writing the client info field
* `p_app_info_only_yn`: if 'Y' do not write to table, but set application info only
* `p_singleton_yn`: if 'Y' designates a `singleton` configuration, meaning only a single log with this setting can be active at a time, and the log id is stored internally, so can be omitted from the put and close methods
* `p_buff_len`: number of lines that are stored before saving to table; default 100
* `p_extend_len`: number of elements to extend the buffer by when needed; default 100

## Installation
You can install just the base application in an existing schema, or alternatively, install base application plus an example of usage, and unit testing code, in two new schemas, `lib` and `app`.
### Install (base application only)
To install the base application only, comprising 3 tables, 6 object types and 3 packages, run the following script in a sqlplus session in the desired schema from the lib subfolder:

SQL> @install_lib

This creates the required objects along with public synonyms and grants for them. It does not include the example or the unit test code, the latter of which requires a minimum Oracle database version of 12.2.

### Install (base application plus example and unit test code)
The extended installation requires a minimum Oracle database version of 12.2, and processing the unit test output file requires a separate nodejs install from npm. You can review the results from the example code in the `app` subfolder, and the unit test formatted results in the `test_output` subfolder, without needing to do the extended installation [log_set.html is the root page for the HTML version and log_set.txt has the results in text format].
- install_sys.sql creates an Oracle directory, `input_dir`, pointing to 'c:\input'. Update this if necessary to a folder on the database server with read/write access for the Oracle OS user
- Copy the following files from the root folder to the `input_dir` folder:
	- fantasy_premier_league_player_stats.csv
	- tt_log_set.json
- Run the install scripts from the specified folders in sqlplus sessions for the specified schemas

#### Root folder, sys schema
SQL> @install_sys

#### lib subfolder, lib schema
SQL> @install_lib

SQL> @install_lib_tt

#### app subfolder, app schema
SQL> @install_app

## Unit testing
The unit test program (if installed) may be run from the lib subfolder:

SQL> @r_tests

The program is data-driven from the input file tt_log_set.json and produces an output file tt_log_set.tt_main_out.json, that contains arrays of expected and actual records by group and scenario.

The output file can be processed by a Javascript program that has to be downloaded separately from the `npm` Javascript repository. The Javascript program produces listings of the results in html and/or text format, and a sample set of listings is included in the subfolder test_output. To install the Javascript program, `trapit`:

With [npm](https://npmjs.org/) installed, run

```
$ npm install trapit
```

The package is tested using the Math Function Unit Testing design pattern (`See also - trapit` below). In this approach, a 'pure' wrapper function is constructed that takes input parameters and returns a value, and is tested within a loop over scenario records read from a JSON file.

The wrapper function represents a generalised transactional use of the package in which multiple logs may be constructed, and put to independently. 

This is a good example of the power of the design pattern that I recently introduced, and is a second example, after `See also - timer_set` below, of unit testing where the 'unit' is taken to be a full generalised transaction, from start to finish of a logging (or timing) session.

## Operating System/Oracle Versions
### Windows
Windows 10
### Oracle
- Tested on Oracle Database 12c 12.2.0.1.0 
- Base code (and example) should work on earlier versions at least as far back as v11

## See also
- [trapit - nodejs unit test processing package on GitHub](https://github.com/BrenPatF/trapit_nodejs_tester)
- [timer_set - code timing package on GitHub](https://github.com/BrenPatF/timer_set_oracle)
   
## License
MIT