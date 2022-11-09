`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2022 08:43:43 AM
// Design Name: 
// Module Name: nfc_gen
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


module nfc_gen(
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low

	input         fifo_almost_full,

	output        valid,
	output [15:0] data,
	input         ready
	
);

	reg        valid_r;
	reg [15:0] data;
    wire  fifo_almost_full_pos,fifo_almost_full_neg;
    reg   fifo_almost_full_d1,fifo_almost_full_d2;

always @(posedge clk) begin 
	fifo_almost_full_d1<= fifo_almost_full;
    fifo_almost_full_d2<= fifo_almost_full_d1;
end

assign fifo_almost_full_pos = fifo_almost_full_d1 && (~fifo_almost_full_d2);
assign fifo_almost_full_neg = (~fifo_almost_full_d1) && fifo_almost_full_d2;

localparam  IDLE        = 0;
localparam  S_XOFF       = 1;
localparam  S_WAIT_XON = 2;
localparam  S_XON      = 3;

reg [2:0]  sate_c,sate_n;

always @(posedge clk or negedge rst_n) begin : proc_sates
	if(~rst_n) begin
		sate_c <= IDLE;
	end else begin
		sate_c <= sate_n;
	end
end

always @(*) begin 
	if(~rst_n)
		sate_n = IDLE;
	else
		case(sate_c) 
			IDLE:begin
				if(fifo_almost_full_pos) 
					sate_n = S_XOFF;
				else
					sate_n = IDLE;
			end
			S_XOFF:begin
				if(valid_r && ready) 
					sate_n = S_WAIT_XON;
				else
					sate_n = S_XOFF;
			end

			S_WAIT_XON:begin
				if(fifo_almost_full_neg) 
					sate_n = S_XON;
				else
					sate_n = S_WAIT_XON;
			end
			S_XON:begin
				if(valid_r && ready) 
					sate_n = IDLE;
				else
					sate_n = S_XON;
			end
			default:sate_n = IDLE;
		endcase
end


always @(posedge clk or negedge rst_n) begin : proc_data
	if(~rst_n) begin
		data  <= 'h0;
		valid_r <=   0;
	end else if(sate_c == S_XOFF)begin
		data  <= 'h0100;
		valid_r <=   1;
	end else if(sate_c == S_XON)begin
		data  <= 'h0000;
		valid_r <=   1;
	end else begin
		data  <= 'h0000;
		valid_r <=   0;
	end
end

assign valid= valid_r && ((sate_c == S_XOFF) || (sate_c == S_XON));

endmodule : nfc_gen