`include "uvm_macros.svh"
//import uvm_pkg::*;

class rd_sequencer extends uvm_sequencer#(rd_seq_item);
  `uvm_component_utils(rd_sequencer);
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
endclass