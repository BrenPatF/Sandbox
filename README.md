# sandbox - Just to test out README.md ideas<div id="topOfVisibleArea"></div>

# timerset
Facilitates code timing for instrumentation and other purposes, with very small footprint in both code and resource usage. Construction and reporting require only a single line each, regardless of how many timers are included in a set. Tested on Unix and Windows.

## Usage (extract from maincolgroup.py)
```py
from context import timerset
import colgroup as cg

ts = timerset.TimerSet('Timer_ts')

(input_file, delim, col) = './examples/colgroup/fantasy_premier_league_player_stats.csv', ',', 6

grp = cg.ColGroup(input_file, delim, col)
ts.increment_time ('ColGroup')
.
.
.
grp.pr_list('value (lambda)', grp.sort_by_value_lambda())
ts.increment_time ('sort_by_value_lambda')

print(ts.format_results())
```
This will create a timer set and time the sections, with listing at the end:
```
Timer set: Timer_ts, constructed at 2018-12-04 07:11:19, written at 2018-12-04 07:11:19
=======================================================================================
Timer                    Elapsed         CPU       Calls       Ela/Call       CPU/Call
--------------------  ----------  ----------  ----------  -------------  -------------
ColGroup                    0.08        0.05           1        0.08144        0.04688
list_as_is                  0.01        0.00           1        0.01002        0.00000
sort_by_key                 0.01        0.00           1        0.00841        0.00000
sort_by_valueIG             0.01        0.00           1        0.01271        0.00000
sort_by_value_lambda        0.01        0.00           1        0.01315        0.00000
(Other)                     0.00        0.00           1        0.00009        0.00000
--------------------  ----------  ----------  ----------  -------------  -------------
Total                       0.13        0.05           6        0.02097        0.00781
--------------------  ----------  ----------  ----------  -------------  -------------
[Timer timed (per call in ms): Elapsed: 0.00249, CPU: 0.00233]
```
To run the example from root (timerset) folder (Unix form):

$ python ./examples/colgroup/maincolgroup.py

## API
```py
from context import timerset
```

### ts = timerset.TimerSet('ts_name')
Constructs a new timer set `ts` with name `ts_name`.

### ts.increment_time(timer_name);
Increments the timing statistics (elapsed, user and system CPU, and number of calls) for a timer `timer_name` within the timer set `ts` with the times passed since the previous call to increment_time, initTime or the constructor of the timer set instance. Resets the statistics for timer set `ts` to the current time, so that the next call to increment_time measures from this point for its increment.

### ts.init_time();
Resets the statistics for timer set `ts` to the current time, so that the next call to increment_time measures from this point for its increment. This is only used where there are gaps between sections to be timed.

### ts.get_timers()
Returns the results for timer set `ts` in an array of tuples, with fields:

* `timer`: timer name
* `ela`: elapsed time in s
* `cpu`: CPU time in s
* `calls`: number of calls

After a record for each named timer, in order of creation, there are two calculated records:

* `Other`: differences between `Total` values and the sums of the named timers
* `Total`: totals calculated from the times at timer set construction

### ts.format_timers(time_width, time_dp, time_ratio_dp, calls_width)
Returns the results for timer set `ts` in an array of formatted strings, including column headers and formatting lines, with fields as in get_timers, times in seconds, and per call values added, with parameters:

* `time_width`: width of time fields (excluding decimal places), default 8
* `time_dp`: decimal places to show for absolute time fields, default 2
* `time_ratio_dp`: decimal places to show for per call time fields, default 5
* `calls_width`: width of calls field, default 10

### TimerSet.get_self_timer()
Static method to time the increment_time method as a way of estimating the overhead in using the timer set. Constructs a timer set instance and calls increment_time on it within a loop until 0.1s has elapsed.

Returns a tuple, with fields:

* `ela`: elapsed time per call in ms
* `cpu`: CPU time per call in ms

### TimerSet.format_self_timer(time_width, time_dp, time_ratio_dp)
Static method to return the results from get_self_timer in a formatted string, with parameters as format_timers (but any extra spaces are trimmed here).

### ts.format_results(time_width, time_dp, time_ratio_dp, calls_width)
Returns the results for timer set `ts` in a formatted string, with parameters as format_timers. It uses the array returned from format_timers and includes a header line with timer set construction and writing times, and a footer of the self-timing values.

## Install
Run
```
$ pip install timerset
```
### Unit testing
The unit test program may be run from the package root folder (timerset):

python ./test/testtimerset.py

The program is data-driven from the input file timerset.json and produces an output file timerset_out.json, that contains arrays of expected and actual records by group and scenario.

If desired, the output file can be processed by a separate Javascript program that has to be downloaded separately from the `npm` Javascript repository. The Javascript program produces listings of the results in html and/or text format, and a sample set of listings is included in the folder test\timerset. To install the Javascript program, `trapit`:

With [npm](https://npmjs.org/) installed, run

```
$ npm install trapit
```

The package is tested using the Math Function Unit Testing design pattern (`See also` below). In this approach, a 'pure' wrapper function is constructed that takes input parameters and returns a value, and is tested within a loop over scenario records read from a JSON file.

The wrapper function represents a generalised transactional use of the package in which multiple timer sets may be constructed, and then timings carried out and reported on at the end of the transaction. 

This kind of package would usually be thought hard to unit-test, with CPU and elapsed times being inherently non-deterministic. However, this is a good example of the power of the design pattern that I recently introduced: One of the inputs is a yes/no flag indicating whether to mock the system timing calls, or not. The function calls used to return epochal CPU and elapsed times are actually parameters that take the (Windows) system functions as defaults, while in the mocked case deterministic versions are supplied by the test driver, that read the values to return from the input scenario data. In this way we can test correctness of the timing aggregations, independence of timer sets etc. using the deterministic functions; on the other hand, one of the key benefits of automated unit testing is to test the actual dependencies, and we do this in the non-mocked case by passing in 'sleep' times to the wrapper function and testing the outputs against ranges of values.

## Operating Systems
The package works on both Unix and Windows. It requires Python 3.x, and has been tested on:
### Windows
Windows 10, python 3.7.1
### Unix
Oracle Linux Server 7.5 (via Virtualbox on Windows host), python 3.7.1

## See also
- [trapit unit testing package on GitHub](https://github.com/BrenPatF/trapit_nodejs_tester)
- [python timerset package on GitHub](https://github.com/BrenPatF/timerset_python)
- [Code Timing and Object Orientation and Zombies, Brendan Furey, November 2010](http://www.scribd.com/doc/43588788/Code-Timing-and-Object-Orientation-and-Zombies)
   
## License
MIT