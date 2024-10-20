
module top();

   //Import count_pkg
   import count_pkg::*;   
    
   parameter cycle = 10;
  
   reg clock;

   count_if DUV_IF(clock);

   count_base_test base_test_h;

   count_test_extnd1 ext_test_h1;
   
  
   count_mod10 COUNT(.clock	(clock),
                 .reset   (DUV_IF.reset),
                 .data_out   (DUV_IF.data_out),
                 .mode       (DUV_IF.mode),
                 .load      (DUV_IF.load),
				 .data_in (DUV_IF.data_in)
                ); 

  
   initial
      begin
         clock = 1'b0;
         forever #(cycle/2) clock = ~clock;
      end
   
   initial
      begin
	 
	`ifdef VCS
         $fsdbDumpvars(0, top);
        `endif

	//Create the objects for different testcases and pass the interface instances as arguments
         //Call the virtual task build and virtual task run       
         if($test$plusargs("TEST1"))
            begin
               base_test_h = new(DUV_IF,DUV_IF, DUV_IF);
               number_of_transactions = 500;
               base_test_h.build();
               base_test_h.run();
               $finish;
            end

         if($test$plusargs("TEST2"))
            begin
               ext_test_h1 = new(DUV_IF,DUV_IF, DUV_IF);
               number_of_transactions = 500;
               ext_test_h1.build();
               ext_test_h1.run(); 
               $finish;
            end
      end
endmodule
