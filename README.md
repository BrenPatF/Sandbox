# trapit_oracle_tester
TRansactional API Testing (TRAPIT) framework for Oracle PL/SQL unit testing.

The framework is designed as a lightweight PL/SQL-based framework for API testing that can be considered as an alternative to utPLSQL. The framework is based on the idea that all API testing programs can follow a universal design pattern for testing APIs, using the concept of a ‘pure’ function as a wrapper to manage the ‘impurity’ inherent in database APIs. In this approach, a 'pure' wrapper function is constructed that takes input parameters and returns a value, and is tested within a loop over scenario records read from a JSON file. I explained the concepts involved in a presentation at the Oracle User Group Ireland Conference in March 2018:

- [The Database API Viewed As A Mathematical Function: Insights into Testing](https://www.slideshare.net/brendanfurey7/database-api-viewed-as-a-mathematical-function-insights-into-testing)

## Usage

In order to use the framework for unit testing, the following preliminary steps are required: 
* A JSON file is created containing the input test data including expected return values in the required format
* A unit test PL/SQL program is created as a public procedure in a package (see example below). The program calls:
  * Trapit.Get_Inputs to get the JSON data and translate into PL/SQL arrays
  * Trapit.Set_Outputs to convert actual results in PL/SQL arrays into JSON, and write the output JSON file
* A record is inserted into the tt_units table using the Trapit.Add_Ttu procedure, passing names of package, procedure, JSON file (which should be placed in an Oracle directory, INPUT_DIR) and an active Y/N flag

Once the preliminary steps are executed, the following steps run the unit test program: 
* The procedure Trapit.Run_Tests is called to run active test programs, writing JSON output files both to the tt_units table and to the Oracle directory, INPUT_DIR
* Open a DOS or Powershell window in the trapit npm package folder (`see Install 3: Install npm trapit package below`) after placing the output JSON file in the subfolder ./examples/externals and run:
```
$ node ./examples/externals/test-externals
```
The Javascript program produces listings of the results in html and/or text format. The unit test steps can easily be automated in Powershell (or in a Unix script).

### Example test program main procedure from Utils module
```
PROCEDURE Test_API IS

  PROC_NM                        CONSTANT VARCHAR2(30) := 'Test_API';

  l_act_3lis                     L3_chr_arr := L3_chr_arr();
  l_sces_4lis                    L4_chr_arr;
  l_scenarios                    Trapit.scenarios_rec;
  l_delim                        VARCHAR2(10);
BEGIN

  l_scenarios := Trapit.Get_Inputs(p_package_nm  => $$PLSQL_UNIT,
                                   p_procedure_nm => PROC_NM);
  l_sces_4lis := l_scenarios.scenarios_4lis;
  l_delim := l_scenarios.delim;
  l_act_3lis.EXTEND(l_sces_4lis.COUNT);
  FOR i IN 1..l_sces_4lis.COUNT LOOP
    l_act_3lis(i) := purely_Wrap_API(p_delim    => l_delim,
                                     p_inp_3lis => l_sces_4lis(i));

  END LOOP;

  Trapit.Set_Outputs(p_package_nm   => $$PLSQL_UNIT,
                     p_procedure_nm => PROC_NM,
                     p_act_3lis     => l_act_3lis);

END Test_API;
```

## API
### l_scenarios Trapit.scenarios_rec := Trapit.Get_Inputs(`parameters`)
Returns a record containing a delimiter and 4-level list of scenario metadata for testing the given package procedure, with parameters as follows:

* `p_package_nm`: package name
* `p_procedure_nm`: procedure name

`Return Value`
* `scenarios_rec`: record type with two fields:
  * `delim`: record delimiter
  * `scenarios_4lis`: 4-level list of scenario input values - (scenario, group, record, field)

### Trapit.Set_Outputs(`parameters`)
Adds the actual results data into the JSON input object for testing the given package procedure and writes it to file, and to a column in tt_units table, with parameters as follows:

* `p_package_nm`: package name
* `p_procedure_nm`: procedure name
* `p_act_3lis`: 3-level list of actual values as delimited records, by scenario and group

### Trapit.Run_Tests
Runs the unit test program for each package procedure set to active in tt_units table.

### Trapit.Add_Ttu(`parameters`)
Adds a record to tt_units table, with parameters as follows:

* `p_package_nm`: package name
* `p_procedure_nm`: procedure name
* `p_active_yn`: active Y/N flag
* `p_input_file`: name of input file, which has to exist in Oracle directory `input_dir`

## Installation
The install depends on the pre-requisite module Utils, and `lib` schema refers to the schema in which Utils is installed.

### Install 1: Install Utils module (if not present)
#### [Schema: lib; Folder: (Utils) lib]
- Download and install the Utils module:
[Utils on GitHub](https://github.com/BrenPatF/oracle_plsql_utils)

### Install 2: Install Oracle Trapit module
#### [Schema: lib; Folder: lib]
- Run script from slqplus:
```
SQL> @install_trapit
```
This creates the required objects without public synonyms or grants. It requires a minimum Oracle database version of 12.2.

### Install 3: Install npm trapit package
#### [Folder: (npm root)]
Open a DOS or Powershell window in the folder where you want to install npm packages, and, with [nodejs](https://nodejs.org/en/download/) installed, run
```
$ npm install trapit
```
This should install the trapit nodejs package in a subfolder .\node_modules\trapit

## Operating System/Oracle Versions
### Windows
Tested on Windows 10, should be OS-independent
### Oracle
- Tested on Oracle Database Version 18.3.0.0.0
- Minimum version 12.2

## See also
- [trapit - nodejs unit test processing package on GitHub](https://github.com/BrenPatF/trapit_nodejs_tester)
- [Utils - Oracle PL/SQL module on GitHub](https://github.com/BrenPatF/oracle_plsql_utils)
   
## License
MIT