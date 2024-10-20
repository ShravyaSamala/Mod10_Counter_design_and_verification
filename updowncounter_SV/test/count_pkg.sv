package count_pkg;

   int number_of_transactions = 1;
  
   //`include the files 
`include "count_trans.sv"
`include "count_gen.sv"
 `include "count_write_drv.sv"
 `include "count_write_mon.sv" 
 `include "count_read_mon.sv"
 `include "count_model.sv"
 `include "count_sb.sv"
 `include "counter_env.sv"
 `include "test.sv" 

endpackage
