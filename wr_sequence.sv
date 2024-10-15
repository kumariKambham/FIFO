`define WR_COUNT 16
class wr_sequence extends uvm_sequence#(wr_seq_item);
  `uvm_object_utils(wr_sequence);
  
  function new(string name="wr_sequence");
    super.new(name);
  endfunction
  int start_val;
  virtual task body();
    for (int idx = 0; idx < `WR_COUNT ; idx++)
    begin
      req = wr_seq_item::type_id::create("req");
    start_item(req);
      if (!req.randomize() with {req.wrEn == 1'h1;})//req.din == start_val;}) 
      begin
        `uvm_error(get_type_name(), "Randomization failure")
      end
      //req.print();
    finish_item(req);
     // start_val++;
    end
  endtask
endclass
  /*
  virtual task body();
    repeat(8) begin
     // req=wr_seq_item::type_id::create("req");
     // `uvm_do_with(req,{req.wrEn==1;})
  
     req = wr_seq_item::type_id::create("req");
    wait_for_grant();
      assert(req.randomize() with {req.wrEn==1;});
    send_request(req);
    wait_for_item_done();
    end
  endtask
endclass
*/
      