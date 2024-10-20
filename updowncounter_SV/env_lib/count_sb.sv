
class count_sb;
   //Declare an event DONE
   event DONE; 

   int data_verified = 0;
   int rm_data_count = 0;
   int mon_data_count = 0;

   count_trans rm_data;  
   count_trans rcvd_data;
   count_trans cov_data;

   //Declare two mailboxes as 'rm2sb','rdmon2sb' pacounteterized by count_trans 
   mailbox #(count_trans) rm2sb;      //ref model to sb
   mailbox #(count_trans) rdmon2sb;   //rdmon to sb
   
   covergroup mem_coverage;
      option.per_instance=1;     

		DATA_IN : coverpoint cov_data.data_in {
					illegal_bins ILLB = {[10:15]};}
		LOAD : coverpoint cov_data.load; 
		MODE : coverpoint cov_data.mode;
		RESET : coverpoint cov_data.reset{
					bins ONE_reset = {1};}
		DATA_OUT : coverpoint cov_data.data_out {
					illegal_bins ILLB2={[10:15]};}
		DATA_OUTxMODExLOAD: cross DATA_OUT,MODE,LOAD;
   
   endgroup : mem_coverage
   
      function new(mailbox #(count_trans) rm2sb,
                mailbox #(count_trans) rdmon2sb);
      this.rm2sb    = rm2sb;
      this.rdmon2sb = rdmon2sb;
      mem_coverage  = new;    
   endfunction: new

   //In virtual task start    
   virtual task start();
      //Within fork join_none, inside begin end
      fork
         while(1)
            begin
               //Get the data from mailbox rm2sb 
               rm2sb.get(rm_data);
               //Increment rm_data_count
               rm_data_count++;
               //Get the data from mailbox rdmon2sb
               rdmon2sb.get(rcvd_data);   
               //Increment mon_data_count
               mon_data_count++;    
               //Call the check task and pass 'rcvd_data' handle as the input argument
               check(rm_data,rcvd_data);
            end
      join_none
   endtask: start

   // Understand and include the virtual task check
   virtual task check(count_trans rm1_data,count_trans rc_data);
		begin
	 if(rm1_data.data_out == rc_data.data_out)
				$display("Count Matches");
		else 
				$display("Count Mismatches");
 
   endtask: start

   // Understand and include the virtual task check
   virtual task check(count_trans rm1_data,count_trans rc_data);
		begin
	 if(rm1_data.data_out == rc_data.data_out)
				$display("Count Matches");
		else 
				$display("Count Mismatches");
 
            cov_data = new rm_data;
            //Call t
            cov_data = new rm_data;
            //Call the sample function on the covergroup 
            mem_coverage.sample();
            //Increment data_verified 
            data_verified++;
            //Trigger the event if the verified data count is equal to the sum of number of read and read-write transactions 
            if(data_verified >= (number_of_transactions)) 
               begin             
                  ->DONE;
               end
	end
   endtask: check

   //In virtual function report 
   //display rm_data_count, mon_data_count, data_verified 
   virtual function void report();
      $display(" ------------------------ SCOREBOARD REPORT ----------------------- \n ");
      $display("\t %0d Data Generated,\n \t%0d Read Data Verified \n",
                                             rm_data_count,data_verified);
      $display(" ------------------------------------------------------------------ \n ");
   endfunction: report
    
endclass: count_sb




module semaphore_example;
driver drv [2];
semaphore sem;
initial 
begin
drv[0] = new();
drv[1] = new();
sem = new(1);
fork 
drv[0].send("driver -1");
drv[1].send("driver - 2");
join
end
class driver;
task send(input string message);
sem.get(1);
$display("%s got the key",message);
sem.put(1);
$display("%s dropped the key",message);
endtask
endclass
