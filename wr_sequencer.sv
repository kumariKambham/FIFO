`include "uvm_macros.svh"
//import uvm_pkg::*;

class wr_sequencer extends uvm_sequencer#(wr_seq_item);
  `uvm_component_utils(wr_sequencer);
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
endclass