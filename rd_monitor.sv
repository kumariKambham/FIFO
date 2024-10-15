class rd_monitor extends uvm_monitor;

  // Virtual Interface

  virtual rd_intf rd_vif;

  // analysis port, to send the transaction to scoreboard

  uvm_analysis_port#(rd_seq_item) rd_item_collected_port;
  
  // The following property holds the transaction information currently
  // begin captured (by the collect_address_phase and data_phase methods).

  rd_seq_item rd_trans_collected;

  `uvm_component_utils(rd_monitor)

  // new - constructor

  function new (string name, uvm_component parent);
    super.new(name, parent);
    rd_trans_collected = new();
    rd_item_collected_port = new("rd_item_collected_port", this);
  endfunction : new

  // build_phase - getting the interface handle

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual rd_intf)::get(this, "", "rd_vif", rd_vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".rd_vif"});
  endfunction: build_phase
  

  // run_phase - convert the signal level activity to transaction level.
  // i.e, sample the values on interface signal ans assigns to transaction class fields

  virtual task run_phase(uvm_phase phase);
    forever begin
      if(!rd_vif.rst) begin
      	@(posedge rd_vif.rdClk);
        if(rd_vif.rd_monitor_cb.fifoEmpty==0) begin
          if(rd_vif.rd_monitor_cb.rdEn) begin
        	rd_trans_collected.rdEn = rd_vif.rd_monitor_cb.rdEn;
        	rd_trans_collected.dout = rd_vif.rd_monitor_cb.dout;
        	rd_item_collected_port.write(rd_trans_collected);
          end
      	end
        
      end else @(posedge rd_vif.rdClk);
    end
  endtask : run_phase
endclass
  /*
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge rd_vif.MONITOR.rdClk);
      //wait(rd_vif.rd_monitor_cb.rdEn );
       // trans_collected.addr = vif.monitor_cb.addr;
      if(rd_vif.rd_monitor_cb.rdEn) begin
        rd_trans_collected.rdEn = rd_vif.rd_monitor_cb.rdEn;
        rd_trans_collected.dout = rd_vif.rd_monitor_cb.dout;
       // trans_collected.rd_en = 0;
      end
        rd_item_collected_port.write(rd_trans_collected);
      //end 
    end
  endtask : run_phase

endclass : rd_monitor




`include "uvm_macros.svh"
//import uvm_pkg::*;

`define rDRIV_IF rd_vif.MONITOR.rd_monitor_cb

class rd_monitor extends uvm_monitor;// #(rd_seq_item);
  
  virtual rd_intf rd_vif;
  rd_seq_item r_seq;
  `uvm_component_utils(rd_monitor)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_component phase);
    super.build_phase(phase);
    if (! uvm_config_db#(virtual rd_intf )::get(this,"","rd_vif","rd_vif"))
      `uvm_fatal("NO rd_vif ",{"virtual interface must be set for:",get_type_name()});
  endfunction
  
  task run_phase(uvm_component phase);
    
    forever begin
      @(posedge rd_vif.MONITOR.rdClk)
      begin
        if(`rDRIV_IF.rdEn)
          begin
            r_seq.rdEn<=`rDRIV_IF.rdEn;
            r_seq.dout<=`rDRIV_IF.dout;
          end
      end
    end
        
  endtask
  
endclass
*/