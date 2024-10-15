//-------------------------------------------------------------------------
//						mem_agent - www.verificationguide.com 
//-------------------------------------------------------------------------
`include "uvm_macros.svh"
//import uvm_pkg::*;

`include "rd_seq_item.sv"
`include "rd_sequencer.sv"
`include "rd_sequence.sv"
`include "rd_driver.sv"
`include "rd_monitor.sv"

class rd_agent extends uvm_agent;

  //---------------------------------------
  // component instances
  //---------------------------------------
  rd_driver    rdriver;
  rd_sequencer rsequencer;
  rd_monitor   rmonitor;

  `uvm_component_utils(rd_agent)
  
  //---------------------------------------
  // constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    rmonitor = rd_monitor::type_id::create("rmonitor", this);

    //creating driver and sequencer only for ACTIVE agent
    if(get_is_active() == UVM_ACTIVE) begin
      rdriver    = rd_driver::type_id::create("rdriver", this);
      rsequencer = rd_sequencer::type_id::create("rsequencer", this);
    end
  endfunction : build_phase
  
  //---------------------------------------  
  // connect_phase - connecting the driver and sequencer port
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      rdriver.seq_item_port.connect(rsequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass 