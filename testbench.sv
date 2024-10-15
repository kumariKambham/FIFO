`include "defines.sv"

`include "uvm_macros.svh" 
`include "wr_intf.sv"
`include "rd_intf.sv"
`include "fifo_test.sv"
`include "my_test.sv"
//`include "virtual_seq.sv"


module tb_top;
 // import uvm_pkg::*;
  bit wrClk;
  bit rdClk;
  bit rst;
  my_test m1;
  
  initial begin
    wrClk=0;
    rdClk=0;
  end
  
    always #`HALF_PERIOD_WRCLK wrClk=~wrClk;
    always #`HALF_PERIOD_RDCLK rdClk=~rdClk;
  initial begin
    rst=1;
    #28;
    rst=0;
   // #200;
    //rst=1;
    //#25;
    //rst=0;
  end
 
  
  wr_intf w_inf_h (wrClk,rst);
  rd_intf r_inf_h (rdClk,rst);
  
  async_fifo DUT
  (.wrClk(w_inf_h.wrClk),
   .wrEn(w_inf_h.wrEn),
   .din(w_inf_h.din),
   .fifoFull(w_inf_h.fifoFull),
   .rdClk(r_inf_h.rdClk),
   .fifoEmpty(r_inf_h.fifoEmpty),
   .rdEn(r_inf_h.rdEn),
   .rst(rst),
   .dout(r_inf_h.dout));
  
 
  initial
    begin
      uvm_config_db #(virtual wr_intf) :: set(uvm_root::get(),"*","wr_vif",w_inf_h);
      uvm_config_db #(virtual rd_intf) :: set(uvm_root::get(),"*","rd_vif",r_inf_h);
    end
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
      #5000ns;
      $finish;
    end
  
  initial
    begin
      run_test("my_test");
      
      //run_test();
    end

  
  
  
endmodule