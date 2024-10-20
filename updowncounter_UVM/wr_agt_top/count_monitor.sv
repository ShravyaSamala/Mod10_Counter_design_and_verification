class count_monitor extends uvm_monitor ;
`uvm_component_utils (count_monitor)
virtual count_if.RD_MON_MP vif;

count_config c_cfg;

uvm_analysis_port #(count_trans) AP;

count_trans data2sb;

function new(string name = "count_monitor",uvm_component parent);
super.new(name,parent);
AP = new("AP",this);
endfunction
//------------------------------------------------------------------------------
function void build_phase(uvm_phase phase);
`uvm_info(get_full_name(),"MONITOR BUILD PHASE",UVM_LOW)

super.build_phase(phase);
if(!uvm_config_db #(count_config) :: get (this,"","count_config",c_cfg))
	`uvm_fatal(get_full_name(),"GETTING FAILED IN MONITOR")
endfunction
function void connect_phase(uvm_phase phase);
vif = c_cfg.vif;
endfunction

//---------------------------------------------------------------------------------
virtual task run_phase(uvm_phase phase);
data2sb = count_trans :: type_id :: create ("data2sb");

`uvm_info(get_full_name(),"MONITOR RUN PHASE",UVM_LOW)
repeat(2) @(vif.rd_mon_cb);
forever
	begin 
	monitor(); 
	AP.write(data2sb);
	end
endtask
//-----------------------------------------------------------------------------------
 virtual task monitor();
	@(vif.rd_mon_cb);
 	data2sb.reset= vif.rd_mon_cb.reset;
         data2sb.load =  vif.rd_mon_cb.load;
         data2sb.mode= vif.rd_mon_cb.mode;
	data2sb.data_in = vif.rd_mon_cb.data_in;
        data2sb.data_out = vif.rd_mon_cb.data_out;    
 endtask: monitor


endclass
