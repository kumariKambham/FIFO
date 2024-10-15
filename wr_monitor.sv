
class wr_monitor extends uvm_monitor;

  // Virtual Interface

  virtual wr_intf wr_vif;

  // analysis port, to send the transaction to scoreboard

  uvm_analysis_port#(wr_seq_item) wr_item_collected_port;
  
  // The following property holds the transaction information currently
  // begin captured (by the collect_address_phase and data_phase methods).

  wr_seq_item wr_trans_collected;

  `uvm_component_utils(wr_monitor)

  // new - constructor

  function new (string name, uvm_component parent);
    super.new(name, parent);
    wr_trans_collected = new();
    wr_item_collected_port = new("wr_item_collected_port", this);
  endfunction : new

  // build_phase - getting the interface handle

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual wr_intf)::get(this, "", "wr_vif", wr_vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".wr_vif"});
  endfunction: build_phase
  

  // run_phase - convert the signal level activity to transaction level.
  // i.e, sample the values on interface signal ans assigns to transaction class fields

  /*virtual task run_phase(uvm_phase phase);
    forever begin
      if(!wr_vif.rst) begin
        @(posedge wr_vif.wrClk);
        if(wr_vif.wr_monitor_cb.fifoFull==0) begin
        	if(wr_vif.wr_monitor_cb.wrEn) begin
              wr_trans_collected.wrEn = wr_vif.wr_monitor_cb.wrEn;
              wr_trans_collected.din = wr_vif.wr_monitor_cb.din;
              wr_item_collected_port.write(wr_trans_collected);
      		end
        end
        
     end
    end
  endtask : run_phase*/
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge wr_vif.MONITOR.wrClk);
     // wait(wr_vif.wr_monitor_cb.wrEn );
       // trans_collected.addr = vif.monitor_cb.addr;
      if(wr_vif.wr_monitor_cb.wrEn) begin
        wr_trans_collected.wrEn = wr_vif.wr_monitor_cb.wrEn;
        wr_trans_collected.din = wr_vif.wr_monitor_cb.din;
       // trans_collected.rd_en = 0;
      end
     
        wr_item_collected_port.write(wr_trans_collected);
      //end 
    end
  endtask 

endclass : wr_monitor


/*
`include "uvm_macros.svh"
//import uvm_pkg::*;

`define wDRIV_IF wr_vif.MONITOR.wr_monitor_cb

class wr_monitor extends uvm_monitor;// #(wr_seq_item);
  
  virtual wr_intf wr_vif;
  wr_seq_item w_seq;
  `uvm_component_utils(wr_monitor)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_component phase);
    super.build_phase(phase);
    if (! uvm_config_db#(virtual wr_intf )::get(this,"","wr_vif","wr_vif"))
      `uvm_fatal("NO wr_vif ",{"virtual interface must be set for:",get_type_name()});
  endfunction
  
  task run_phase(uvm_component phase);
    
    forever begin
      @(posedge wr_vif.MONITOR.wrClk)
      begin
        if(`wDRIV_IF.wrEn)
          begin
            w_seq.wrEn<=`wDRIV_IF.wrEn;
            w_seq.din<=`wDRIV_IF.din;
          end
      end
    end
        
  endtask
  
    
endclass
*/
