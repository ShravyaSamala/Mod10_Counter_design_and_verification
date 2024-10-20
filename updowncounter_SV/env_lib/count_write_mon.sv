
class count_write_mon;

      virtual count_if.WR_MON_MP wr_mon_if;
   count_trans wrdata;
   count_trans data2rm;

      mailbox #(count_trans) mon2rm;
   function new(virtual count_if.WR_MON_MP wr_mon_if,
                mailbox #(count_trans) mon2rm);
      this.wr_mon_if = wr_mon_if;
      this.mon2rm    = mon2rm;
      this.wrdata    = new;
   endfunction: new


   virtual task monitor();
      @(wr_mon_if.wr_mon_cb);
      begin
         wrdata.reset= wr_mon_if.wr_mon_cb.reset;
         wrdata.load =  wr_mon_if.wr_mon_cb.load;
         wrdata.mode= wr_mon_if.wr_mon_cb.mode;
	wrdata.data_in = wr_mon_if.wr_mon_cb.data_in;
        //call the display of count_trans to display the monitor data
 	wrdata.display("DATA FROM WRITE MONITOR");
      
      end
   endtask: monitor
   
   
   //In virtual task start          
   virtual task start();
      //within fork-join_none
      //In forever loop
      fork
         forever
            begin
               monitor(); 
               data2rm = new wrdata;
               mon2rm.put(data2rm);
            end
      join_none
   endtask: start

endclass:count_write_mon
