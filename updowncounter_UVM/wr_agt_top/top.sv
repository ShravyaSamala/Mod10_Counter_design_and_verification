
module top();

import uvm_pkg ::*;
   //Import count_pkg
   import count_pkg::*;
`include "uvm_macros.svh"   
    
   parameter cycle = 10;
  
   bit clock;

   count_if DUV_IF(clock);
 
   count_mod10 COUNT(.clock	(clock),
                 .reset   (DUV_IF.reset),
                 .data_out   (DUV_IF.data_out),
                 .mode       (DUV_IF.mode),
                 .load      (DUV_IF.load),
		.data_in (DUV_IF.data_in)
                ); 

  
   initial
         forever #(cycle/2) clock = ~clock;
     
   
   initial
      begin
	uvm_config_db #(virtual count_if)::set(null,"*","vif",DUV_IF);
	uvm_top.enable_print_topology=1;
	run_test("count_test");
      end
endmodule
