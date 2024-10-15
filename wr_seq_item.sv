class wr_seq_item extends uvm_sequence_item;
  //---------------------------------------
  //data and control fields
  //---------------------------------------
  rand bit [`WR_DATA_WIDTH-1:0] din;
  rand bit wrEn;

  
  //---------------------------------------
  //Utility and Field macros
  //---------------------------------------
  `uvm_object_utils_begin(wr_seq_item)
  `uvm_field_int(din,UVM_ALL_ON)
  `uvm_field_int(wrEn,UVM_ALL_ON)
  `uvm_object_utils_end
  
  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name = "wr_seq_item");
    super.new(name);
  endfunction
  
endclass