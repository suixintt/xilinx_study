`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2022 07:13:02 PM
// Design Name: 
// Module Name: aurora_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module aurora_top(

     // GTX Reference Clock Interface
       input              GTXQ2_P,
       input              GTXQ2_N,
     // GTX Serial I/O
       input              RXP,
       input              RXN,

       output             TXP,
       output             TXN,
   // init clk and drp clk
       input    INIT_CLK_i,
       input    DRP_CLK_i,
       input    int_clk_locked,
       
       input               hs_clock,
       input               pcie_reset,
       output               hs_i_noc_bus_valid,
       input                hs_i_noc_bus_ready,
       output      [31:0]   hs_i_noc_bus_payload,
       
       input               hs_o_noc_bus_valid,
       output              hs_o_noc_bus_ready,
       input               hs_o_noc_bus_payload_last,
       input     [31:0]    hs_o_noc_bus_payload_fragment

    );
    


  
    wire channel_up;
    wire user_clk;
    
    wire  pma_init;
    wire  reset_pb;
    
      //TX Interface
       wire      [0:63]     tx_tdata_i; 
       wire                 tx_tvalid_i;
       wire                 tx_tready_i;

     //RX Interface
       wire      [0:63]      rx_tdata_i;  
       wire                 rx_tvalid_i;

    // Native Flow Control Interface
       wire                 nfc_tvalid_i;
       wire      [0:15]     nfc_tdata_i;         
       wire                 nfc_tready_i;   
       wire rx_almost_full;
        wire noc_rev_ready;
       assign rx_almost_full = ~noc_rev_ready;
    wire   system_reset_i;
    //the pma_int logic
     reg [26:0] pma_counter;
     always@(posedge INIT_CLK_i or posedge pcie_reset) 
        if(pcie_reset)
          pma_counter <= 'h0;
        else if(~(&pma_counter))
          pma_counter <= pma_counter + 1'b1;
        else 
           pma_counter <= pma_counter;
          
     assign pma_init = pcie_reset |(~(&pma_counter)); 
   
    
  //the cdc between the noc domain and the aurora user clk 
  //the cdc fifo is needed to update(almosetfull)
  HyperSiliconStreamFifoCC noc_to_zynq(
 .io_push_valid              (hs_o_noc_bus_valid),    
 .io_push_ready              (hs_o_noc_bus_ready),    
 .io_push_payload            ({hs_o_noc_bus_payload_last,hs_o_noc_bus_payload_fragment}),  
 
 .io_pop_valid               (tx_tvalid_i),     
 .io_pop_ready               (tx_tready_i),     
 .io_pop_payload             (tx_tdata_i),   
 
 .io_pushOccupancy           (), //nc
 .io_popOccupancy            (), //nc
 
 .push_clk                   (hs_clock),         
 .push_reset                 (system_reset_i),// pay attention
 .pop_clk                    (user_clk)           
 );  
    

 HyperSiliconStreamFifoCC noc_from_zynq(
 .io_push_valid              (rx_tvalid_i),    
 .io_push_ready              (noc_rev_ready),    //need an almostfule signal;this signal maybe 
 .io_push_payload            (rx_tdata_i),  
 
 .io_pop_valid               (hs_i_noc_bus_valid),     
 .io_pop_ready               (hs_i_noc_bus_ready),     
 .io_pop_payload             (hs_i_noc_bus_payload),   
 
 .io_pushOccupancy           (),//nc
 .io_popOccupancy            (),//nc  
 
 .push_clk                   (user_clk),         
 .push_reset                 (system_reset_i), // pay attention
 .pop_clk                    (hs_clock)           
 );     
    
    
nfc_gen  aurora64b66b_nfc(
	.clk(user_clk),    // Clock
	.rst_n(~system_reset_i),  // Asynchronous reset active low
	.fifo_almost_full(rx_almost_full),
	.valid(nfc_tvalid_i),
	.data(nfc_tdata_i),
	.ready(nfc_tready_i)
);
    
    
    
    
  // aurora block  
 aurora_64b66b_0  aurora_64b66b_0_block_i
     (
        // TX AXI4-S Interface
         .s_axi_tx_tdata(tx_tdata_i),
         .s_axi_tx_tvalid(tx_tvalid_i),
         .s_axi_tx_tready(tx_tready_i),
         
        // RX AXI4-S Interface
         .m_axi_rx_tdata(rx_tdata_i),
         .m_axi_rx_tvalid(rx_tvalid_i),
         
        // Native Flow Control Interface
         .s_axi_nfc_tvalid(nfc_tvalid_i),
         .s_axi_nfc_tdata(nfc_tdata_i),
         .s_axi_nfc_tready(nfc_tready_i),

        // GT Serial I/O
         .rxp(RXP),
         .rxn(RXN),
         .txp(TXP),
         .txn(TXN),

        //GT Reference Clock Interface
        .gt_refclk1_p (GTXQ2_P),
        .gt_refclk1_n (GTXQ2_N),
         
         
         
         .reset_pb(1'b0),
         .pma_init(pma_init),
         
         .init_clk            (INIT_CLK_i),
         .drp_clk_in            (DRP_CLK_i),// (drp_clk_i),
         
         .sys_reset_out          (system_reset_i),
         .link_reset_out         (),        

         .user_clk_out          (user_clk),
         .sync_clk_out          (),                  
         .mmcm_not_locked_out   (),
         
         .tx_out_clk            (),
         .gt_pll_lock           (),
         .hard_err              (),
         .soft_err              (),
         .channel_up            (channel_up),
         .lane_up               (),

         .gt_rxcdrovrden_in(1'b0),
         .power_down       (1'b0),
         .loopback         (3'b000),
     // ---------- AXI4-Lite input signals ---------------
         .s_axi_awaddr     (32'h0),
         .s_axi_awvalid    (1'b0),
         .s_axi_awready    (),
         .s_axi_wdata      (16'h0),
         .s_axi_wstrb      (4'h0),
         .s_axi_wvalid     (1'b0),
         .s_axi_wready     (),
         .s_axi_bvalid     (),
         .s_axi_bresp      (),
         .s_axi_bready     (1'b0),
         .s_axi_araddr     (32'h0),
         .s_axi_arvalid    (1'b0),
         .s_axi_arready    (),
         .s_axi_rdata(),
         .s_axi_rvalid(),
         .s_axi_rresp(),
         .s_axi_rready(1'b0),


         .gt_qpllclk_quad3_out(),        // output wire gt_qpllclk_quad3_out
         .gt_qpllrefclk_quad3_out(),  // output wire gt_qpllrefclk_quad3_out
         .gt_reset_out(),                        // output wire gt_reset_out
         .gt_refclk1_out()                    // output wire gt_refclk1_out
     );
    
    ila_0 noc_debug_inst (
	.clk(hs_clock), // input wire clk

	.probe0(hs_i_noc_bus_valid), // input wire [0:0]  probe0  
	.probe1(hs_i_noc_bus_ready), // input wire [0:0]  probe1 
	.probe2(hs_i_noc_bus_payload), // input wire [31:0]  probe2 
	.probe3(hs_o_noc_bus_valid), // input wire [0:0]  probe3 
	.probe4(hs_o_noc_bus_ready), // input wire [0:0]  probe4 
	.probe5(hs_o_noc_bus_payload_last), // input wire [0:0]  probe5 
	.probe6(hs_o_noc_bus_payload_fragment), // input wire [31:0]  probe6 
	.probe7(channel_up) // input wire [0:0]  probe7
);

endmodule
