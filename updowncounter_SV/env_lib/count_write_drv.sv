
class count_write_drv;
    virtual count_if.WR_DRV_MP wr_drv_if;


   count_trans data2duv;

   
   mailbox #(count_trans) gen2wr;  

   function new(virtual count_if.WR_DRV_MP wr_drv_if,
                mailbox #(count_trans) gen2wr);
      this.wr_drv_if = wr_drv_if;
      this.gen2wr    = gen2wr;
   endfunction: new

   virtual task drive();
	@(wr_drv_if.wr_drv_cb);
	wr_drv_if.wr_drv_cb.data_in <= data2duv.data_in;
	wr_drv_if.wr_drv_cb.mode <= data2duv.mode;
	wr_drv_if.wr_drv_cb.load  <= data2duv.load;
	wr_drv_if.wr_drv_cb.reset <= data2duv.reset;

       repeat(2)
       @(wr_drv_if.wr_drv_cb);
         
   endtask: drive

     
   virtual task start();
      fork
         forever
            begin
               gen2wr.get(data2duv);
               drive();
            end
      join_none
   endtask: start

endclass: count_write_drv
