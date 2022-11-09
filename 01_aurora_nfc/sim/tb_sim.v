module tb_sim(    );



     // GTX Reference Clock Interface
       reg              GTXQ2_P;
       wire              GTXQ2_N;
     // GTX Serial I/O
       wire              RXP;
       wire              RXN;

       wire             TXP;
       wire             TXN;
   // init clk and drp clk
       reg    INIT_CLK_i;
       reg    DRP_CLK_i;
       reg    int_clk_locked;
       
       reg                 hs_clock;
       reg                 pcie_reset;
       
       wire                hs_i_noc_bus_valid;
       wire                hs_i_noc_bus_ready;
       wire       [31:0]   hs_i_noc_bus_payload;
       
       reg               hs_o_noc_bus_valid;
       wire               hs_o_noc_bus_ready;
       reg               hs_o_noc_bus_payload_last;
       reg     [31:0]    hs_o_noc_bus_payload_fragment;

       wire                hs_i_noc_bus_valid_zynq;
       reg                hs_i_noc_bus_ready_zynq;
       wire       [31:0]   hs_i_noc_bus_payload_zynq;
       wire               hs_o_noc_bus_valid_zynq;
       wire               hs_o_noc_bus_ready_zynq;
       wire               hs_o_noc_bus_payload_last_zynq;
       wire     [31:0]    hs_o_noc_bus_payload_fragment_zynq;



    initial begin
        GTXQ2_P = 1'b0;
        INIT_CLK_i = 1'b0;
        DRP_CLK_i = 1'b0;
        hs_clock = 1'b0;
        pcie_reset = 1'b1;
        int_clk_locked = 1'b1;
        #1000 ;
        @(posedge hs_clock) pcie_reset = 1'b0;
    end
    assign GTXQ2_N = ~GTXQ2_P;
    
    always #4 GTXQ2_P = ~GTXQ2_P;
    always #10 INIT_CLK_i = ~INIT_CLK_i;
    always #10 DRP_CLK_i = ~DRP_CLK_i;
    always #10 hs_clock = ~hs_clock;

aurora_top   inst_2000(
     // GTX Reference Clock Interface
       .GTXQ2_P(GTXQ2_P),
       .GTXQ2_N(GTXQ2_N),
     // GTX Serial I/O
       .RXP(RXP),
       .RXN(RXN),
       .TXP(TXP),
       .TXN(TXN),
   // init clk and drp clk
       .INIT_CLK_i(INIT_CLK_i),
       .DRP_CLK_i(DRP_CLK_i),
       .int_clk_locked(int_clk_locked),
       
       .hs_clock(hs_clock),
       .pcie_reset(pcie_reset),  
       .hs_i_noc_bus_valid(),            // output             
       .hs_i_noc_bus_ready(),            // input 
       .hs_i_noc_bus_payload(),          // output
                                             
       .hs_o_noc_bus_valid(hs_o_noc_bus_valid),            // input 
       .hs_o_noc_bus_ready(hs_o_noc_bus_ready),            // output
       .hs_o_noc_bus_payload_last(hs_o_noc_bus_payload_last),     // input 
       .hs_o_noc_bus_payload_fragment(hs_o_noc_bus_payload_fragment)  // input 

    );
    
aurora_top   inst_zynq(
     // GTX Reference Clock Interface
       .GTXQ2_P(GTXQ2_P),
       .GTXQ2_N(GTXQ2_P),
     // GTX Serial I/O
       .RXP(TXP),
       .RXN(TXN),
       .TXP(RXP),
       .TXN(RXN),
   // init clk and drp clk
       .INIT_CLK_i(INIT_CLK_i),
       .DRP_CLK_i(DRP_CLK_i),
       .int_clk_locked(int_clk_locked),
       
       .hs_clock(hs_clock),
       .pcie_reset(pcie_reset),
       .hs_i_noc_bus_valid(),              // output      
       .hs_i_noc_bus_ready(hs_i_noc_bus_ready_zynq),              // input        
       .hs_i_noc_bus_payload(),            // output       
                                                      
       .hs_o_noc_bus_valid(),              // input       
       .hs_o_noc_bus_ready(),              // output       
       .hs_o_noc_bus_payload_last(),       // input        
       .hs_o_noc_bus_payload_fragment()    // input        
   );

    initial begin
        hs_o_noc_bus_valid = 'b0;
        hs_o_noc_bus_payload_fragment = 'h0;
        hs_o_noc_bus_payload_last = 'b0;
        wait(inst_2000.channel_up && inst_zynq.channel_up)  ;
          $display("[INFO]%t:  channel_up is high....",$time);
        while(1) begin
             $display("[INFO] %t: it is in while process ...",$time);
            if(hs_o_noc_bus_ready) begin
                            $display("[INFO] %t:it is in sending data process ...",$time);
              @(posedge hs_clock);
              hs_o_noc_bus_valid <= 1'b1;
//              hs_o_noc_bus_payload_last <= 1'b1;
              hs_o_noc_bus_payload_fragment <= hs_o_noc_bus_payload_fragment + 1'b1;
              //hs_o_noc_bus_payload_fragment <= 'h5a5a5a5a;
             end
             else
               $display("[INFO] %t:  checke whether the fifo in zynq side is full;whether the function of nfc is ok?",$time);
        end
        
    end

  reg [7:0] counter;
   initial begin
    //tb_sim/inst_zynq/nfc_tvalid_i
    hs_i_noc_bus_ready_zynq = 1'b0;
    counter = 0;
    wait(tb_sim.inst_zynq.nfc_tvalid_i);
    forever begin
        @(posedge hs_clock);
        counter <= counter +1;
        hs_i_noc_bus_ready_zynq = ~counter[7];
    end
   end
endmodule
        