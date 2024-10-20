
class count_config extends uvm_object;
`uvm_object_utils (count_config)
virtual count_if vif;
uvm_active_passive_enum is_active = UVM_ACTIVE;
bit has_scoreboard = 0;
int count = 10;


function new(string name = "count_config");
super.new(name);
endfunction
endclass
      
 


