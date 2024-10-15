//`include "fifo_test.sv"
class my_test extends fifo_test;
  `uvm_component_utils(my_test)
 // fifo_test f1;
  
  wr_sequence wr_seq;
  rd_sequence rd_seq;
  
  function new(string name="my_test", uvm_component parent=null);
    super.new(name,parent);
   // f1=fifo_test::type_id::create("f1",this);
  endfunction
  
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_seq=wr_sequence::type_id::create("wr_seq",this);
    rd_seq=rd_sequence::type_id::create("rd_seq",this);
  endfunction
  
  task run_phase(uvm_phase phase);
  // forever begin
    phase.raise_objection(this);
    
    wr_seq.start(env_h.fifo_wr_agnt.wsequencer);
    rd_seq.start(env_h.fifo_rd_agnt.rsequencer);
    phase.phase_done.set_drain_time(this, 800);
    phase.drop_objection(this);
  //  end
  endtask

  /* 
    phase.raise_objection(this);
      seq.start(env.mem_agnt.sequencer);
    phase.drop_objection(this);
    
    //set a drain-time for the environment if desired
    phase.phase_done.set_drain_time(this, 50);
  endtask : run_phase*/
endclass