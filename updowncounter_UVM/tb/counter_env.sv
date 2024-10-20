
class count_env extends uvm_env;
`uvm_component_utils (count_env)
uvm_tlm_analysis_fifo #(count_trans) fifo_h;
count_sb sb_h;
count_agent agnth;
count_config c_cfg;



function new(string name= "count_env",uvm_component parent);
super.new(name,parent);
fifo_h = new("fifo_h",this);
endfunction

function void build_phase(uvm_phase phase);
`uvm_info(get_full_name(),"ENV BUILD PHASE",UVM_LOW)
uvm_config_db #(count_config) :: get(this,"","count_config",c_cfg);
super.build_phase(phase);
if(c_cfg.has_scoreboard)
sb_h = count_sb :: type_id :: create("sb_h",this);

agnth = count_agent :: type_id :: create ("agnth",this);
endfunction

function void connect_phase(uvm_phase phase);
`uvm_info(get_full_name(),"ENV CONNECT PHASE",UVM_LOW)
agnth.monh.AP.connect(fifo_h.analysis_export);
if(c_cfg.has_scoreboard)
sb_h.GP.connect(fifo_h.get_export);
endfunction

endclass


