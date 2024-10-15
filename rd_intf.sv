interface rd_intf(input logic rdClk,rst);
  
  
  //declaring the signals
  logic rdEn;
  logic [7:0] dout;
  logic fifoEmpty;
  
  //driver clocking block
  clocking rd_driver_cb @(posedge rdClk);
    default input #1 output #1;
    input fifoEmpty;
    input dout;
    output rdEn;  
  endclocking
  
  //monitor clocking block
  clocking rd_monitor_cb @(posedge rdClk);
    default input #1 output #1;
    input dout;
    input fifoEmpty;
    input rdEn;
  
  endclocking
    
  //driver modport
  modport DRIVER  (clocking rd_driver_cb,input rdClk,rst);
  
  //monitor modport  
    modport MONITOR (clocking rd_monitor_cb,input rdClk,rst);
  
endinterface
    