
`uvm_analysis_imp_decl(_wrport)
`uvm_analysis_imp_decl(_rdport)
class scoreboard extends uvm_scoreboard;
  

  wr_seq_item wr_pkt[$];
  rd_seq_item rd_pkt[$];
  
 // wr_seq_item w_pkt;
  //rd_seq_item r_pkt;
    
  
  virtual wr_intf wr_vif;//(wrClk,rst);
  virtual rd_intf rd_vif;//(rdClk,rst);
  
  //---------------------------------------
  // sc_mem 
  //---------------------------------------
  bit [7:0] mem_scb [15:0];
  bit [7:0] mem_scb_r[15:0];
 
  bit [4:0] wrptr=0;
  bit [4:0] rdptr=0;

  //--------------------------------------
  //port to recive packets from monitor
  //---------------------------------------
  //uvm_analysis_imp_wrport#(wr_seq_item, scoreboard) wr_item_collected_export;
  uvm_analysis_imp_rdport#(rd_seq_item, scoreboard) rd_item_collected_export;
  uvm_analysis_imp_wrport#(wr_seq_item, scoreboard) wr_item_collected_export;
  //uvm_analysis_imp_wrport#(wr_seq_item, scoreboard) wr_item_collected_export;
  
  `uvm_component_utils(scoreboard)

  //---------------------------------------
  // new - constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  //---------------------------------------
  // build_phase - create port and initialize local memory
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_item_collected_export = new("wr_item_collected_export", this);
    rd_item_collected_export = new("rd_item_collected_export", this);
    
    if (! uvm_config_db#(virtual rd_intf )::get(this,"","rd_vif",rd_vif))
      `uvm_fatal("NO r_inf ",{"virtual interface must be set for:",get_type_name()});
    if (! uvm_config_db#(virtual wr_intf )::get(this,"","wr_vif",wr_vif))
      `uvm_fatal("NO w_inf ",{"virtual interface must be set for:",get_type_name()});
    //foreach(mem_scb[i]) mem_scb[i] = 8'hFF;
  endfunction: build_phase
  
  


  virtual function void write_wrport(wr_seq_item pkt);
    wr_pkt.push_back(pkt);

  endfunction : write_wrport

  virtual function void write_rdport(rd_seq_item rdd_pkt);
    rd_pkt.push_back(rdd_pkt);
  endfunction
 
 virtual task run_phase(uvm_phase phase);
    rd_seq_item r_pkt;
    wr_seq_item w_pkt;
  fork
    forever begin
      
     // repeat(16) begin
      wait(wr_pkt.size()>0);
      w_pkt<=wr_pkt.pop_front();
      
      if(w_pkt !=null ) begin
        @(posedge wr_vif.wrClk)
            begin
        if(w_pkt.wrEn & !wr_vif.fifoFull )
          begin 
            
            mem_scb[wrptr] <= w_pkt.din;//[0+:`DATA_WIDTH];
           // $display("dinn %0p",[0+:`DATA_WIDTH]);
             wrptr = wrptr + 1;
            end
          end
      end
    //  wrptr = wrptr + 1;
    //  end
            
/*
    	@(posedge wr_vif.wrClk or posedge wr_vif.rst) begin
          if(wr_vif.rst)begin
       		 wrptr = 0;
    		end 
    	end*/
     // `uvm_info(get_type_name(),$sformatf(" mem_scb=%0p",mem_scb),UVM_NONE)
     // end
    end
   forever begin
     
      wait(rd_pkt.size()>0);
      r_pkt<=rd_pkt.pop_front();
     //rdptr=2;
     if(r_pkt !=null) begin
    //  @(posedge rd_vif.rdClk)
      //begin
        if(r_pkt.rdEn)
          begin
          
            if(r_pkt.dout== mem_scb[rdptr]) //r_pkt.dout)
              begin
            //`uvm_info(get_type_name(),"Packed  matched",UVM_NONE)
                `uvm_info(get_type_name(),$sformatf("packet matched rd=%0p,wr=%0p ptr =%0p",r_pkt.dout,mem_scb[rdptr],rdptr),UVM_NONE)
              end
            else
              begin
                `uvm_info(get_type_name(),$sformatf("Packed not matchedrd=%0p,wr=%0p ptr=%0d",r_pkt.dout,mem_scb[rdptr],rdptr),UVM_NONE)
              end
   
           rdptr = rdptr + `RD_DATA_WIDTH_MUL;   
          end
      //end
      end
    end
  join 
 endtask : run_phase
endclass 
/*
`uvm_analysis_imp_decl(_wrport)
`uvm_analysis_imp_decl(_rdport)
class scoreboard extends uvm_scoreboard;
  

  wr_seq_item wr_pkt[$];
  rd_seq_item rd_pkt[$];
  
  virtual wr_intf wr_vif;//(wrClk,rst);
  virtual rd_intf rd_vif;//(rdClk,rst);
  
  //---------------------------------------
  // sc_mem 
  //---------------------------------------
  bit [7:0] mem_scb [15:0];
  bit [7:0] mem_scb_r[15:0];
 
  bit [4:0] wrptr=0;
  bit [4:0] rdptr=0;

  //---------------------------------------
  //port to recive packets from monitor
  //---------------------------------------
  //uvm_analysis_imp_wrport#(wr_seq_item, scoreboard) wr_item_collected_export;
  uvm_analysis_imp_rdport#(rd_seq_item, scoreboard) rd_item_collected_export;
  uvm_analysis_imp_wrport#(wr_seq_item, scoreboard) wr_item_collected_export;
  //uvm_analysis_imp_wrport#(wr_seq_item, scoreboard) wr_item_collected_export;
  
  `uvm_component_utils(scoreboard)

  //---------------------------------------
  // new - constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  //---------------------------------------
  // build_phase - create port and initialize local memory
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_item_collected_export = new("wr_item_collected_export", this);
    rd_item_collected_export = new("rd_item_collected_export", this);
    
    if (! uvm_config_db#(virtual rd_intf )::get(this,"","rd_vif",rd_vif))
      `uvm_fatal("NO r_inf ",{"virtual interface must be set for:",get_type_name()});
    if (! uvm_config_db#(virtual wr_intf )::get(this,"","wr_vif",wr_vif))
      `uvm_fatal("NO w_inf ",{"virtual interface must be set for:",get_type_name()});
    //foreach(mem_scb[i]) mem_scb[i] = 8'hFF;
  endfunction: build_phase
  


  virtual function void write_wrport(wr_seq_item pkt);
    wr_pkt.push_back(pkt);
  endfunction : write_wrport

  virtual function void write_rdport(rd_seq_item pkt);
    rd_pkt.push_back(pkt);
  endfunction
  virtual task run_phase(uvm_phase phase);
    rd_seq_item r_pkt;
    wr_seq_item w_pkt;
   
    forever begin
      wait(wr_pkt.size()>0);
      w_pkt<=wr_pkt.pop_front();

      @(posedge wr_vif.wrClk)
      begin
        mem_scb[wrptr]<=w_pkt.din;
        wrptr++;
      end
      
      
      wait(rd_pkt.size()>0);
      r_pkt<=rd_pkt.pop_front();
      @(posedge rd_vif.rdClk)
      begin
        mem_scb_r[rdptr]<=r_pkt.dout;
        rdptr++;
      end
    end
    forever begin
      rdptr=0;
      wrptr=0;
      @(posedge rd_vif.rdClk)
      begin
        if(r_pkt.rdEn)
          begin
          
            if(mem_scb_r[rdptr]==mem_scb[wrptr]) //r_pkt.dout)
              begin
            
                `uvm_info(get_type_name(),$sformatf("packet matched rd=%0p,wr=%0p",mem_scb_r,mem_scb),UVM_NONE)
          
            rdptr++;
                wrptr++;
              end
            else
              `uvm_info(get_type_name(),"Packed not matched",UVM_NONE)
          end
      end
    end
       
          
 endtask : run_phase
endclass */