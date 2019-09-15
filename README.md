# Oracle_PLSQL_API_Demos
Module demonstrating instrumentation and logging, code timing and unit testing of PL/SQL APIs.

PL/SQL procedures were written against Oracle's HR demo schema to represent the different kinds of API across two axes: Setter/Getter and Real Time/Batch.

Mode          | Setter Example (S)          | Getter Example (G)
--------------|-----------------------------|----------------------------------
Real Time (R) | Web service saving          | Web service getting by ref cursor
Batch (B)     | Batch loading of flat files | Views

The PL/SQL procedures and view were written originally to demonstrate unit testing, and are as follows:

- RS: Emp_WS.Save_Emps - Save a list of new employees to database, returning list of ids with Julian dates; logging errors to err$ table
- RG: Emp_WS.Get_Dept_Emps - For given department id, return department and employee details including salary ratios, excluding employees with job 'AD_ASST', and returning none if global salary total < 1600, via ref cursor
- BS: Emp_Batch.Load_Emps - Load new employees from file via external table
- BG: hr_test_view_v - View returning department and employee details including salary ratios, excluding employees with job 'AD_ASST', and returning none if global salary total < 1600

## Unit Testing
The PL/SQL APIs are tested using the Math Function Unit Testing design pattern, with test results in HTML and text format included. The design pattern is based on the idea that all API testing programs can follow a universal design pattern, using the concept of a ‘pure’ function as a wrapper to manage the ‘impurity’ inherent in database APIs. I explained the concepts involved in a presentation at the Oracle User Group Ireland Conference in March 2018:

<a href="https://www.slideshare.net/brendanfurey7/database-api-viewed-as-a-mathematical-function-insights-into-testing" target="_blank">The Database API Viewed As A Mathematical Function: Insights into Testing</a>

In this data-driven design pattern a driver program reads a set of scenarios from a JSON file, and loops over the scenarios calling the wrapper function with the scenario as input and obtaining the results as the return value. Utility functions from the Trapit module convert the input JSON into PL/SQL arrays, and, conversely, the output arrays into JSON text that is written to an output JSON file. This latter file contains all the input values and output values (expected and actual), as well as metadata describing the input and output groups. A separate nodejs module can be run to process the output files and create HTML files showing the results: Each unit test (say `pkg.prc`) has its own root page `pkg.prc.html` with links to a page for each scenario, located within a subfolder `pkg.prc`. Here, they have been copied into a subfolder test_output, as follows:

- tt_emp_batch.load_emps
- tt_emp_ws.get_dept_emps
- tt_emp_ws.save_emps
- tt_view_drivers.hr_test_view_v

Where the actual output record matches expected, just one is represented, while if the actual differs it is listed below the expected and with background colour red. The employee group in scenario 4 of tt_emp_ws.save_emps has two records deliberately not matching, the first by changing the expected salary and the second by adding a duplicate expected record.

Each of the `pkg.prc` subfolders also includes a JSON Structure Diagram, `pkg.prc.png`, showing the input/output structure of the pure unit test wrapper function.


The following article :

<a href="http://aprogrammerwrites.eu/?p=1723" target="_blank">TRAPIT - TRansactional API Testing in Oracle</a>

See test_output\log_set.html for the unit test results root page.

## Logging and Instrumentation

## Code Timing

## Installation
The install depends on the pre-requisite modules Utils, Log_Set, and Timer_Set, and `lib` schema refers to the schema in which Utils is installed.

### Install 1: Install Utils module
#### [Schema: lib; Folder: (Utils) lib]
- Download and install the Utils module:
[Utils on GitHub](https://github.com/BrenPatF/oracle_plsql_utils)

The Utils install includes a step to install the separate Trapit PL/SQL unit testing module, and this step is required for the unit test part of the current module.

### Install 2: Install Log_Set module
#### [Schema: lib; Folder: (Log_Set) lib]
- Download and install the Log_Set module:
[Log_Set on GitHub](https://github.com/BrenPatF/log_set_oracle)

### Install 3: Install Timer_Set module
#### [Schema: lib; Folder: (Timer_Set) lib]
- Download and install the Timer_Set module:
[Timer_Set on GitHub](https://github.com/BrenPatF/timer_set_oracle)


### Install 2: Create Log_Set components
#### [Schema: lib; Folder: lib]
- Run script from slqplus:
```
SQL> @install_log_set app
```

27 May 2019: Work in progress: Copied from trapit_oracle_tester and planning to restructure so that calls are made to separate modules for unit testing and other utility code. 

TRansactional API Test (TRAPIT) utility packages for Oracle plus demo base and test programs for Oracle's HR demo schema.

The test utility packages and types are designed as a lightweight PL/SQL-based framework for API testing that can be considered as an alternative to utPLSQL. The 6 July 2018: json_input_output feature branch created that moves all inputs out of the packages and into JSON files, and creates output JSON files that include the actuals. A new table is added to store the input and output JSON files by package and procedure. The output files can be used as inputs to a Nodejs program, recently added to GitHub, to produce result reports formatted in both HTML and text. The input JSON files are read into the new table at installation time, and read from the table thereafter. The Nodejs project includes the formatted reports for this Oracle project. The output JSON files are written to Oracle directory input_dir (and the input JSON files are read from there), but I have copied them into the project oracle root for reference.

<a href="https://github.com/BrenPatF/trapit_nodejs_tester" target="_blank">trapit_nodejs_tester</a>

Pre-requisites
==============
In order to run the demo unit test suite, you must have installed Oracle's HR demo schema on your Oracle instance:

<a href="https://docs.oracle.com/cd/E11882_01/server.112/e10831/installation.htm#COMSC001" target="_blank">Oracle Database Sample Schemas</a>
    
There are no other dependencies outside this project, other than that the latest, JSON, version produces JSON outputs but not formatted reports, which can be obtained from my Nodejs project, mentioned above. I may add a PL/SQL formatter at a later date.

Output logging
==============
The testing utility packages use my own simple logging framework, installed as part of the installation scripts. To replace this with your own preferred logging framework, simply edit the procedure Utils.Write_Log to output using your own logging procedure, and optionally drop the log_headers and log_lines tables, along with the three Utils.*_Log methods.

As far as I know, prior to the latest JSON version, the code should work on any recent-ish version - I have tested on 11.2 and 12.1. The JSON version may require 12.2.

Install steps
=============
     Extract all the files into a directory
     Update Install_SYS.sql to ensure Oracle directory input_dir points to a writable directory on the database sever (in repo now is set to 'C:\input')
    Copy the input JSON files to the directory pointed to by input_dir:
        TT_EMP_BATCH.tt_AIP_Load_Emps.json
        TT_EMP_WS.tt_AIP_Get_Dept_Emps.json
        TT_EMP_WS.tt_AIP_Save_Emps.json
        TT_VIEW_DRIVERS.tt_HR_Test_View_V.json
     Run Install_SYS.sql as a DBA passing new library schema name as parameter (eg @Install_SYS trapit)
     Run Install_HR.sql from the HR schema passing library utilities schema name as parameter  (eg @Install_HR trapit)
     Run Install_Bren.sql from the schema for the library utilities (@Install_Bren)
     Check log files for any errors

Running the demo test suite
===========================
Run R_Suite_br.sql from the schema for the library utilities in the installation directory.