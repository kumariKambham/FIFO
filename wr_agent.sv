


`include "wr_seq_item.sv"
`include "wr_sequencer.sv"
`include "wr_sequence.sv"
`include "wr_driver.sv"
`include "wr_monitor.sv"

class wr_agent extends uvm_agent;

  //---------------------------------------
  // component instances
  //---------------------------------------
  wr_driver    wdriver;
  wr_sequencer wsequencer;
  wr_monitor   wmonitor;

  `uvm_component_utils(wr_agent)
  
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
    
    wmonitor = wr_monitor::type_id::create("wmonitor", this);

    //creating driver and sequencer only for ACTIVE agent
    if(get_is_active() == UVM_ACTIVE) begin
      wdriver    = wr_driver::type_id::create("wdriver", this);
      wsequencer = wr_sequencer::type_id::create("wsequencer", this);
    end
  endfunction : build_phase
  
  //---------------------------------------  
  // connect_phase - connecting the driver and sequencer port
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      wdriver.seq_item_port.connect(wsequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass 