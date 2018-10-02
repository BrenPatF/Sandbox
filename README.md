# sandbox - Just to test out README.md ideas<div id="topOfVisibleArea"></div>

# timer-set

> Facilitates code timing for instrumentation and other purposes, with very small footprint in both code and resource usage.

## Usage (extract from main-col-group.js)

```js
const TimerSet = require('timer-set');

const tsColGroup = new TimerSet('ColGroup Timers');
const grp = new ColGroup(INPUT_FILE, DELIM, COL);
tsColGroup.incrementTime('ColGroup');
.
.
.
grp.prList('value', grp.sortByValue());
tsColGroup.incrementTime('sortByValue');

console.log(tsColGroup.formatResults());
```

This will create a timer set and time the sections, with listing at the end:

```
Timer set: ColGroup Timers, constructed at Mon Oct 01 2018 14:25:38, written at Mon Oct 01 2018 14:25:38
========================================================================================================
Timer           Elapsed         USR         SYS       Calls       Ela/Call       USR/Call       SYS/Call
-----------  ----------  ----------  ----------  ----------  -------------  -------------  -------------
ColGroup           0.05        0.00        0.01           1        0.04800        0.00387        0.00775
listAsIs           0.09        0.01        0.02           1        0.08500        0.01150        0.01750
sortByKey          0.06        0.01        0.02           1        0.05600        0.00788        0.01762
sortByValue        0.05        0.00        0.01           1        0.05100        0.00200        0.00975
(Other)            0.00        0.00        0.00           1        0.00000        0.00000        0.00000
-----------  ----------  ----------  ----------  ----------  -------------  -------------  -------------
Total              0.24        0.03        0.05           5        0.04800        0.00505        0.01052
-----------  ----------  ----------  ----------  ----------  -------------  -------------  -------------
[Timer timed (per call in ms): Elapsed: 0.16832, USR: 0.00000, SYS: 0.01856]
```

## API

```js
const TimerSet = require('timer-set');
```

### const ts = new TimerSet(tsName);

Constructs a new timer set `ts` with name `tsName`.

### ts.incrementTime(timerName);

Increments the timing statistics (elapsed, user and system CPU, and number of calls) for a timer `timerName` within the timer set `ts` with the times passed since the previous call to incrementTime, initTime or the constructor of the timer set instance. Resets the statistics for timer set `ts` to the current time, so that the next call to incrementTime measures from this point for its increment.

### ts.initTime();

Resets the statistics for timer set `ts` to the current time, so that the next call to incrementTime measures from this point for its increment. This is only used where there are gaps between sections to be timed.

### ts.getTimers();

Returns the results for timer set `ts` in an array of objects, with fields:

* `timer`: timer name
* `ela`: elapsed time in ms
* `usr`: user CPU time in ms
* `sys`: system CPU time in ms
* `calls`: number of calls

After a record for each named timer, in order of creation, there are two calculated records:

* `Other`: differences between `Total` values and the sums of the named timers
* `Total`: totals calculated from the times at timer set construction

### ts.formatTimers(time_width, time_dp, time_ratio_dp, calls_width);

Returns the results for timer set `ts` in an array of formatted strings, including column headers and formatting lines, with fields as in getTimers, but with times in seconds, and per call values added, with parameters:

* `time_width`: width of time fields (excluding decimal places), default 8
* `time_dp`: decimal places to show for absolute time fields, default 2
* `time_ratio_dp`: decimal places to show for per call time fields, default 5
* `calls_width`: width of calls field, default 10

### TimerSet.getSelfTimer();

Static method to time the incrementTime method as a way of estimating the overhead in using the timer set. Constructs a timer set instance and calls incrementTime on it within a loop until 0.1s has elapsed.

Returns elapsed, user and system CPU times in ms per call.

### TimerSet.formatSelfTimer(time_width, time_dp, time_ratio_dp);

Static method to return the results from getSelfTimer in a formatted string, with parameters as formatTimers (but any extra spaces are trimmed here).

### ts.formatResults(time_width, time_dp, time_ratio_dp, calls_width);

Returns the results for timer set `ts` in a formatted string, with parameters as formatTimers. It uses the array returned from  formatTimers and includes a header line with timer set construction and writing times, and a footer of the self-timing values.

## Install

With [npm](https://npmjs.org/) installed, run

```
$ npm install timer-set
```

## See also

- [trapit (unit testing package)](https://github.com/BrenPatF/trapit_nodejs_tester)

## License

ISC
