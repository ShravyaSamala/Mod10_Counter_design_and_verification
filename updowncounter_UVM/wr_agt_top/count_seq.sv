class count_base_seq extends uvm_sequence #(count_trans);  	
`uvm_object_utils (count_base_seq)
count_config c_cfg;
function new(string name ="count_base_seq");
super.new(name);
endfunction
virtual task pre_body();
uvm_config_db #(count_config) :: get(null,get_full_name(),"count_config",c_cfg);
endtask

virtual task body();

`uvm_info(get_full_name(),"SEQ BODY",UVM_LOW)
repeat(c_cfg.count)
begin
req = count_trans :: type_id :: create ("req");
start_item(req);
assert(req.randomize());
//req.print();
finish_item(req);
end
endtask
	
endclass

