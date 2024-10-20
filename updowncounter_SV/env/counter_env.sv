
class count_env;

   //Instantiate virtual interface with Write Driver modport,
   //Read Driver modport,Write monitor modport,Read monitor modport
virtual count_if.WR_DRV_MP wr_drv_if;
virtual count_if.RD_MON_MP rd_mon_if;
virtual count_if.WR_MON_MP wr_mon_if;
 

   //Declare 6 mailboxes pacounteterized by count_trans and construct it
      
mailbox #(count_trans) gen2wr = new;
mailbox #(count_trans) mon2rm = new;
mailbox #(count_trans) rd2sb = new;
mailbox #(count_trans) rm2sb = new; 

count_gen gen_h;
count_write_drv wr_drv;
count_write_mon wr_mon;
count_read_mon rd_mon;
count_model count_rm;
count_sb sb_h;

function new(virtual count_if.WR_DRV_MP wr_drv_if,
	virtual count_if.WR_MON_MP wr_mon_if,
	virtual count_if.RD_MON_MP rd_mon_if);
this.wr_drv_if = wr_drv_if;
this.rd_mon_if = rd_mon_if;
this.wr_mon_if = wr_mon_if;

endfunction                                  
  
virtual task build();
gen_h = new(gen2wr);
wr_drv = new(wr_drv_if,gen2wr);
wr_mon= new(wr_mon_if,mon2rm);
rd_mon= new(rd_mon_if,rd2sb);
count_rm = new(mon2rm,rm2sb);
sb_h = new(rm2sb,rd2sb);
endtask

 
   virtual task reset_dut();
      begin
         wr_drv_if.wr_drv_cb.reset<=1;
         repeat (2) @(wr_drv_if.wr_drv_cb);
		 wr_drv_if.wr_drv_cb.reset<=0;
      end
   endtask : reset_dut



virtual task start();
gen_h.start();
wr_drv.start();
wr_mon.start();
rd_mon.start();
count_rm.start();
sb_h.start();
endtask


   virtual task stop();
      wait(sb_h.DONE.triggered);
   endtask : stop 

   //In virtual task run, call reset_dut, start, stop methods & report function from scoreboard
virtual task run();
reset_dut();
start();
stop();
sb_h.report();
endtask
endclass : count_env
