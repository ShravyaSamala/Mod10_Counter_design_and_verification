class count_sequencer extends uvm_sequencer #(count_trans);
`uvm_component_utils (count_sequencer)


function new(string name = "count_sequencer",uvm_component parent);
super.new(name,parent);
endfunction
//function void build_phase(uvm_phase phase);
//set_arbitration(UVM_ARB_SEQ_RANDOM);
endclass
