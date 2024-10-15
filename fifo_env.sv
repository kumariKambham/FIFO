`include "wr_agent.sv"
`include "rd_agent.sv"
`include "scoreboard.sv"


class fifo_env extends uvm_env;
  `uvm_component_utils(fifo_env)
  
  wr_agent fifo_wr_agnt;
  rd_agent fifo_rd_agnt;
  scoreboard fifo_scb;
   
  function new (string name , uvm_component parent);
    super.new (name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    fifo_wr_agnt = wr_agent::type_id::create("fifo_wr_agnt", this);
    fifo_rd_agnt = rd_agent::type_id::create("fifo_rd_agnt", this);
    fifo_scb = scoreboard::type_id::create("fifo_scb",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    fifo_wr_agnt.wmonitor.wr_item_collected_port.connect(fifo_scb.wr_item_collected_export);
    fifo_rd_agnt.rmonitor.rd_item_collected_port.connect(fifo_scb.rd_item_collected_export);     //aport_rd);
    //mem_agnt.monitor.item_collected_port.connect(mem_scb.item_collected_export);
    
    //when u have multiple agents and one scoreboard.. use the below command
//    fifo_rd_agnt_ex1.r_moni_h.rd_item_collect_port.connect(fifo_scb.item_collected_export_1);
    
  endfunction
endclass
  