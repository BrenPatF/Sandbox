DEFINE lib=&1
CREATE OR REPLACE SYNONYM log_headers FOR &lib..log_headers
/
CREATE OR REPLACE SYNONYM log_lines FOR &lib..log_lines
/
CREATE OR REPLACE SYNONYM Utils FOR &lib..Utils
/
CREATE OR REPLACE SYNONYM Timer_Set FOR &lib..Timer_Set
/
CREATE OR REPLACE SYNONYM L1_num_arr FOR &lib..L1_num_arr
/
