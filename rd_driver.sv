
`define rDRIV_IF rd_vif.DRIVER.rd_driver_cb

class rd_driver extends uvm_driver #(rd_seq_item);
  
  virtual rd_intf rd_vif;
  `uvm_component_utils(rd_driver)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual rd_intf)::get(this, "", "rd_vif", rd_vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".rd_vif"});
  endfunction: build_phase
 
  virtual task run_phase(uvm_phase phase);
    `rDRIV_IF.rdEn <= 0;
    forever begin
   // seq_item_port.get_next_item(req);
     drive();
     // seq_item_port.item_done();
      
    end
        
  endtask
  
  
  virtual task drive();
    seq_item_port.get_next_item(req);
    wait(rd_vif.rst==0);
    //@(posedge rd_vif.rdClk);
    `rDRIV_IF.rdEn <= 0;
    //seq_item_port.get_next_item(req);
    if(rd_vif.fifoEmpty==0 && req.rdEn==1) begin
     // 
        if(req != null)
          begin
            `rDRIV_IF.rdEn <= req.rdEn;
            if(req.rdEn)
              begin
               // `rDRIV_IF.d <= req.din;
                rd_vif.dout<=`rDRIV_IF.dout ;
                seq_item_port.item_done();
              end
           //seq_item_port.item_done();
           
          end
    //end
   
    end
    
  endtask : drive
 

endclass
