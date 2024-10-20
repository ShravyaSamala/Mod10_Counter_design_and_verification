
class count_driver extends uvm_driver #(count_trans);
`uvm_component_utils (count_driver)
count_config c_cfg;
virtual count_if.WR_DRV_MP vif;

function new(string name= "count_driver",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
`uvm_info(get_full_name(),"DRIVER BUILD PHASE",UVM_LOW)
super.build_phase(phase);
if(!uvm_config_db #(count_config):: get(this,"","count_config",c_cfg))
	`uvm_fatal(get_full_name(),"GETTING IS FAILED")
endfunction


function void connect_phase(uvm_phase phase);
vif = c_cfg.vif;
endfunction

virtual task run_phase(uvm_phase phase);
`uvm_info(get_full_name(),"DRIVER RUN PHASE",UVM_LOW)
forever 
begin
seq_item_port.get_next_item(req);
drive(req);
seq_item_port.item_done();
end
endtask

virtual task drive(count_trans item);
	@(vif.wr_drv_cb);
	vif.wr_drv_cb.data_in <= item.data_in;
	vif.wr_drv_cb.mode <= item.mode;
	vif.wr_drv_cb.load  <= item.load;
	vif.wr_drv_cb.reset <= item.reset;
         
endtask: drive

endclass

