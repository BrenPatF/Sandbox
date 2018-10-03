# sandbox - Just to test out README.md ideas<div id="topOfVisibleArea"></div>

# trapit
> The Math Function Unit Testing design pattern, implemented in nodejs

This package supports a new design pattern for unit testing that can be applied in any language, and is here implemented in nodejs. It includes a function to read a JSON file for processing externally-sourced tests, and a set of functions for analysing test results and reporting in plain text and/or html. The package includes several examples of use, for both nodejs programs and externally-sourced tests, and a unit test program for the core function of the package itself, which of course uses the package itself to process results. In this design pattern, the unit test driver program reads the inputs and expected outputs from file, and simply runs the unit under test within a loop, gathering the actual outputs into an object that is passed to the current package for reporting the results.

## Background

On March 23, 2018 I made the following presentation at the Oracle User Group conference in Dublin:

<a href="https://www.slideshare.net/brendanfurey7/database-api-viewed-as-a-mathematical-function-insights-into-testing" target="_blank">Database API Viewed As A Mathematical Function: Insights into Testing</a>

The first section was summarised as:
<blockquote>Developing a universal design pattern for testing APIs using the concept of a 'pure' function as a wrapper to manage the 'impurity' inherent in database APIs</blockquote>

Although the presentation focussed on database testing the design pattern is clearly quite general. This is a unit test assertion package, along with some helper modules, to support the pattern.

The main features of the design pattern:

- The unit under test is viewed from the perspective of a mathematical function having an 'extended signature', comprising any actual parameters and return value, together with other inputs and outputs of any kind
- A wrapper function is constructed based on this conceptual function, and the wrapper function is 'externally pure', while internally handling impurities such as file I/O
- A single unit testing program calls the wrapper function within a loop over scenario records
- The input records for the wrapper function are stored in a separate data file (in JSON format here), that also includes expected outputs and metada records describing the data structure
- The wrapper function returns an augmented scenario record that includes the actual as well as expected outputs, and is stored as a record in an array
- At the end a single call is made to one of the entry point reporting functions that format the results in a single plain text file, or in a set of html pages, or both, and return the number of failed scenarios
- For testing a nodejs program, the reporting function is passed two parameters, the metadata read from the input JSON file plus the array of scenario outputs generated by the wrapper function calls
- For testing external programs (in any language), the function getUTData is called to read the JSON file, and the two parameters from the object read are passed to the reporting functions

Advantages include:

- Once the unit test program is written for one scenario (that includes all data groups), no further programming is required to handle additional scenarios
- The outputs from the unit testing program show exactly what the program actually does in terms of data inputs and outputs
- All unit test programs can follow a single, straightfoward pattern
- The nodejs assertion package can be used to process results files generated from any language as .json files, and four examples from Oracle PL/SQL are included

## Usage

### Usage 1 - testing Javascript programs (extract from test-col-group.js)

```js
const Trapit = require('trapit');
.
.
.
function purelyWrapUnit(callScenario) {
.
.
.
}
const testData = Trapit.getUTData(INPUT_JSON);
const [meta, callScenarios] = [testData.meta, testData.scenarios];

let scenarios = [];
for (const s in callScenarios) {
	scenarios[s] = purelyWrapUnit(callScenarios[s]);
};
const result = Trapit.prUTResultsHTML(meta, scenarios, ROOT)
console.log(Utils.heading(result.nFail + ' of ' + result.nTest + ' scenarios failed, see ' +
   ROOT + result.resFolder + ' for scenario listings'));
```

This extract shows how the package function `getUTData` is used to read the test data JSON file, then after calling the design pattern wrapper function within a loop over the scenarios, the package function `prUTResultsHTML` is called to generate the results output files in HTML format. You can see the output files in the folder mentioned below. 

### Usage 2 - testing external programs (test-externals.js)

The package can be used to report the results of testing programs in any language that follow the same design patter and generate JSON output files in the design pattern format. The following is the complete source code for a driver Javascript program that reads all JSON files in a folder and generates the output files for each one in a separate folder in both text and HTML formats. 
```js
const Trapit = require('trapit');
const ROOT = './examples/externals/';

function testExternal(fileName) {

	const testData = Trapit.getUTData(fileName);
	const [meta, scenarios] = [testData.meta, testData.scenarios];

	return Trapit.prUTResultsTextAndHTML(meta, scenarios, ROOT).nFail;
}

const fs = require('fs');
let failFiles = [];
fs.readdirSync(ROOT).forEach(file => {
	if ( /.*\.json$/.test(file) && testExternal(ROOT + file) ) failFiles.push(file);
});
console.log(failFiles.length + ' externals failed, see ' + ROOT + ' for scenario listings');
failFiles.map(file => console.log(file));
```

 You can see the output files in the folder mentioned below. 

## API

```js
const Trapit = require('trapit');
```

### Trapit.getUTData(dataFile);

Return the contents of the JSON input file, `dataFile` as a Javascript object.

### Trapit.getUTResults(meta, scenarios)

Pure function that returns the test results, based on the input parameters, in the form of a Javascript object, with parameters:

* `meta`: metadata describing the data structures for the unit under test
* `scenarios`: scenarios data, based on the input scenarios augmented with he actuals from testing

This `pure` function is called by the `impure` functions that are used to write the results out to file, in HTML and/or text format, and facilitates unit testing. Normally, it is sufficient to call just one of the `wrapper` functions below.

### Trapit.prUTResultsText(meta, scenarios, rootFolder)

Wrapper function that calls getUTResults, writing a single text file with a summary section for all scenarios, followed by a section for each scenario, with first two parameters the same as getUTResults, plus:

* `rootFolder`: root folder, where the results output files are to be written in a subfolder with name based on the report title, default './'

### Trapit.prUTResultsHTML(meta, scenarios, rootFolder)

Wrapper function that calls getUTResults, writing one summary file in HTML format for all scenarios, with links to a separate file for each scenario. The parameters are the same as for prUTResultsText.

### Trapit.prUTResultsTextAndHTML(meta, scenarios, rootFolder)

Wrapper function that calls getUTResults, writing results output files for both text and HTML formats, as if both the previous wrapper functions were called. The parameters are the same as for prUTResultsText.

## Install

With [npm](https://npmjs.org/) installed, run

```
$ npm install trapit
```
### Unit testing 

```
$ npm test
```
The trapit core function is unit tested, covering five scenarios including exceptions, with each scenario covering a number of sub-scenarios.

## Structure
### Folder structure

- examples: example main programs and unit test programs using the package
	- externals subfolder has externally-sourced JSON output files that are processed by test-externals.js
	- *title* subfolders hold result files for test programs with a single *title*.txt that has all the results in text format...
	- ...and *title*.html as the root page with links for pages per scenario in html format
- lib: entry point and helper modules
- test: test-trapit.js unit test driver; this tests the package itself, and reports the results using the package itself
        - to run from trapit folder: npm test

### Design pattern examples

As well as the unit testing of the package itself, there are three examples of use, two of which have example main programs. To run from the package root, trapit, using the first main program as an example:
```
$ node examples\hello-world\main-hello-world
```

```=================================================================================================
|  Main/Test         |  Unit Module |  Notes                                                       |
|====================|==============|===============================================================
|  main-hello-world  |              |  Simple Hello World program done as pure function to allow   |
|  test-hello-world  |  HelloWorld  |  for unit testing as a simple edge case                      |
----------------------------------------------------------------------------------------------------
|  main-col-group    |              |  A simple file-reading and group-counting module, with       |
|  test-col-group    |  ColGroup    |  logging. Example of testing impure units, and error display |
----------------------------------------------------------------------------------------------------
|  test-externals    |  (external)  |  The externals example, where the assertion package is used  |
|                    |              |  to report the results using externally produced JSON files  |
====================================================================================================
```
### Module structure

As well as the entry point module, Trapit, there are one helper class and three helper modules of pure functions.
```====================================================================================================
|  Module  |  Notes                                                                                |
|===================================================================================================
|  Trapit  |  Entry point module, written with core pure functions to facilitate unit testing and  |
|          |  multiple reporters                                                                   |
----------------------------------------------------------------------------------------------------
|  Utils   |  General utility functions, called mainly by the Text module below                    |
----------------------------------------------------------------------------------------------------
|  Pages   |  Class used to buffer pages of text ahead of writing to file, used by Text and HTML   |
----------------------------------------------------------------------------------------------------
|  Text    |  Module of pure functions that format text report output and buffer using Pages       |
----------------------------------------------------------------------------------------------------
|  HTML    |  Module of pure functions that format HTML report output and buffer using Pages       |
====================================================================================================
```
### Externally-sourced JSON files

The files are from an Oracle project, named {package}.{procedure}_out.json.

See https://github.com/BrenPatF/trapit_oracle_tester for the project that creates these files.

```================================================================================================================
|  File                                       |  Notes                                                         | 
|===============================================================================================================
|  tt_emp_batch.tt_aip_load_emps_out.json     |  Batch loading of employee data from file to table             |
----------------------------------------------------------------------------------------------------------------
|  tt_emp_ws.tt_aip_get_dept_emps_out.json    |  REF cursor getting department, employee data for web service  |
----------------------------------------------------------------------------------------------------------------
|  tt_emp_ws.tt_aip_save_emps_out.json        |  Web service procedure to save employee data                   |
----------------------------------------------------------------------------------------------------------------
|  tt_view_drivers.tt_hr_test_view_v_out.json |  Batch view getting department, employee data                  |
================================================================================================================
```
## See also

- [timer-set (npm module that uses trapit for unit testing)](https://github.com/BrenPatF/timer-set-nodejs)

## License

ISC