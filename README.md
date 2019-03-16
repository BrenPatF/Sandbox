# Log_Set
Oracle logging framework.

The framework consists of 3 tables, 6 object types and 3 PL/SQL packages that support the writing of messages to log tables, along with various optional data items that may be specified as parameters or read at runtime via system calls.

The framework is designed to be as simple as possible to use in default mode, while allowing for a high degree of configuration. A client program first constructs a log pointing to a configuration key, then writes lines to the log conditionally depending on the line minimum print level being at least equal to the configuration print level. By creating new versions of the keyed configuration the amount and type of information printed can be varied without code changes to support production debugging and analysis.

Multiple logs can be processed simultaneously within and across sessions without interference.

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

## API
There are several versions of the log constructor function, and of the log writer methods, and calls are simplified by the use of two record types to group parameters, for which constructor functions are included. The parameters of these types have default records and so can be omitted, as in the example calls above, in which case the field values are as defaulted in the type definitions. These field level defaults are also taken when any of the record fields are not set explicitly. Field defaults are mentioned below where not null.

### l_con_rec Log_Set.con_rec := Log_Set.Con_Construct_Rec(`parameters`)
Returns a record to be passed to a Construct function, with parameters as follows (all optional):

* `config_key`: references configuration in log_configs table, of which there should be one active version; defaults to 'DEF_CONFIG'
* `description`: log description
* `print_lev_min`: minimum print level: Log not written if the print_lev in log_configs is lower; defaults to 0
* `do_close`: boolean, True if the log is to be closed immediately; defaults to False

### l_line_rec Log_Set.line_rec := Log_Set.Con_Line_Rec(`optional parameters`)
Returns a record to be passed to a method that writes lines, with parameters as follows (all optional):

* `p_line_type`: log line type, eg 'ERROR' etc., not validated
* `p_plsql_unit`: PL/SQL package name, as given by $$PLSQL_UNIT
* `p_plsql_line`: PL/SQL line number, as given by $$PLSQL_LINE
* `p_group_text`: free text that can be used to group lines
* `p_action`: action that can be used as the action in DBMS_Application_Info.Set_Action, and logged with a line
* `p_print_lev_min`: minimum print level: Log line not printed if the print_lev in log_configs is lower; also affects indp_ividual fields that have their own level, eg print_lev_stack; defaults to 0
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
Constructs a new log with integer handle `l_log_set`, passing line of text to be written to the new log.

* `p_line_text`: line of text to write

`optional parameters`
* `p_construct_rec`: construct parameters record of type Log_Set.line_rec, as defined above, default CONSTRUCT_DEF

### l_log_set   PLS_INTEGER := Log_Set.Construct(p_line_lis, `optional parameters`)
Constructs a new log with integer handle `l_log_set`, passing a list of lines of text to be written to the new log.

* `p_line_lis`: list of lines of text to write, of type L1_chr_arr

`optional parameters`
* `p_construct_rec`: construct parameters record of type Log_Set.con_rec, as defined above, default CONSTRUCT_DEF
* `p_line_rec`: line parameters record of type Log_Set.line_rec, as defined above, default LINE_DEF

### Log_Set.Put_Line(p_log_id, p_line_text, `optional parameters`)
Writes a line of text to the new log.

* `p_log_id`: id of log to write to
* `p_line_text`: line of text to write

`optional parameters`
* `p_line_rec`: line parameters record of type Log_Set.line_rec, as defined above, default LINE_DEF

### Log_Set.Put_List(p_log_id, p_line_lis, `optional parameters`)
Writes a list of lines of text to the new log.

* `p_log_id`: id of log to write to
* `p_line_lis`: list of lines of text to write, of type L1_chr_arr

`optional parameters`
* `p_line_rec`: line parameters record of type Log_Set.line_rec, as defined above, default LINE_DEF

### Log_Set.Close_Log(p_log_id)
Closes a log.

* `p_log_id`: id of log to close

### Log_Set.Raise_Error(`optional parameters`)
Raises an error via Oracle procedure RAISE_APPLICATION_ERROR, first writing the message to a log, if the log id is passed, and using p_line_rec.err_msg as the message.

`optional parameters`
* `p_log_id`: id of log to write to
* `p_line_rec`: line parameters record of type Log_Set.line_rec, as defined above, default LINE_DEF

### Log_Set.Write_Other_Error(p_log_id, `optional parameters`)
Raises an error via Oracle procedure RAISE_APPLICATION_ERROR, first writing the message to a log, if the log id is passed, and using p_line_rec.err_msg as the message.

* `p_log_id`: id of log to write to

`optional parameters`
* `p_line_text`: line of text to write, default null
* `p_line_rec`: line parameters record of type Log_Set.line_rec, as defined above, default LINE_DEF
* `p_do_close`: boolean, True if the log is to be closed after writing error details; defaults to True

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

The package is tested using the Math Function Unit Testing design pattern (`See also` below). In this approach, a 'pure' wrapper function is constructed that takes input parameters and returns a value, and is tested within a loop over scenario records read from a JSON file.

The wrapper function represents a generalised transactional use of the package in which multiple logs may be constructed, and written to independently. 

This kind of package would usually be thought hard to unit-test, with . However, this is a good example of the power of the design pattern that I recently introduced. 

## Operating System/Oracle Versions
### Windows
Windows 10
### Oracle
- Tested on Oracle Database 12c 12.2.0.1.0 
- Base code (and example) should work on earlier versions at least as far back as v11

## See also
- [trapit - nodejs unit test processing package on GitHub](https://github.com/BrenPatF/trapit_nodejs_tester)
   
## License
MIT