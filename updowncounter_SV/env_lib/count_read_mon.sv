/********************************************************************************************

Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename       :  count_read_mon.sv   

Description    :  Monitor class for dual port count_testbench

Author Name    :  Putta Satish

Support e-mail :  techsupport_vm@maven-silicon.com 

Version        :  1.0

Date           :  02/06/2020

***********************************************************************************************/
//In class count_read_mon

class count_read_mon;

   //Instantiate virtual interface instance rd_mon_if of type count_if with RD_MON_MP modport
   virtual count_if.RD_MON_MP rd_mon_if;

   //Declare three handles 'rddata', 'data2rm' and 'data2sb' of class type count_trans
   count_trans rddata, data2sb;

   //Declare two mailboxes 'mon2rm' and 'mon2sb' pacounteterized by type count_trans
   mailbox #(count_trans) rd2sb;
   

   function new(virtual count_if.RD_MON_MP rd_mon_if,
                mailbox #(count_trans) rd2sb);
      this.rd_mon_if = rd_mon_if;
      this.rd2sb    = rd2sb;
      this.rddata    = new;
   endfunction: new


   virtual task monitor();
      @(rd_mon_if.rd_mon_cb);
      begin
         rddata.data_out = rd_mon_if.rd_mon_cb.data_out;
	/* rddata.data_in = rd_mon_if.rd_mon_cb.data_in; //I have taken this inputs only for cross verifying
	rddata.load = rd_mon_if.rd_mon_cb.load;
	rddata.mode = rd_mon_if.rd_mon_cb.mode;
	rddata.reset  = rd_mon_if.rd_mon_cb.reset; */

         //call the display of the count_trans to display the monitor data
         rddata.display("DATA FROM READ MONITOR");    
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
               data2sb = new rddata;
               rd2sb.put(data2sb);
            end
      join_none
   endtask: start

endclass: count_read_mon
