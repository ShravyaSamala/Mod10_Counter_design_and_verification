
// In class count_model

class count_model;
      
   count_trans wrmon_data;

    
   static bit[3:0] count;
   
   mailbox #(count_trans) wr2rm;
   mailbox #(count_trans) rm2sb;

    
   function new(mailbox #(count_trans) wr2rm,
                mailbox #(count_trans) rm2sb);
      this.wr2rm = wr2rm;
      this.rm2sb = rm2sb;
   endfunction: new
   


virtual task model_counter(count_trans wrmon_data);
if(wrmon_data.reset)
	count <= 0;
else if(wrmon_data.load)
	count <= wrmon_data.data_in;
	
else if(wrmon_data.mode)
	begin
		if(count==9)
			count <= 0;
		else
		count <= count+1;
	end
else
	begin
		if(count==0)
		count <= 9;
		else
		count <= count-1;
	end
endtask:model_counter
   
   
   virtual task start();
     
      fork
         begin
                  forever 
                     begin
                       
                        wr2rm.get(wrmon_data);
                        model_counter(wrmon_data);
 			wrmon_data.data_out = count;
                        rm2sb.put(wrmon_data);
                     end
         end
      join_none
   endtask: start

endclass: count_model
