
module count_mod10 ( clock, reset, load, mode, data_in,data_out);

   input clock;                              
   input [3 : 0] data_in;
   input load;                            
   input mode;   
	input reset;
   output reg [3:0] data_out;

  always @(posedge clock)
	begin
		if(reset)
			data_out <= 0;
		else if(load)
			data_out <= data_in;
		else if(mode)
			begin
				if(data_out == 9)
					data_out <= 0;
				else
					data_out <= data_out + 1;
			end
		else
			begin
				if(data_out == 0)
					data_out <= 9;
				else
					data_out <= data_out -1;
			end
	end
endmodule
 
                    


