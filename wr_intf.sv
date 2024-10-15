interface wr_intf(input logic wrClk,rst);
  
  
  //declaring the signals
  logic wrEn;
  logic [7:0] din;
  logic fifoFull;
  
  //driver clocking block
  clocking wr_driver_cb @(posedge wrClk);
    default input #1 output #1;
    input fifoFull;
    output din;
    output wrEn;  
  endclocking
  
  //monitor clocking block
  clocking wr_monitor_cb @(posedge wrClk);
    default input #1 output #1;
    input din;
    input fifoFull;
    input wrEn;
  
  endclocking
    
  //driver modport
  modport DRIVER  (clocking wr_driver_cb,input wrClk,rst);
  
  //monitor modport  
  modport MONITOR (clocking wr_monitor_cb,input wrClk,rst);
  
endinterface
    
