


class count_sb extends uvm_scoreboard;

`uvm_component_utils (count_sb)
uvm_blocking_get_port #(count_trans) GP;
   count_trans mon_data;
	count_trans rm_data;  
   count_trans cov_data;

static bit[3:0] count;
static int mon_data_count = 0;
static int data_verified = 0;

//--------------------------------------------------------------------------------------------------------------------
function new(string name = "count_sb",uvm_component parent);
super.new(name,parent);
GP = new("GP",this);
mem_coverage = new();
endfunction

   
//---------------------------------------------------------------------------------------------------------------
   virtual function void report();
      $display(" ------------------------ SCOREBOARD REPORT ----------------------- \n ");
      $display("\t %0d Data Generated,\n \t%0d Read Data Verified \n",
                                             mon_data_count,data_verified);
	$display("function coverage %d",this.mem_coverage.get_coverage());

      $display(" ------------------------------------------------------------------ \n ");
   endfunction: report

//-----------------------------------------------------------------------------------------------------------------------
task run_phase(uvm_phase phase);
`uvm_info(get_full_name(),"SB RUN PHASE",UVM_LOW)

forever
begin
	GP.get(mon_data);
	mon_data_count++;
	$cast(rm_data,mon_data.clone());
	$display("==========DATA FROM DUT=============");
	rm_data.print();
	model_counter(mon_data);
	$display("========DATA_FROM_REF_MODEL=========");
	mon_data.print();
	if(mon_data.compare(rm_data))
	begin
		$display("transaction %0d is verified",mon_data.transaction_id);
		data_verified++;
	end
	else
		$display("transaction %0d is mismatched",mon_data.transaction_id);

	$cast(cov_data,mon_data.clone());
          mem_coverage.sample();
end
endtask	

//----------------------------------------------------------------------------------------------------------------------
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

mon_data.data_out = count;
endtask:model_counter
//--------------------------------------------------------------
/* task count_compare(count_trans rm1_data,count_trans rc_data);
	
	 if(rm1_data.data_out == rc_data.data_out)
			begin
				$display("Count Matches");
				data_verified++;
			end
		else 
			$display("Count Mismatches");
          $cast(cov_data,mon_data.clone());
          mem_coverage.sample();
    	
   endtask: count_compare */
/*
function void extract_phase (uvm_phase phase);
this.report();
endfunction
*/

//---------------------------------------------------------------------------------
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

endclass: count_sb








