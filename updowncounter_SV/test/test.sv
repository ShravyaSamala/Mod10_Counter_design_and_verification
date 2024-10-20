class count_trans_extnd1 extends count_trans;
      
   //define a constraint valid_random_data with data inside the range which is not covered 
   //define a constraint valid_random_rd  with rd_address inside the range which is not covered
constraint missed_data_in{data_in dist {1:=1,2:=1,4:=1,8:=1,9:=1};}
constraint missed_load {load == 1;} 
constraint missed_mode {mode dist{0:=5,1:=5};}
endclass 

class count_base_test;

  
   virtual count_if.WR_DRV_MP wr_drv_if; 
   virtual count_if.RD_MON_MP rd_mon_if; 
   virtual count_if.WR_MON_MP wr_mon_if;
   
 
   count_env env_h;
     
   
   function new(virtual count_if.WR_DRV_MP wr_drv_if, 
                virtual count_if.WR_MON_MP wr_mon_if,
                virtual count_if.RD_MON_MP rd_mon_if);
      this.wr_drv_if = wr_drv_if;
      this.wr_mon_if = wr_mon_if;
      this.rd_mon_if = rd_mon_if;
      
      env_h = new(wr_drv_if,wr_mon_if,rd_mon_if);
   endfunction: new

   virtual task build();
      env_h.build();
   endtask: build
   
  
   virtual task run();              
      env_h.run();
   endtask: run   
   
endclass: count_base_test

class count_test_extnd1 extends count_base_test;
      
   
   count_trans_extnd1 data_h1;
   
   
   function new(virtual count_if.WR_DRV_MP wr_drv_if,
                virtual count_if.WR_MON_MP wr_mon_if,
                virtual count_if.RD_MON_MP rd_mon_if);
      super.new(wr_drv_if,wr_mon_if,rd_mon_if);      
   endfunction: new

   //Understand and include the virtual task build 
   //which builds the TB environment
   virtual task build();
      super.build();
   endtask: build
   
   //Understand and include the virtual task run 
   //which runs the simulation for different testcases
   virtual task run();  
      data_h1 = new();
      env_h.gen_h.gen_trans = data_h1;
      super.run();
   endtask: run      
   
endclass: count_test_extnd1

