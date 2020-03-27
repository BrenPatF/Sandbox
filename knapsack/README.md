# sql_demos / knapsack
<img src="../mountains.png">
This project stores the SQL code for solutions to interesting problems I have looked at on my blog, or elsewhere. It includes installation scripts with object creation and data setup, and scripts to run the SQL on the included datasets.
<br><br>

The knapsack subproject has SQL solutions to single and multiple knapsack problems as discussed in the following blog posts:
<br>

- [A Simple SQL Solution for the Knapsack Problem (SKP-1), January 2013](http://aprogrammerwrites.eu/?p=560)
- [An SQL Solution for the Multiple Knapsack Problem (SKP-m), January 2013](http://aprogrammerwrites.eu/?p=635)

[Back to main README: sql_demos](../README.md)

## Prerequisites
In order to install this subproject you need to have executed the first two parts of the installation in [main README: sql_demos](../README.md), i.e. `Install prerequisite modules` and `Create sql_demos common components`. If you executed the third part, `Subproject install steps`, you will have already installed this subproject and can jump to `Running the scripts` below.

## Install steps
- Update the login script knapsack.bat with your own connect string
- Run script from slqplus:
```
SQL> @install_knapsack
```
## Knapsack problems
The problem in general is to maximise profit from packing items (from a set of n items) into m containers while respecting capacity limits on the containers. The difficulty of the problem arises from the number of possible combinations increasing exponentially with problem size. The number of assignments of n items into m containers, disregarding capacity limits, is easily seen to be:
<img src="CodeCogsEqn_pack_3.png">

### One-knapsack problem
In the blog mentioned above I look at a simple example problem having four items, with a weight limit of 9, as shown below:
<img src="Packing, v1.3 - Items.jpg">

There are 16 possible combinations of these items, having from 0 to 4 items. These are depicted below:
<img src="Packing, v1.3 - Combis.jpg">

#### Running the script
```
SQL> @main_kp1
```
### Multi-knapsack problem
For this case, I consider the same simple example problem as in the earlier article, having four items, but now with two containers with individual weight limits of 8 and 10.

We can again depict the 24 possible item combinations in a diagram, with the container limits added:
<img src="Multi, v1.1 - Combis.jpg">

#### Running the script
```
SQL> @main_kpm
```
