
class count_test extends uvm_test;
`uvm_component_utils (count_test)
count_config c_cfg;
count_env envh;
count_base_seq seqh;


function new(string name = "count_test",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
`uvm_info(get_full_name(),"TEST BUILD PHASE",UVM_LOW)

c_cfg = count_config :: type_id :: create("c_cfg");
c_cfg.count = 1000;
c_cfg.is_active = UVM_ACTIVE;
c_cfg.has_scoreboard = 1;
if(!uvm_config_db #(virtual count_if) :: get(this,"","vif",c_cfg.vif))
	`uvm_fatal(get_full_name(),"GET IS FAILED IN TEST")



uvm_config_db #(count_config) :: set(this,"*","count_config",c_cfg);
envh = count_env :: type_id :: create ("envh",this);
seqh = count_base_seq :: type_id :: create("seqh");
endfunction

virtual task run_phase(uvm_phase phase);
phase.raise_objection(this);
`uvm_info(get_full_name(),"TEST RUN_PHASE",UVM_LOW)
seqh.start(envh.agnth.seqrh);
phase.drop_objection(this);
endtask
endclass
