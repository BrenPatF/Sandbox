# Net_Pipe
Oracle PL/SQL network analysis module.

The module contains a PL/SQL package for the efficient analysis of networks that can be specified
by a view representing their node pair links. The package has a pipelined function that returns a
record for each link in all connected subnetworks, with the root node id used to identify the
subnetwork that a link belongs to. Examples are included showing how to call the function from SQL
to list a network in detail, or at any desired level of aggregation. I find it quite useful to map out a database schema like this.

See [PL/SQL Pipelined Function for Network Analysis](http://aprogrammerwrites.eu/?p=1426), May 2015

The package is tested using the Math Function Unit Testing design pattern, with test results in HTML and text format included. See test_output\net_pipe.html for the unit test results root page. The module also comes with two example networks.

## Usage - example for app schema foreign key network
### Network detail
```sql
SELECT root_node_id                                                            "Network",
       Count(DISTINCT link_id) OVER (PARTITION BY root_node_id) - 1            "#Links",
       Count(DISTINCT node_id) OVER (PARTITION BY root_node_id)                "#Nodes",
       node_level                                                              "Lev",
       LPad(dirn || ' ', Least(2*node_level, 60), ' ') || node_id || loop_flag "Node",
       link_id                                                                 "Link"
  FROM TABLE(Net_Pipe.All_Nets)
 ORDER BY line_no

[Extract of ouput for 1 subnetwork, see app/net_fk folder for full output]
Network              #Links #Nodes Lev Node                                                Link
-------------------- ------ ------ --- --------------------------------------------------- ------------------------------------
SDO_COORD_AXES|MDSYS     31     15   0 SDO_COORD_AXES|MDSYS                                ROOT
                                     1 > SDO_COORD_AXIS_NAMES|MDSYS                        coord_axis_foreign_axis|mdsys
                                     1 > SDO_COORD_SYS|MDSYS                               coord_axis_foreign_cs|mdsys
                                     2   < SDO_COORD_REF_SYS|MDSYS                         coord_ref_sys_foreign_cs|mdsys
                                     3     < SDO_COORD_OPS|MDSYS                           coord_operation_foreign_source|mdsys
                                     4       = SDO_COORD_OPS|MDSYS*                        coord_operation_foreign_legacy|mdsys
                                     4       > SDO_COORD_OP_METHODS|MDSYS                  coord_operation_foreign_method|mdsys
                                     5         < SDO_COORD_OP_PARAM_USE|MDSYS              coord_op_para_use_foreign_meth|mdsys
                                     6           > SDO_COORD_OP_PARAMS|MDSYS               coord_op_para_use_foreign_para|mdsys
                                     7             < SDO_COORD_OP_PARAM_VALS|MDSYS         coord_op_para_val_foreign_para|mdsys
                                     8               > SDO_COORD_OPS|MDSYS*                coord_op_para_val_foreign_op|mdsys
                                     8               > SDO_COORD_OP_METHODS|MDSYS*         coord_op_para_val_foreign_meth|mdsys
                                     8               > SDO_UNITS_OF_MEASURE|MDSYS          coord_op_para_val_foreign_uom|mdsys
                                     9                 < SDO_COORD_AXES|MDSYS*             coord_axis_foreign_uom|mdsys
                                     9                 > SDO_ELLIPSOIDS|MDSYS              ellipsoid_foreign_legacy|mdsys
                                    10                   < SDO_DATUMS|MDSYS                datum_foreign_ellipsoid|mdsys
                                    11                     < SDO_COORD_REF_SYS|MDSYS*      coord_ref_sys_foreign_datum|mdsys
                                    11                     = SDO_DATUMS|MDSYS*             datum_foreign_legacy|mdsys
                                    11                     > SDO_PRIME_MERIDIANS|MDSYS     datum_foreign_meridian|mdsys
                                    12                       > SDO_UNITS_OF_MEASURE|MDSYS* prime_meridian_foreign_uom|mdsys
                                    10                   > SDO_UNITS_OF_MEASURE|MDSYS*     ellipsoid_foreign_uom|mdsys
                                     9                 = SDO_UNITS_OF_MEASURE|MDSYS*       unit_of_measure_foreign_legacy|mdsys
                                     9                 = SDO_UNITS_OF_MEASURE|MDSYS*       unit_of_measure_foreign_uom|mdsys
                                     4       > SDO_COORD_REF_SYS|MDSYS*                    coord_operation_foreign_target|mdsys
                                     4       < SDO_COORD_REF_SYS|MDSYS*                    coord_ref_sys_foreign_proj|mdsys
                                     3     < SDO_COORD_OP_PATHS|MDSYS                      coord_op_path_foreign_source|mdsys
                                     4       > SDO_COORD_REF_SYS|MDSYS*                    coord_op_path_foreign_target|mdsys
                                     3     = SDO_COORD_REF_SYS|MDSYS*                      coord_ref_sys_foreign_geog|mdsys
                                     3     = SDO_COORD_REF_SYS|MDSYS*                      coord_ref_sys_foreign_horiz|mdsys
                                     3     = SDO_COORD_REF_SYS|MDSYS*                      coord_ref_sys_foreign_legacy|mdsys
                                     3     = SDO_COORD_REF_SYS|MDSYS*                      coord_ref_sys_foreign_vert|mdsys
                                     3     < SDO_SRIDS_BY_URN|MDSYS                        sys_c006526|mdsys

```
### Network summary
```sql
SELECT root_node_id            "Network",
       Count(DISTINCT link_id) "#Links",
       Count(DISTINCT node_id) "#Nodes",
       Max(node_level)         "Max Lev"
  FROM TABLE(Net_Pipe.All_Nets)
 GROUP BY root_node_id
 ORDER BY 2

Network summary 1 - by subnetwork

Network                                     #Links  #Nodes    Max Lev
------------------------------------------ ------- ------- ----------
BATCH_JOBS|LIB                                   2       2          1
OGIS_GEOMETRY_COLUMNS|MDSYS                      2       2          1
DR$THS_PHRASE|CTXSYS                             2       2          1
SDO_WS_CONFERENCE_PARTICIPANTS|MDSYS             2       2          1
LOG_HEADERS|BENCH                                2       2          1
LOG_CONFIGS|LIB                                  3       3          2
DEPARTMENTS|HR                                   4       2          2
SDO_COORD_AXES|MDSYS                            32      15         12

8 rows selected.

Elapsed: 00:00:00.01
```

To run the examples in a slqplus session from app subfolders (after installation, including examples):

[net_fk]
SQL> @main_fk

[net_brightkite]
SQL> @main_brightkite
This is a fairly large example, the "Friendship network of Brightkite users", having 58,228 nodes and 214,078 links taken from: https://snap.stanford.edu/data/loc-brightkite.html. The analysis SQL ran in around 38 seconds at summary level on my laptop, and 85 seconds at detail level with 214,625 lines spooled.

## API
### View links_v
The pipelined function reads the network configuration by means of a view representing all the links in the network. The view must be created with three character fields, up to 100 characters long:
- link_id
- node_id_fr
- node_id_to

### Querying the network
The detailed network structure can be obtained from a simple query of the pipelined function:
```sql
SELECT * FROM TABLE(Net_Pipe.All_Nets) ORDER BY line_no
```
Options for formatting and aggregating the output can be seen in the usage section above.

## Installation
The base code consists of a PL/SQL package containing a pipelined function, and a view links_v pointing to network data. These can be easily installed into an existing schema following the steps in Install 2 below.

The install steps below also allow for a fuller installation that  includes optional creation of new lib and app schemas, with example network structures and full unit testing. The `lib` schema refers to the schema in which the base package is installed, while the `app` schema refers to the schema where the package is called from and where the optional examples are installed (Install 3).

### Install 1: Install Utils module (optional)
#### [Schema: lib; Folder: (Utils) lib]
- Download and install the Utils module:
[Utils on GitHub](https://github.com/BrenPatF/oracle_plsql_utils)

This module allows for optional creation of new lib and app schemas. Both base and unit test Utils installs are required for the unit test Net_Pipe install (Install 4).

### Install 2: Create Net_Pipe components
#### [Schema: lib; Folder: lib]
- Run script from slqplus:
```
SQL> @install_net_pipe app
```
This creates the required components for the base install along with grants for them to the app schema (passing none instead of app will bypass the grants). This install is all that is required to use the package within the lib schema and app schema (if passed). To grant privileges to another schema, run the grants script directly, passing `schema`:
```
SQL> @grant_net_pipe_to_app schema
```
The package reads the network from a view links_v and the install script above creates a 1-link dummy view. To run against any other network, simply recreate the view to point to the network data, as shown in the example scripts (Install 3).

### Install 3: Example networks (optional)
#### Synonym [Schema: app; Folder: app]
- Run script from slqplus to create the synonym to the lib package:
```
SQL> @c_net_pipe_syns lib
```
#### Foreign keys [Schema: app; Folder: app\net_fk]
- Run script from slqplus:
```
SQL> @install_fk
```
This install creates and populates the table fk_link with the Oracle foreign key network defined by the standard Oracle view all_constraints (which depends on the privileges granted to the app schema). To run the network analysis script against this example:
```
SQL> @main_fk
```
#### Brightkite [Schema: app; Folder: app\net_brightkite]
- Ensure Oracle directory  INPUT_DIR is set up and points to a folder with read/write access
- Place file Brightkite_edges.csv in folder pointed to by Oracle directory INPUT_DIR
- Run script from slqplus:
```
SQL> @install_brightkite
```
This install creates and populates the table net_brightkite with the Brightkite example network. To run the network analysis script against this example:
```
SQL> @main_brightkite
```

### Install 4: Install unit test code (optional)
#### [Schema: lib; Folder: lib]
This step requires the Trapit module option to have been installed as part of Install 1, and requires a minimum Oracle version of 12.2.
- Copy the following file from the root folder to the server folder pointed to by the Oracle directory INPUT_DIR:
  - tt_net_pipe.all_nets_inp.json
- Run script from slqplus:
```
SQL> @install_net_pipe_tt
```
## Unit testing
The unit test program (if installed) may be run from the lib subfolder:

SQL> @r_tests

The program is data-driven from the input file tt_net_pipe.all_nets_inp.json and produces an output file tt_net_pipe.all_nets_out.json, that contains arrays of expected and actual records by group and scenario.

The output file is processed by a nodejs program that has to be installed separately from the `npm` nodejs repository, as described in the Trapit install in `Install 1` above. The nodejs program produces listings of the results in HTML and/or text format, and a sample set of listings is included in the subfolder test_output. To run the processor (in Windows), open a DOS or Powershell window in the trapit package folder after placing the output JSON file, tt_net_pipe.all_nets_out.json, in the subfolder ./examples/externals and run:
```
$ node ./examples/externals/test-externals
```
The three testing steps can easily be automated in Powershell (or Unix bash).

The package is tested using the Math Function Unit Testing design pattern (`See also - Trapit` below). In this approach, a 'pure' wrapper function is constructed that takes input parameters and returns a value, and is tested within a loop over scenario records read from a JSON file.

You can review the  unit test formatted results obtained by the author in the `test_output` subfolder [net_pipe.html is the root page for the HTML version and net_pipe.txt has the results in text format].

There are two diagrams to illustrate the unit testing:

- plsql_network - JSD.png: shows the structure of the unit test wrapper function
- plsql_network - Scenario 3.png: diagram of the 4-subnetwork network in scenario 3

## Operating System/Oracle Versions
### Windows
Windows 10, should be OS-independent
### Oracle
- Tested on Oracle Database Version 18.3.0.0.0
- Base code (and example) should work on earlier versions at least as far back as v10 and v11, while the unit test code requires a minimum version of 12.2

## See also
- [Utils - Oracle PL/SQL general utilities module](https://github.com/BrenPatF/oracle_plsql_utils)
- [Trapit - Oracle PL/SQL unit testing module](https://github.com/BrenPatF/trapit_oracle_tester)
- [Trapit - nodejs unit test processing package](https://github.com/BrenPatF/trapit_nodejs_tester)
   
## License
MIT