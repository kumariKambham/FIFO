`include "fifo_env.sv"

class fifo_test extends uvm_test;
  `uvm_component_utils(fifo_test)
  fifo_env env_h;
  
  function new(string name="fifo_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_h=fifo_env::type_id::create("env_h",this);
  endfunction
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
    //print();
  endfunction
  
  function void report_phase(uvm_phase phase);
    uvm_report_server svr;
    super.report_phase(phase);
    
    svr=uvm_report_server::get_server();
    if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0)
      begin
        `uvm_info(get_type_name(),"-----------------------------------------------------",UVM_NONE);
        `uvm_info(get_type_name(),"--------------------   Test Fail  -------------------",UVM_NONE);
        `uvm_info(get_type_name(),"-----------------------------------------------------",UVM_NONE);
      end
    else 
      begin
        `uvm_info(get_type_name(),"-----------------------------------------------------",UVM_NONE);
        `uvm_info(get_type_name(),"--------------------  Test Pass  --------------------",UVM_NONE);
        `uvm_info(get_type_name(),"-----------------------------------------------------",UVM_NONE);
      end
  endfunction
    
endclass

    