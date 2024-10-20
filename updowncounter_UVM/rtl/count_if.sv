
interface count_if(input bit clock);
   
	logic [3:0] data_in;
	logic [3:0] data_out;
	logic reset;
	logic mode;
	logic load;


   //Write Driver clocking block
   clocking wr_drv_cb@(posedge clock);
      default input #1 output #1;
	output data_in;
	output mode;
	output reset;
	output load;
   endclocking: wr_drv_cb
 

   
   //Read monitor clocking block
   clocking rd_mon_cb@(posedge clock);
      default input #1 output #1;
      	input data_out;
	input data_in;
	input mode;
	input reset;
	input load;

   endclocking: rd_mon_cb

   //Write Driver modport
   modport WR_DRV_MP (clocking wr_drv_cb);


   //Read Monitor modport
   modport RD_MON_MP (clocking rd_mon_cb);
    

endinterface: count_if

