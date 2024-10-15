
`define wDRIV_IF wr_vif.DRIVER.wr_driver_cb
//`include "wr_intf.sv"

class wr_driver extends uvm_driver #(wr_seq_item);
  
  virtual wr_intf wr_vif;
  `uvm_component_utils(wr_driver)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (! uvm_config_db#(virtual wr_intf )::get(this,"","wr_vif",wr_vif))
     // if(!uvm_config_db#(virtual mem_if)::get(this, "", "vif", vif))
      `uvm_fatal("NO wr_vif ",{"virtual interface must be set for:",get_type_name(),".wr_vif"});
  endfunction
  virtual task run_phase(uvm_phase phase);
    `wDRIV_IF.wrEn <= 0;
    
    forever begin
     //seq_item_port.get_next_item(req);
      drive();
     //seq_item_port.item_done();
    end
    `uvm_info(get_type_name(), $sformatf("end of run phase in wr driver"), UVM_LOW)
  endtask
  
  virtual task drive();
    wait(wr_vif.rst==0);
    @(posedge wr_vif.wrClk);
    `wDRIV_IF.wrEn <= 0;
   seq_item_port.get_next_item(req);
    if(wr_vif.fifoFull==0 && req.wrEn==1) 
      begin
     // seq_item_port.get_next_item(req);
        if(req != null)
          begin
            `wDRIV_IF.wrEn <= req.wrEn;
            if(req.wrEn)
              begin
                
                `wDRIV_IF.din <= req.din;
               // wr_vif.fifoFull<=`wDRIV_IF.fifoFull ;
              end
            seq_item_port.item_done();
           
          end
   
    end
    
  endtask : drive
endclass
