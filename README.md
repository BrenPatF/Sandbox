# Utils
This module comprises a set of generic user-defined Oracle types and a PL/SQL package of functions
and procedures of general utility. It includes functions and procedures for:
- 'pretty-printing'
- returning records from cursors or views/tables as lists of delimited strings
- joining lists of values into delimited strings, and the converse splitting operation

This module is a pre-requisite for other Oracle GitHub modules:
- [Log_Set](https://github.com/BrenPatF/log_set_oracle)
- [Trapit](https://github.com/BrenPatF/trapit_oracle_tester)
- [Timer_Set](https://github.com/BrenPatF/timer_set_oracle)

## Usage (extract from main_col_group.sql)
```sql
DECLARE
  l_res_arr              chr_int_arr;
BEGIN

  Col_Group.AIP_Load_File(p_file => 'fantasy_premier_league_player_stats.csv', p_delim => ',',
   p_colnum => 7);
  l_res_arr := Col_Group.AIP_List_Asis;
  Utils.W(p_line_lis => Utils.Heading(p_head => 'As Is'));

  Utils.W(p_line_lis => Utils.Col_Headers(p_value_lis => chr_int_arr(chr_int_rec('Team', 30), 
                                                                     chr_int_rec('Apps', -5)
  )));

  FOR i IN 1..l_res_arr.COUNT LOOP
    Utils.W(p_line => Utils.List_To_Line(p_value_lis => chr_int_arr(chr_int_rec(l_res_arr(i).chr_value, 30), 
                                                                    chr_int_rec(l_res_arr(i).int_value, -5)
    )));
  END LOOP;

END;
```
The main_col_group.sql script gives examples of usage for all the functions and procedures in the Utils package. In the extract above, an example package, Col_Group, is called to read and process a CSV file, with calls to Utils procedures and functions to 'pretty-print' a listing at the end:
```
As Is
=====
Team                             Apps
------------------------------  -----
team_name_2                         1
Blackburn                          33
...
```
To run the example script in a slqplus session from app subfolder (after installation):

SQL> @main_col_group

## API
### l_heading_lis L1_chr_arr := Utils.Heading(`parameters`)
Returns a 2-element string array consisting of the string passed in and a string of underlining '=' of the same length, with parameters as follows:

* `p_head`: string to be used as a heading

### l_headers_lis L1_chr_arr := Utils.Col_Headers(`parameters`)
Returns a 2-element string array consisting of a string containing the column headers passed in, justified as specified, and a string of sets of underlining '-' of the same lengths as the justified column headers, with parameters as follows:

* `p_value_lis`: chr_int_arr type, array of objects of type chr_int_rec:
  * `chr_value`: column header text
  * `int_value`: field size for the column header, right-justify if < 0, else left-justify

### l_line VARCHAR2(4000) := Utils.List_To_Line(`parameters`)
Returns a string containing the values passed in as a list of tuples, justified as specified in the second element of the tuple, with parameters as follows:
* `p_value_lis`: chr_int_arr type, array of objects of type chr_int_rec:
  * `chr_value`: value text
  * `int_value`: field size for the value, right-justify if < 0, else left-justify

### l_line VARCHAR2(4000) := Utils.Join_Values(`parameters`, `optional parameters`)
Returns a string containing the values passed in as a list of strings, delimited by the optional p_delim parameter that defaults to '|', with parameters as follows:
* `p_value_lis`: list of strings

`optional parameters`
* `p_delim`: delimiter string, defaults to '|'

### l_line VARCHAR2(4000) := Utils.Join_Values(`parameters`, `optional parameters`)
Returns a string containing the values passed in as distinct parameters, delimited by the optional p_delim parameter that defaults to '|', with parameters as follows:
* `p_value1`: mandatory first value

`optional parameters`
* `p_value2-p_value17`: 16 optional values, defaulting to the constant PRMS_END. The first defaulted value encountered acts as a list terminator
* `p_delim`: delimiter string, defaults to '|'

### l_value_lis L1_chr_arr := Utils.Split_Values(`parameters`, `optional parameters`)
Returns a list of string values obtained by splitting the input string on a given delimiter, with parameters as follows:

* `p_string`: string to split

`optional parameters`
* `p_delim`: delimiter string, defaults to '|'

### l_row_lis L1_chr_arr := Utils.View_To_List(`parameters`, `optional parameters`)
Returns a list of rows returned from the specified view/table, with specified column list and where clause, delimiting values with specified delimiter, with parameters as follows:

* `p_view_name`: name of table or view
* `p_sel_value_lis`: L1_chr_arr list of columns to select

`optional parameters`
* `p_where`: where clause, omitting WHERE key-word
* `p_delim`: delimiter string, defaults to '|'

### l_row_lis L1_chr_arr := Utils.Cursor_To_List(`parameters`, `optional parameters`)
Returns a list of rows returned from the ref cursor passed, delimiting values with specified delimiter, with filter clause applied via RegExp_Like to the delimited rows, with parameters as follows:

* `p_view_name`: name of table or view
* `p_sel_value_lis`: L1_chr_arr list of columns to select

`optional parameters`
* `p_where`: where clause, omitting WHERE key-word
* `p_delim`: delimiter string, defaults to '|'

### l_seconds NUMBER := Utils.IntervalDS_To_Seconds(`parameters`)
Returns the number of seconds in a day-to-second interval, with parameters as follows:

* `p_interval`: INTERVAL DAY TO SECOND

### Utils.Sleep(`parameters`, `optional parameters`)
Sleeps for a given number of seconds elapsed time, including a given proportion of CPU time, with both numbers approximate, with parameters as follows:

* `p_ela_seconds`: elapsed time to sleep

`optional parameters`
* `p_fraction_CPU`: fraction of elapsed time to use CPU, default 0.5

### Utils.Raise_Error(`parameters`)
Raises an error using Raise_Application_Error with fixed error number of 20000, with parameters as follows:

* `p_message`: error message

### Utils.W(`parameters`)
Writes a line of text using DBMS_Output.Put_line, with parameters as follows:

* `p_line`: line of text to write

### Utils.W(`parameters`)
Writes a list of lines of text using DBMS_Output.Put_line, with parameters as follows:

* `p_line_lis`: L1_chr_arr list of lines of text to write

## Installation
You can install just the base module in an existing schema, or alternatively, install base module plus an example of usage, and unit testing code, in two new schemas, `lib` and `app`.

### Install 1: Create lib and app schemas and Oracle directory (optional)
#### [Schema: sys; Folder: (module root)]
- install_sys.sql creates an Oracle directory, `input_dir`, pointing to 'c:\input'. Update this if necessary to a folder on the database server with read/write access for the Oracle OS user
- Run script from slqplus:
```
SQL> @install_sys
```

If you do not create new users, subsequent installs will be from whichever schemas are used instead of lib and app.

### Install 2: Create Utils components
#### [Schema: lib; Folder: lib]
- Run script from slqplus:
```
SQL> @install_utils
```

This creates the required components for the base install along with public synonyms and grants for them. This install is all that is required to use the package and object types.

### Install 3: Create components for example code
#### [Schema: app; Folder: app]
- Copy the following files from the root folder to the `input_dir` folder:
  - fantasy_premier_league_player_stats.csv
- Run script from slqplus:
```
SQL> @install_app
```

You can review the results from the example code in the `app` subfolder without doing this install.

The remaining, optional, installs are for the unit testing code, and require a minimum Oracle database version of 12.2.
### Install 4: Install Trapit module
#### [Schema: lib; Folder: (Trapit) lib]
- Download and install the Trapit module:
[Trapit on GitHub](https://github.com/BrenPatF/trapit_oracle_tester)

### Install 5: Install unit test code
#### [Schema: lib; Folder: lib]
- Copy the following file from the root folder to the `input_dir` folder:
  - tt_utils.json
- Run script from slqplus:
```
SQL> @install_utils_tt
```

Processing the unit test output file requires a separate nodejs install from npm. You can review the  unit test formatted results in the `test_output` subfolder, without needing to do this install [utils.html is the root page for the HTML version and utils.txt has the results in text format].

### Install 6: Install npm package
#### [Folder: (npm root)]
Open a DOS or Powershell window in the folder where you want to install npm packages, and, with [nodejs](https://nodejs.org/en/download/) installed, run

```
$ npm install trapit
```

This should install the trapit nodejs package in a subfolder .\node_modules\trapit

## Unit testing
The unit test program (if installed) may be run from the Oracle lib subfolder:

```
SQL> @r_tests
```

The program is data-driven from the input file tt_utils.json and produces an output file, tt_utils.tt_main_out.json, that contains arrays of expected and actual records by group and scenario.

The output file can be processed by a Javascript program that has to be installed separately from the `npm` Javascript repository, as noted in `Install 6` above. The Javascript program produces listings of the results in html and/or text format, and a sample set of listings is included in the subfolder test_output. To run the processor (in Windows), open a DOS or Powershell window in the trapit package folder after placing the output JSON file, tt_utils.tt_main_out.json, in the subfolder ./examples/externals and run:

```
$ node ./examples/externals/test-externals
```

The three testing steps can easily be automated in Powershell (or Unix bash).

The package is tested using the Math Function Unit Testing design pattern (`See also` below). In this approach, a 'pure' wrapper function is constructed that takes input parameters and returns a value, and is tested within a loop over scenario records read from a JSON file.

In this case, where we have a set of small independent methods, most of which are pure functions, the wrapper function is designed to test all of them in a single generalised transaction. Four high level scenarios were identified (`Small`, `Large`, `Many`, `Bad SQL`).

## Operating System/Oracle Versions
### Windows
Windows 10
### Oracle
- Tested on Oracle Database Version 18.3.0.0.0
- Base code (and example) should work on earlier versions at least as far back as v11

## See also
- [trapit - nodejs unit test processing package on GitHub](https://github.com/BrenPatF/trapit_nodejs_tester)
- [nodejs download page](https://nodejs.org/en/download/)

## License
MIT