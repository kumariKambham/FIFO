class rd_seq_item extends uvm_sequence_item;

  //data and control fields

  bit [`RD_DATA_WIDTH-1:0] dout;
  rand bit rdEn;

  //Utility and Field macros

  `uvm_object_utils_begin(rd_seq_item)
  `uvm_field_int(dout,UVM_ALL_ON)
  `uvm_field_int(rdEn,UVM_ALL_ON)
  `uvm_object_utils_end
  
  //Constructor

  function new(string name = "rd_seq_item");
    super.new(name);
  endfunction
  
endclass