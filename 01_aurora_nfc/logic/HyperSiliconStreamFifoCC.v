// Generator : SpinalHDL v1.6.4    git head : 598c18959149eb18e5eee5b0aa3eef01ecaa41a1
// Component : HyperSiliconStreamFifoCC
// Git hash  : 3117179f44a4d6cd9c9c26b3902b0edc1a27d76c

`timescale 1ns/1ps 

module HyperSiliconStreamFifoCC (
  input               io_push_valid,
  output              io_push_ready,
  input      [63:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [63:0]   io_pop_payload,
  output     [12:0]   io_pushOccupancy,
  output     [12:0]   io_popOccupancy,
  input               push_clk,
  input               push_reset,
  input               pop_clk
);

  reg        [63:0]   _zz_ram_port1;
  wire       [12:0]   popToPushGray_buffercc_io_dataOut;
  wire                bufferCC_io_dataOut;
  wire       [12:0]   pushToPopGray_buffercc_io_dataOut;
  wire       [12:0]   _zz_pushCC_pushPtrGray;
  wire       [11:0]   _zz_ram_port;
  wire       [0:0]    _zz_io_pushOccupancy_12;
  wire       [2:0]    _zz_io_pushOccupancy_13;
  wire       [12:0]   _zz_popCC_popPtrGray;
  wire       [11:0]   _zz_ram_port_1;
  wire                _zz_ram_port_2;
  wire       [11:0]   _zz_io_pop_payload_1;
  wire                _zz_io_pop_payload_2;
  wire       [0:0]    _zz_io_popOccupancy_12;
  wire       [2:0]    _zz_io_popOccupancy_13;
  reg                 _zz_1;
  wire       [12:0]   popToPushGray;
  wire       [12:0]   pushToPopGray;
  reg        [12:0]   pushCC_pushPtr;
  wire       [12:0]   pushCC_pushPtrPlus;
  wire                io_push_fire;
  reg        [12:0]   pushCC_pushPtrGray;
  wire       [12:0]   pushCC_popPtrGray;
  wire                pushCC_full;
  reg                pushCC_almost_full;
  wire                io_push_fire_1;
  wire                _zz_io_pushOccupancy;
  wire                _zz_io_pushOccupancy_1;
  wire                _zz_io_pushOccupancy_2;
  wire                _zz_io_pushOccupancy_3;
  wire                _zz_io_pushOccupancy_4;
  wire                _zz_io_pushOccupancy_5;
  wire                _zz_io_pushOccupancy_6;
  wire                _zz_io_pushOccupancy_7;
  wire                _zz_io_pushOccupancy_8;
  wire                _zz_io_pushOccupancy_9;
  wire                _zz_io_pushOccupancy_10;
  wire                _zz_io_pushOccupancy_11;
  wire                push_reset_syncronized;
  reg        [12:0]   popCC_popPtr;
  wire       [12:0]   popCC_popPtrPlus;
  wire                io_pop_fire;
  reg        [12:0]   popCC_popPtrGray;
  wire       [12:0]   popCC_pushPtrGray;
  wire                popCC_empty;
  wire                io_pop_fire_1;
  wire       [12:0]   _zz_io_pop_payload;
  wire                io_pop_fire_2;
  wire                _zz_io_popOccupancy;
  wire                _zz_io_popOccupancy_1;
  wire                _zz_io_popOccupancy_2;
  wire                _zz_io_popOccupancy_3;
  wire                _zz_io_popOccupancy_4;
  wire                _zz_io_popOccupancy_5;
  wire                _zz_io_popOccupancy_6;
  wire                _zz_io_popOccupancy_7;
  wire                _zz_io_popOccupancy_8;
  wire                _zz_io_popOccupancy_9;
  wire                _zz_io_popOccupancy_10;
  wire                _zz_io_popOccupancy_11;
  reg [63:0] ram [0:4095];

  assign _zz_pushCC_pushPtrGray = (pushCC_pushPtrPlus >>> 1'b1);
  assign _zz_ram_port = pushCC_pushPtr[11:0];
  assign _zz_popCC_popPtrGray = (popCC_popPtrPlus >>> 1'b1);
  assign _zz_io_pop_payload_1 = _zz_io_pop_payload[11:0];
  assign _zz_io_pop_payload_2 = 1'b1;
  assign _zz_io_pushOccupancy_12 = _zz_io_pushOccupancy_2;
  assign _zz_io_pushOccupancy_13 = {_zz_io_pushOccupancy_1,{_zz_io_pushOccupancy,(pushCC_popPtrGray[0] ^ _zz_io_pushOccupancy)}};
  assign _zz_io_popOccupancy_12 = _zz_io_popOccupancy_2;
  assign _zz_io_popOccupancy_13 = {_zz_io_popOccupancy_1,{_zz_io_popOccupancy,(popCC_pushPtrGray[0] ^ _zz_io_popOccupancy)}};
  always @(posedge push_clk) begin
    if(_zz_1) begin
      ram[_zz_ram_port] <= io_push_payload;
    end
  end

  always @(posedge pop_clk) begin
    if(_zz_io_pop_payload_2) begin
      _zz_ram_port1 <= ram[_zz_io_pop_payload_1];
    end
  end

  HyperSiliconBufferCC popToPushGray_buffercc (
    .io_dataIn     (popToPushGray[12:0]                      ), //i
    .io_dataOut    (popToPushGray_buffercc_io_dataOut[12:0]  ), //o
    .push_clk      (push_clk                                 ), //i
    .push_reset    (push_reset                               )  //i
  );
  HyperSiliconBufferCC_1 bufferCC (
    .io_dataIn     (1'b0                 ), //i
    .io_dataOut    (bufferCC_io_dataOut  ), //o
    .pop_clk       (pop_clk              ), //i
    .push_reset    (push_reset           )  //i
  );
  HyperSiliconBufferCC_2 pushToPopGray_buffercc (
    .io_dataIn                 (pushToPopGray[12:0]                      ), //i
    .io_dataOut                (pushToPopGray_buffercc_io_dataOut[12:0]  ), //o
    .pop_clk                   (pop_clk                                  ), //i
    .push_reset_syncronized    (push_reset_syncronized                   )  //i
  );
  always @(*) begin
    _zz_1 = 1'b0;
    if(io_push_fire_1) begin
      _zz_1 = 1'b1;
    end
  end
  always @(*) begin
    pushCC_almost_full = 1'b0;
    if(io_pushOccupancy >= 3000)begin
//    if(io_pushOccupancy >= 4064)begin
      pushCC_almost_full = 1'b1;
    end
  end
  assign pushCC_pushPtrPlus = (pushCC_pushPtr + 13'h0001);
  assign io_push_fire = (io_push_valid && io_push_ready);
  assign pushCC_popPtrGray = popToPushGray_buffercc_io_dataOut;
  assign pushCC_full = ((pushCC_pushPtrGray[12 : 11] == (~ pushCC_popPtrGray[12 : 11])) && (pushCC_pushPtrGray[10 : 0] == pushCC_popPtrGray[10 : 0]));
  assign io_push_ready = (! pushCC_almost_full);
  assign io_push_fire_1 = (io_push_valid && io_push_ready);
  assign _zz_io_pushOccupancy = (pushCC_popPtrGray[1] ^ _zz_io_pushOccupancy_1);
  assign _zz_io_pushOccupancy_1 = (pushCC_popPtrGray[2] ^ _zz_io_pushOccupancy_2);
  assign _zz_io_pushOccupancy_2 = (pushCC_popPtrGray[3] ^ _zz_io_pushOccupancy_3);
  assign _zz_io_pushOccupancy_3 = (pushCC_popPtrGray[4] ^ _zz_io_pushOccupancy_4);
  assign _zz_io_pushOccupancy_4 = (pushCC_popPtrGray[5] ^ _zz_io_pushOccupancy_5);
  assign _zz_io_pushOccupancy_5 = (pushCC_popPtrGray[6] ^ _zz_io_pushOccupancy_6);
  assign _zz_io_pushOccupancy_6 = (pushCC_popPtrGray[7] ^ _zz_io_pushOccupancy_7);
  assign _zz_io_pushOccupancy_7 = (pushCC_popPtrGray[8] ^ _zz_io_pushOccupancy_8);
  assign _zz_io_pushOccupancy_8 = (pushCC_popPtrGray[9] ^ _zz_io_pushOccupancy_9);
  assign _zz_io_pushOccupancy_9 = (pushCC_popPtrGray[10] ^ _zz_io_pushOccupancy_10);
  assign _zz_io_pushOccupancy_10 = (pushCC_popPtrGray[11] ^ _zz_io_pushOccupancy_11);
  assign _zz_io_pushOccupancy_11 = pushCC_popPtrGray[12];
  assign io_pushOccupancy = (pushCC_pushPtr - {_zz_io_pushOccupancy_11,{_zz_io_pushOccupancy_10,{_zz_io_pushOccupancy_9,{_zz_io_pushOccupancy_8,{_zz_io_pushOccupancy_7,{_zz_io_pushOccupancy_6,{_zz_io_pushOccupancy_5,{_zz_io_pushOccupancy_4,{_zz_io_pushOccupancy_3,{_zz_io_pushOccupancy_12,_zz_io_pushOccupancy_13}}}}}}}}}});
  assign push_reset_syncronized = bufferCC_io_dataOut;
  assign popCC_popPtrPlus = (popCC_popPtr + 13'h0001);
  assign io_pop_fire = (io_pop_valid && io_pop_ready);
  assign popCC_pushPtrGray = pushToPopGray_buffercc_io_dataOut;
  assign popCC_empty = (popCC_popPtrGray == popCC_pushPtrGray);
  assign io_pop_valid = (! popCC_empty);
  assign io_pop_fire_1 = (io_pop_valid && io_pop_ready);
  assign _zz_io_pop_payload = (io_pop_fire_1 ? popCC_popPtrPlus : popCC_popPtr);
  assign io_pop_payload = _zz_ram_port1;
  assign io_pop_fire_2 = (io_pop_valid && io_pop_ready);
  assign _zz_io_popOccupancy = (popCC_pushPtrGray[1] ^ _zz_io_popOccupancy_1);
  assign _zz_io_popOccupancy_1 = (popCC_pushPtrGray[2] ^ _zz_io_popOccupancy_2);
  assign _zz_io_popOccupancy_2 = (popCC_pushPtrGray[3] ^ _zz_io_popOccupancy_3);
  assign _zz_io_popOccupancy_3 = (popCC_pushPtrGray[4] ^ _zz_io_popOccupancy_4);
  assign _zz_io_popOccupancy_4 = (popCC_pushPtrGray[5] ^ _zz_io_popOccupancy_5);
  assign _zz_io_popOccupancy_5 = (popCC_pushPtrGray[6] ^ _zz_io_popOccupancy_6);
  assign _zz_io_popOccupancy_6 = (popCC_pushPtrGray[7] ^ _zz_io_popOccupancy_7);
  assign _zz_io_popOccupancy_7 = (popCC_pushPtrGray[8] ^ _zz_io_popOccupancy_8);
  assign _zz_io_popOccupancy_8 = (popCC_pushPtrGray[9] ^ _zz_io_popOccupancy_9);
  assign _zz_io_popOccupancy_9 = (popCC_pushPtrGray[10] ^ _zz_io_popOccupancy_10);
  assign _zz_io_popOccupancy_10 = (popCC_pushPtrGray[11] ^ _zz_io_popOccupancy_11);
  assign _zz_io_popOccupancy_11 = popCC_pushPtrGray[12];
  assign io_popOccupancy = ({_zz_io_popOccupancy_11,{_zz_io_popOccupancy_10,{_zz_io_popOccupancy_9,{_zz_io_popOccupancy_8,{_zz_io_popOccupancy_7,{_zz_io_popOccupancy_6,{_zz_io_popOccupancy_5,{_zz_io_popOccupancy_4,{_zz_io_popOccupancy_3,{_zz_io_popOccupancy_12,_zz_io_popOccupancy_13}}}}}}}}}} - popCC_popPtr);
  assign pushToPopGray = pushCC_pushPtrGray;
  assign popToPushGray = popCC_popPtrGray;
  always @(posedge push_clk or posedge push_reset) begin
    if(push_reset) begin
      pushCC_pushPtr <= 13'h0;
      pushCC_pushPtrGray <= 13'h0;
    end else begin
      if(io_push_fire) begin
        pushCC_pushPtrGray <= (_zz_pushCC_pushPtrGray ^ pushCC_pushPtrPlus);
      end
      if(io_push_fire_1) begin
        pushCC_pushPtr <= pushCC_pushPtrPlus;
      end
    end
  end

  always @(posedge pop_clk or posedge push_reset_syncronized) begin
    if(push_reset_syncronized) begin
      popCC_popPtr <= 13'h0;
      popCC_popPtrGray <= 13'h0;
    end else begin
      if(io_pop_fire) begin
        popCC_popPtrGray <= (_zz_popCC_popPtrGray ^ popCC_popPtrPlus);
      end
      if(io_pop_fire_2) begin
        popCC_popPtr <= popCC_popPtrPlus;
      end
    end
  end


endmodule

module HyperSiliconBufferCC_2 (
  input      [12:0]   io_dataIn,
  output     [12:0]   io_dataOut,
  input               pop_clk,
  input               push_reset_syncronized
);

  (* async_reg = "true" *) reg        [12:0]   buffers_0;
  (* async_reg = "true" *) reg        [12:0]   buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge pop_clk or posedge push_reset_syncronized) begin
    if(push_reset_syncronized) begin
      buffers_0 <= 13'h0;
      buffers_1 <= 13'h0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module HyperSiliconBufferCC_1 (
  input               io_dataIn,
  output              io_dataOut,
  input               pop_clk,
  input               push_reset
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge pop_clk or posedge push_reset) begin
    if(push_reset) begin
      buffers_0 <= 1'b1;
      buffers_1 <= 1'b1;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module HyperSiliconBufferCC (
  input      [12:0]   io_dataIn,
  output     [12:0]   io_dataOut,
  input               push_clk,
  input               push_reset
);

  (* async_reg = "true" *) reg        [12:0]   buffers_0;
  (* async_reg = "true" *) reg        [12:0]   buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge push_clk or posedge push_reset) begin
    if(push_reset) begin
      buffers_0 <= 13'h0;
      buffers_1 <= 13'h0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule
