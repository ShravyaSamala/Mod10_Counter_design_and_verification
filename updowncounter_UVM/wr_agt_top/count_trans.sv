
class count_trans extends uvm_sequence_item;
 `uvm_object_utils_begin(count_trans)
	`uvm_field_int(transaction_id,UVM_ALL_ON+UVM_DEC)
	`uvm_field_int(reset,UVM_ALL_ON+UVM_BIN)
	`uvm_field_int(load,UVM_ALL_ON+UVM_BIN)
	`uvm_field_int(mode,UVM_ALL_ON+UVM_BIN)
	`uvm_field_int(data_in,UVM_ALL_ON+UVM_DEC)	
	`uvm_field_int(data_out,UVM_ALL_ON+UVM_DEC)
 `uvm_object_utils_end
   
rand bit[3:0] data_in;
rand bit mode;
rand bit load;
rand bit reset;
logic [3:0] data_out;
static int transaction_id;


   
constraint VALID_LOAD {load dist{0:=100, 1:=1};}
constraint VALID_MODE {mode dist{0:=50,1:=50};}
constraint VALID_DATA {data_in inside {[0:9]};}
constraint VALID_RESET {reset dist {0:=300, 1:=1};}


function new (string name = "count_trans");
super.new(name);
endfunction
 
function void post_randomize();
	transaction_id++;
endfunction: post_randomize


endclass: count_trans
