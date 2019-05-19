# trapit_oracle_tester
TRansactional API Testing (TRAPIT) framework for Oracle PL/SQL unit testing.

The framework is designed as a lightweight PL/SQL-based framework for API testing that can be considered as an alternative to utPLSQL. The framework is based on the idea that all API testing programs can follow a universal design pattern for testing APIs, using the concept of a ‘pure’ function as a wrapper to manage the ‘impurity’ inherent in database APIs. I explained the concepts involved in a presentation at the Oracle User Group Ireland Conference in March 2018:

- [The Database API Viewed As A Mathematical Function: Insights into Testing](https://www.slideshare.net/brendanfurey7/database-api-viewed-as-a-mathematical-function-insights-into-testing)

## Usage ()

?

## API
### l_scenarios Trapit.scenarios_rec := Trapit.Get_Inputs(`parameters`)
Returns a record containing a delimiter and 4-level list of scenario metadata for testing the given package procedure, with parameters as follows:

* `p_package_nm`: package name
* `p_procedure_nm`: procedure name

`return value`
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

### Install 2: Trapit
#### [Schema: lib; Folder: lib]
- Run script from slqplus:
```
SQL> @install_trapit
```

This creates the required objects without public synonyms or grants. It requires a minimum Oracle database version of 12.2.

## Use in unit testing
The unit test program (if installed) may be run from the lib subfolder:

SQL> @r_tests

The program is data-driven from the input file x.json and produces an output file x.tt_main_out.json, that contains arrays of expected and actual records by group and scenario.

The output file can be processed by a Javascript program that has to be downloaded separately from the `npm` Javascript repository. The Javascript program produces listings of the results in html and/or text format, and a sample set of listings is included in the subfolder test_output. To install the Javascript program, `trapit`:

With [npm](https://npmjs.org/) installed, run

```
$ npm install trapit
```

The package is tested using the Math Function Unit Testing design pattern (`See also` below). In this approach, a 'pure' wrapper function is constructed that takes input parameters and returns a value, and is tested within a loop over scenario records read from a JSON file.

## Operating System/Oracle Versions
### Windows
Tested on Windows 10, should be OS-independent
### Oracle
- Tested on Oracle Database Version 18.3.0.0.0
- Minimum version 12.2

## See also
- [trapit - nodejs unit test processing package on GitHub](https://github.com/BrenPatF/trapit_nodejs_tester)
   
## License
MIT