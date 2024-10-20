class count_gen;

	count_trans gen_trans;
	count_trans data2send;
  
	mailbox #(count_trans) gen2wr;
 
   function new(mailbox #(count_trans) gen2wr);
     
      this.gen2wr = gen2wr;
	this.gen_trans = new;
   endfunction: new

   
   virtual task start();
      fork
         begin
            for(int i=0; i<number_of_transactions; i++)
               begin   
				gen_trans.trans_id++;
                  assert(gen_trans.randomize()); 
                  data2send = new gen_trans;
                  gen2wr.put(data2send);
               end
         end
      join_none
   endtask: start

endclass: count_gen
   
      
 


