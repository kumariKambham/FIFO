`include "uvm_macros.svh"
//import uvm_pkg::*;

class rd_new extends uvm_sequence#(rd_seq_item);
  //`uvm_object_utils(rd_new);
  
  function new(string name="rd_new");
    super.new(name);
  endfunction
  /*
  virtual task body();
    for (int idx = 0; idx < `RD_COUNT; idx++)
    begin
      req = rd_seq_item::type_id::create("req");
      start_item(req);
      if (!req.randomize() with {req.rdEn == 1'h1;}) 
        begin
          `uvm_error(get_type_name(), "Randomization failure")
        end
      //req.print();
      finish_item(req);
    end
  endtask*/
endclass
  /*virtual task body();
    repeat(8) begin
     // req=wr_seq_item::type_id::create("req");
      //`uvm_do_with(req,{req.rdEn==1;})
      req = rd_seq_item::type_id::create("req");
    wait_for_grant();
      assert(req.randomize() with {req.rdEn==1'b1;});
    send_request(req);
    wait_for_item_done();
    end
  endtask*/
class rd_sequence extends rd_new#(rd_seq_item);
  `uvm_object_utils(rd_sequence);
  
  function new(string name="rd_sequence");
    super.new(name);
  endfunction
  virtual task body();
    for (int idx = 0; idx < `RD_COUNT; idx++)
    begin
      req = rd_seq_item::type_id::create("req");
      start_item(req);
      if (!req.randomize() with {req.rdEn == 1'h1;}) 
        begin
          `uvm_error(get_type_name(), "Randomization failure")
        end
      //req.print();
      finish_item(req);
    end
  endtask
endclass
      