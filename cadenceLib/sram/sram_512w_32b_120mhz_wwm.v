// FE Release Version: 2.4.24 
//
//       CONFIDENTIAL AND PROPRIETARY SOFTWARE OF ARM PHYSICAL IP, INC.
//      
//       Copyright (c) 1993 - 2022 ARM Physical IP, Inc.  All Rights Reserved.
//      
//       Use of this Software is subject to the terms and conditions of the
//       applicable license agreement with ARM Physical IP, Inc.
//       In addition, this Software is protected by patents, copyright law 
//       and international treaties.
//      
//       The copyright notice(s) in this Software does not indicate actual or
//       intended publication of this Software.
//
//      Verilog model for Synchronous Single-Port Ram
//
//      Instance Name:              sram_512w_32b_120mhz_wwm
//      Words:                      512
//      Bits:                       32
//      Mux:                        16
//      Drive:                      6
//      Write Mask:                 On
//      Extra Margin Adjustment:    On
//      Accelerated Retention Test: Off
//      Redundant Rows:             0
//      Redundant Columns:          0
//      Test Muxes                  On
//
//      Creation Date:  Sat Dec 10 13:28:59 2022
//      Version: 	r0p0-00eac0
//
//      Modeling Assumptions: This model supports full gate level simulation
//          including proper x-handling and timing check behavior.  Unit
//          delay timing is included in the model. Back-annotation of SDF
//          (v2.1) is supported.  SDF can be created utilyzing the delay
//          calculation views provided with this generator and supported
//          delay calculators.  All buses are modeled [MSB:LSB].  All 
//          ports are padded with Verilog primitives.
//
//      Modeling Limitations: None.
//
//      Known Bugs: None.
//
//      Known Work Arounds: N/A
//
`ifdef ARM_UD_MODEL

`timescale 1 ns/1 ps

`ifdef ARM_UD_DP
`else
`define ARM_UD_DP #0.001
`endif
`ifdef ARM_UD_CP
`else
`define ARM_UD_CP
`endif
`ifdef ARM_UD_SEQ
`else
`define ARM_UD_SEQ #0.01
`endif

`celldefine
`ifdef POWER_PINS
module sram_512w_32b_120mhz_wwm (CENY, WENY, AY, DY, GWENY, Q, QI, PENY, CLK, CEN,
    WEN, A, D, EMA, TEN, BEN, TCEN, TWEN, TA, TD, TQ, GWEN, TGWEN, RETN, PEN, TPEN,
    VSSE, VDDPE, VDDCE);
`else
module sram_512w_32b_120mhz_wwm (CENY, WENY, AY, DY, GWENY, Q, QI, PENY, CLK, CEN,
    WEN, A, D, EMA, TEN, BEN, TCEN, TWEN, TA, TD, TQ, GWEN, TGWEN, RETN, PEN, TPEN);
`endif

  parameter BITS = 32;
  parameter WORDS = 512;
  parameter MUX = 16;
  parameter MEM_WIDTH = 512; // redun block size 8, 256 on left, 256 on right
  parameter MEM_HEIGHT = 32;
  parameter WP_SIZE = 8 ;
  parameter UPM_WIDTH = 3;

  output  CENY;
  output [3:0] WENY;
  output [8:0] AY;
  output [31:0] DY;
  output  GWENY;
  output [31:0] Q;
  output [31:0] QI;
  output  PENY;
  input  CLK;
  input  CEN;
  input [3:0] WEN;
  input [8:0] A;
  input [31:0] D;
  input [2:0] EMA;
  input  TEN;
  input  BEN;
  input  TCEN;
  input [3:0] TWEN;
  input [8:0] TA;
  input [31:0] TD;
  input [31:0] TQ;
  input  GWEN;
  input  TGWEN;
  input  RETN;
  input  PEN;
  input  TPEN;
`ifdef POWER_PINS
  inout VSSE;
  inout VDDPE;
  inout VDDCE;
`endif

  integer row_address;
  integer mux_address;
  reg [511:0] mem [0:31];
  reg [511:0] row;
  reg LAST_CLK;
  reg [511:0] data_out;
  reg [511:0] row_mask;
  reg [511:0] new_data;
  reg [31:0] Q_int;
  reg [31:0] writeEnable;
  reg PEN_prev;
  reg [31:0] Q_stage1;
  reg clk0_int;
  reg CREN_legal;
  initial CREN_legal = 1'b1;

  wire  CENY_;
  wire [3:0] WENY_;
  wire [8:0] AY_;
  wire [31:0] DY_;
  wire  GWENY_;
  wire [31:0] Q_;
  wire [31:0] QI_;
  wire  PENY_;
 wire  CLK_;
  wire  CEN_;
  reg  CEN_int;
  wire [3:0] WEN_;
  reg [3:0] WEN_int;
  wire [8:0] A_;
  reg [8:0] A_int;
  wire [31:0] D_;
  reg [31:0] D_int;
  wire [2:0] EMA_;
  reg [2:0] EMA_int;
  wire  TEN_;
  reg  TEN_int;
  wire  BEN_;
  reg  BEN_int;
  wire  TCEN_;
  reg  TCEN_int;
  wire [3:0] TWEN_;
  reg [3:0] TWEN_int;
  wire [8:0] TA_;
  reg [8:0] TA_int;
  wire [31:0] TD_;
  reg [31:0] TD_int;
  wire [31:0] TQ_;
  reg [31:0] TQ_int;
  wire  GWEN_;
  reg  GWEN_int;
  wire  TGWEN_;
  reg  TGWEN_int;
  wire  RETN_;
  reg  RETN_int;
  wire  PEN_;
  reg  PEN_int;
  wire  TPEN_;
  reg  TPEN_int;

  assign CENY = CENY_; 
  assign WENY[0] = WENY_[0]; 
  assign WENY[1] = WENY_[1]; 
  assign WENY[2] = WENY_[2]; 
  assign WENY[3] = WENY_[3]; 
  assign AY[0] = AY_[0]; 
  assign AY[1] = AY_[1]; 
  assign AY[2] = AY_[2]; 
  assign AY[3] = AY_[3]; 
  assign AY[4] = AY_[4]; 
  assign AY[5] = AY_[5]; 
  assign AY[6] = AY_[6]; 
  assign AY[7] = AY_[7]; 
  assign AY[8] = AY_[8]; 
  assign DY[0] = DY_[0]; 
  assign DY[1] = DY_[1]; 
  assign DY[2] = DY_[2]; 
  assign DY[3] = DY_[3]; 
  assign DY[4] = DY_[4]; 
  assign DY[5] = DY_[5]; 
  assign DY[6] = DY_[6]; 
  assign DY[7] = DY_[7]; 
  assign DY[8] = DY_[8]; 
  assign DY[9] = DY_[9]; 
  assign DY[10] = DY_[10]; 
  assign DY[11] = DY_[11]; 
  assign DY[12] = DY_[12]; 
  assign DY[13] = DY_[13]; 
  assign DY[14] = DY_[14]; 
  assign DY[15] = DY_[15]; 
  assign DY[16] = DY_[16]; 
  assign DY[17] = DY_[17]; 
  assign DY[18] = DY_[18]; 
  assign DY[19] = DY_[19]; 
  assign DY[20] = DY_[20]; 
  assign DY[21] = DY_[21]; 
  assign DY[22] = DY_[22]; 
  assign DY[23] = DY_[23]; 
  assign DY[24] = DY_[24]; 
  assign DY[25] = DY_[25]; 
  assign DY[26] = DY_[26]; 
  assign DY[27] = DY_[27]; 
  assign DY[28] = DY_[28]; 
  assign DY[29] = DY_[29]; 
  assign DY[30] = DY_[30]; 
  assign DY[31] = DY_[31]; 
  assign GWENY = GWENY_; 
  assign Q[0] = Q_[0]; 
  assign Q[1] = Q_[1]; 
  assign Q[2] = Q_[2]; 
  assign Q[3] = Q_[3]; 
  assign Q[4] = Q_[4]; 
  assign Q[5] = Q_[5]; 
  assign Q[6] = Q_[6]; 
  assign Q[7] = Q_[7]; 
  assign Q[8] = Q_[8]; 
  assign Q[9] = Q_[9]; 
  assign Q[10] = Q_[10]; 
  assign Q[11] = Q_[11]; 
  assign Q[12] = Q_[12]; 
  assign Q[13] = Q_[13]; 
  assign Q[14] = Q_[14]; 
  assign Q[15] = Q_[15]; 
  assign Q[16] = Q_[16]; 
  assign Q[17] = Q_[17]; 
  assign Q[18] = Q_[18]; 
  assign Q[19] = Q_[19]; 
  assign Q[20] = Q_[20]; 
  assign Q[21] = Q_[21]; 
  assign Q[22] = Q_[22]; 
  assign Q[23] = Q_[23]; 
  assign Q[24] = Q_[24]; 
  assign Q[25] = Q_[25]; 
  assign Q[26] = Q_[26]; 
  assign Q[27] = Q_[27]; 
  assign Q[28] = Q_[28]; 
  assign Q[29] = Q_[29]; 
  assign Q[30] = Q_[30]; 
  assign Q[31] = Q_[31]; 
  assign QI[0] = QI_[0]; 
  assign QI[1] = QI_[1]; 
  assign QI[2] = QI_[2]; 
  assign QI[3] = QI_[3]; 
  assign QI[4] = QI_[4]; 
  assign QI[5] = QI_[5]; 
  assign QI[6] = QI_[6]; 
  assign QI[7] = QI_[7]; 
  assign QI[8] = QI_[8]; 
  assign QI[9] = QI_[9]; 
  assign QI[10] = QI_[10]; 
  assign QI[11] = QI_[11]; 
  assign QI[12] = QI_[12]; 
  assign QI[13] = QI_[13]; 
  assign QI[14] = QI_[14]; 
  assign QI[15] = QI_[15]; 
  assign QI[16] = QI_[16]; 
  assign QI[17] = QI_[17]; 
  assign QI[18] = QI_[18]; 
  assign QI[19] = QI_[19]; 
  assign QI[20] = QI_[20]; 
  assign QI[21] = QI_[21]; 
  assign QI[22] = QI_[22]; 
  assign QI[23] = QI_[23]; 
  assign QI[24] = QI_[24]; 
  assign QI[25] = QI_[25]; 
  assign QI[26] = QI_[26]; 
  assign QI[27] = QI_[27]; 
  assign QI[28] = QI_[28]; 
  assign QI[29] = QI_[29]; 
  assign QI[30] = QI_[30]; 
  assign QI[31] = QI_[31]; 
  assign PENY = PENY_; 
  assign CLK_ = CLK;
  assign CEN_ = CEN;
  assign WEN_[0] = WEN[0];
  assign WEN_[1] = WEN[1];
  assign WEN_[2] = WEN[2];
  assign WEN_[3] = WEN[3];
  assign A_[0] = A[0];
  assign A_[1] = A[1];
  assign A_[2] = A[2];
  assign A_[3] = A[3];
  assign A_[4] = A[4];
  assign A_[5] = A[5];
  assign A_[6] = A[6];
  assign A_[7] = A[7];
  assign A_[8] = A[8];
  assign D_[0] = D[0];
  assign D_[1] = D[1];
  assign D_[2] = D[2];
  assign D_[3] = D[3];
  assign D_[4] = D[4];
  assign D_[5] = D[5];
  assign D_[6] = D[6];
  assign D_[7] = D[7];
  assign D_[8] = D[8];
  assign D_[9] = D[9];
  assign D_[10] = D[10];
  assign D_[11] = D[11];
  assign D_[12] = D[12];
  assign D_[13] = D[13];
  assign D_[14] = D[14];
  assign D_[15] = D[15];
  assign D_[16] = D[16];
  assign D_[17] = D[17];
  assign D_[18] = D[18];
  assign D_[19] = D[19];
  assign D_[20] = D[20];
  assign D_[21] = D[21];
  assign D_[22] = D[22];
  assign D_[23] = D[23];
  assign D_[24] = D[24];
  assign D_[25] = D[25];
  assign D_[26] = D[26];
  assign D_[27] = D[27];
  assign D_[28] = D[28];
  assign D_[29] = D[29];
  assign D_[30] = D[30];
  assign D_[31] = D[31];
  assign EMA_[0] = EMA[0];
  assign EMA_[1] = EMA[1];
  assign EMA_[2] = EMA[2];
  assign TEN_ = TEN;
  assign BEN_ = BEN;
  assign TCEN_ = TCEN;
  assign TWEN_[0] = TWEN[0];
  assign TWEN_[1] = TWEN[1];
  assign TWEN_[2] = TWEN[2];
  assign TWEN_[3] = TWEN[3];
  assign TA_[0] = TA[0];
  assign TA_[1] = TA[1];
  assign TA_[2] = TA[2];
  assign TA_[3] = TA[3];
  assign TA_[4] = TA[4];
  assign TA_[5] = TA[5];
  assign TA_[6] = TA[6];
  assign TA_[7] = TA[7];
  assign TA_[8] = TA[8];
  assign TD_[0] = TD[0];
  assign TD_[1] = TD[1];
  assign TD_[2] = TD[2];
  assign TD_[3] = TD[3];
  assign TD_[4] = TD[4];
  assign TD_[5] = TD[5];
  assign TD_[6] = TD[6];
  assign TD_[7] = TD[7];
  assign TD_[8] = TD[8];
  assign TD_[9] = TD[9];
  assign TD_[10] = TD[10];
  assign TD_[11] = TD[11];
  assign TD_[12] = TD[12];
  assign TD_[13] = TD[13];
  assign TD_[14] = TD[14];
  assign TD_[15] = TD[15];
  assign TD_[16] = TD[16];
  assign TD_[17] = TD[17];
  assign TD_[18] = TD[18];
  assign TD_[19] = TD[19];
  assign TD_[20] = TD[20];
  assign TD_[21] = TD[21];
  assign TD_[22] = TD[22];
  assign TD_[23] = TD[23];
  assign TD_[24] = TD[24];
  assign TD_[25] = TD[25];
  assign TD_[26] = TD[26];
  assign TD_[27] = TD[27];
  assign TD_[28] = TD[28];
  assign TD_[29] = TD[29];
  assign TD_[30] = TD[30];
  assign TD_[31] = TD[31];
  assign TQ_[0] = TQ[0];
  assign TQ_[1] = TQ[1];
  assign TQ_[2] = TQ[2];
  assign TQ_[3] = TQ[3];
  assign TQ_[4] = TQ[4];
  assign TQ_[5] = TQ[5];
  assign TQ_[6] = TQ[6];
  assign TQ_[7] = TQ[7];
  assign TQ_[8] = TQ[8];
  assign TQ_[9] = TQ[9];
  assign TQ_[10] = TQ[10];
  assign TQ_[11] = TQ[11];
  assign TQ_[12] = TQ[12];
  assign TQ_[13] = TQ[13];
  assign TQ_[14] = TQ[14];
  assign TQ_[15] = TQ[15];
  assign TQ_[16] = TQ[16];
  assign TQ_[17] = TQ[17];
  assign TQ_[18] = TQ[18];
  assign TQ_[19] = TQ[19];
  assign TQ_[20] = TQ[20];
  assign TQ_[21] = TQ[21];
  assign TQ_[22] = TQ[22];
  assign TQ_[23] = TQ[23];
  assign TQ_[24] = TQ[24];
  assign TQ_[25] = TQ[25];
  assign TQ_[26] = TQ[26];
  assign TQ_[27] = TQ[27];
  assign TQ_[28] = TQ[28];
  assign TQ_[29] = TQ[29];
  assign TQ_[30] = TQ[30];
  assign TQ_[31] = TQ[31];
  assign GWEN_ = GWEN;
  assign TGWEN_ = TGWEN;
  assign RETN_ = RETN;
  assign PEN_ = PEN;
  assign TPEN_ = TPEN;

  assign `ARM_UD_DP CENY_ = RETN_ ? (TEN_ ? CEN_ : TCEN_) : 1'b0;
  assign `ARM_UD_DP WENY_ = RETN_ ? (TEN_ ? WEN_ : TWEN_) : {4{1'b0}};
  assign `ARM_UD_DP AY_ = RETN_ ? (TEN_ ? A_ : TA_) : {9{1'b0}};
  assign `ARM_UD_DP DY_ = RETN_ ? (TEN_ ? D_ : TD_) : {32{1'b0}};
  assign `ARM_UD_DP GWENY_ = RETN_ ? (TEN_ ? GWEN_ : TGWEN_) : 1'b0;
  assign `ARM_UD_SEQ Q_ = RETN_ ? (Q_int) : {32{1'b0}};
  assign `ARM_UD_SEQ QI_ = RETN_ ? (Q_stage1) : {32{1'b0}};
  assign `ARM_UD_DP PENY_ = RETN_ ? (PEN_int) : 1'b0;

`ifdef INITIALIZE_MEMORY
  integer i;
  initial
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'b0}};
`endif

  task failedWrite;
  input port;
  integer i;
  begin
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'bx}};
  end
  endtask

  function isBitX;
    input bitIn;
    begin
      isBitX = ( bitIn===1'bx || bitIn===1'bz ) ? 1'b1 : 1'b0;
    end
  endfunction


  task readWrite;
  begin
    if (RETN_int === 1'bx) begin
      failedWrite(0);
      Q_stage1 = {32{1'bx}};
    end else if (RETN_int === 1'b0 && CEN_int === 1'b0) begin
      failedWrite(0);
      Q_stage1 = {32{1'bx}};
    end else if (RETN_int === 1'b0) begin
      // no cycle in retention mode
    end else if (^{CEN_int, EMA_int, TEN_int} === 1'bx) begin
      failedWrite(0);
      Q_stage1 = {32{1'bx}};
    end else if ((A_int >= WORDS) && (CEN_int === 1'b0)) begin
      writeEnable = ~( {32{GWEN_int}} | {WEN_int[3], WEN_int[3], WEN_int[3], WEN_int[3],
         WEN_int[3], WEN_int[3], WEN_int[3], WEN_int[3], WEN_int[2], WEN_int[2], WEN_int[2],
         WEN_int[2], WEN_int[2], WEN_int[2], WEN_int[2], WEN_int[2], WEN_int[1], WEN_int[1],
         WEN_int[1], WEN_int[1], WEN_int[1], WEN_int[1], WEN_int[1], WEN_int[1], WEN_int[0],
         WEN_int[0], WEN_int[0], WEN_int[0], WEN_int[0], WEN_int[0], WEN_int[0], WEN_int[0]});
      Q_stage1 = ((writeEnable & D_int) | (~writeEnable & {32{1'bx}}));
    end else if (CEN_int === 1'b0 && (^A_int) === 1'bx) begin
      if (GWEN_int !== 1'b1 && (& WEN_int) !== 1'b1) failedWrite(0);
      Q_stage1 = {32{1'bx}};
    end else if (CEN_int === 1'b0) begin
      mux_address = (A_int & 4'b1111);
      row_address = (A_int >> 4);
      if (row_address >= 32)
        row = {512{1'bx}};
      else
        row = mem[row_address];
      if( isBitX(GWEN_int) )
        writeEnable = {32{1'bx}};
      else
        writeEnable = ~( {32{GWEN_int}} | {WEN_int[3], WEN_int[3], WEN_int[3], WEN_int[3],
         WEN_int[3], WEN_int[3], WEN_int[3], WEN_int[3], WEN_int[2], WEN_int[2], WEN_int[2],
         WEN_int[2], WEN_int[2], WEN_int[2], WEN_int[2], WEN_int[2], WEN_int[1], WEN_int[1],
         WEN_int[1], WEN_int[1], WEN_int[1], WEN_int[1], WEN_int[1], WEN_int[1], WEN_int[0],
         WEN_int[0], WEN_int[0], WEN_int[0], WEN_int[0], WEN_int[0], WEN_int[0], WEN_int[0]});
      row_mask =  ( {15'b000000000000000, writeEnable[31], 15'b000000000000000, writeEnable[30],
          15'b000000000000000, writeEnable[29], 15'b000000000000000, writeEnable[28],
          15'b000000000000000, writeEnable[27], 15'b000000000000000, writeEnable[26],
          15'b000000000000000, writeEnable[25], 15'b000000000000000, writeEnable[24],
          15'b000000000000000, writeEnable[23], 15'b000000000000000, writeEnable[22],
          15'b000000000000000, writeEnable[21], 15'b000000000000000, writeEnable[20],
          15'b000000000000000, writeEnable[19], 15'b000000000000000, writeEnable[18],
          15'b000000000000000, writeEnable[17], 15'b000000000000000, writeEnable[16],
          15'b000000000000000, writeEnable[15], 15'b000000000000000, writeEnable[14],
          15'b000000000000000, writeEnable[13], 15'b000000000000000, writeEnable[12],
          15'b000000000000000, writeEnable[11], 15'b000000000000000, writeEnable[10],
          15'b000000000000000, writeEnable[9], 15'b000000000000000, writeEnable[8],
          15'b000000000000000, writeEnable[7], 15'b000000000000000, writeEnable[6],
          15'b000000000000000, writeEnable[5], 15'b000000000000000, writeEnable[4],
          15'b000000000000000, writeEnable[3], 15'b000000000000000, writeEnable[2],
          15'b000000000000000, writeEnable[1], 15'b000000000000000, writeEnable[0]} << mux_address);
      new_data =  ( {15'b000000000000000, D_int[31], 15'b000000000000000, D_int[30],
          15'b000000000000000, D_int[29], 15'b000000000000000, D_int[28], 15'b000000000000000, D_int[27],
          15'b000000000000000, D_int[26], 15'b000000000000000, D_int[25], 15'b000000000000000, D_int[24],
          15'b000000000000000, D_int[23], 15'b000000000000000, D_int[22], 15'b000000000000000, D_int[21],
          15'b000000000000000, D_int[20], 15'b000000000000000, D_int[19], 15'b000000000000000, D_int[18],
          15'b000000000000000, D_int[17], 15'b000000000000000, D_int[16], 15'b000000000000000, D_int[15],
          15'b000000000000000, D_int[14], 15'b000000000000000, D_int[13], 15'b000000000000000, D_int[12],
          15'b000000000000000, D_int[11], 15'b000000000000000, D_int[10], 15'b000000000000000, D_int[9],
          15'b000000000000000, D_int[8], 15'b000000000000000, D_int[7], 15'b000000000000000, D_int[6],
          15'b000000000000000, D_int[5], 15'b000000000000000, D_int[4], 15'b000000000000000, D_int[3],
          15'b000000000000000, D_int[2], 15'b000000000000000, D_int[1], 15'b000000000000000, D_int[0]} << mux_address);
      row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
      mem[row_address] = row;
      data_out = (row >> mux_address);
      if (GWEN_int !== 1'b0)
        Q_stage1 = {data_out[496], data_out[480], data_out[464], data_out[448], data_out[432],
          data_out[416], data_out[400], data_out[384], data_out[368], data_out[352],
          data_out[336], data_out[320], data_out[304], data_out[288], data_out[272],
          data_out[256], data_out[240], data_out[224], data_out[208], data_out[192],
          data_out[176], data_out[160], data_out[144], data_out[128], data_out[112],
          data_out[96], data_out[80], data_out[64], data_out[48], data_out[32], data_out[16],
          data_out[0]};
      else
        Q_stage1 = {(writeEnable[31]?data_out[496]:Q_stage1[31]), (writeEnable[30]?data_out[480]:Q_stage1[30]),
          (writeEnable[29]?data_out[464]:Q_stage1[29]), (writeEnable[28]?data_out[448]:Q_stage1[28]),
          (writeEnable[27]?data_out[432]:Q_stage1[27]), (writeEnable[26]?data_out[416]:Q_stage1[26]),
          (writeEnable[25]?data_out[400]:Q_stage1[25]), (writeEnable[24]?data_out[384]:Q_stage1[24]),
          (writeEnable[23]?data_out[368]:Q_stage1[23]), (writeEnable[22]?data_out[352]:Q_stage1[22]),
          (writeEnable[21]?data_out[336]:Q_stage1[21]), (writeEnable[20]?data_out[320]:Q_stage1[20]),
          (writeEnable[19]?data_out[304]:Q_stage1[19]), (writeEnable[18]?data_out[288]:Q_stage1[18]),
          (writeEnable[17]?data_out[272]:Q_stage1[17]), (writeEnable[16]?data_out[256]:Q_stage1[16]),
          (writeEnable[15]?data_out[240]:Q_stage1[15]), (writeEnable[14]?data_out[224]:Q_stage1[14]),
          (writeEnable[13]?data_out[208]:Q_stage1[13]), (writeEnable[12]?data_out[192]:Q_stage1[12]),
          (writeEnable[11]?data_out[176]:Q_stage1[11]), (writeEnable[10]?data_out[160]:Q_stage1[10]),
          (writeEnable[9]?data_out[144]:Q_stage1[9]), (writeEnable[8]?data_out[128]:Q_stage1[8]),
          (writeEnable[7]?data_out[112]:Q_stage1[7]), (writeEnable[6]?data_out[96]:Q_stage1[6]),
          (writeEnable[5]?data_out[80]:Q_stage1[5]), (writeEnable[4]?data_out[64]:Q_stage1[4]),
          (writeEnable[3]?data_out[48]:Q_stage1[3]), (writeEnable[2]?data_out[32]:Q_stage1[2]),
          (writeEnable[1]?data_out[16]:Q_stage1[1]), (writeEnable[0]?data_out[0]:Q_stage1[0])};
    end
  end
  endtask

  always @ RETN_ begin
    if (RETN_ == 1'b0) begin
      Q_int = {32{1'b0}};
      Q_stage1 = {32{1'b0}};
      PEN_prev = 1'b0;
      CEN_int = 1'b0;
      WEN_int = {4{1'b0}};
      A_int = {9{1'b0}};
      D_int = {32{1'b0}};
      EMA_int = {3{1'b0}};
      TEN_int = 1'b0;
      BEN_int = 1'b0;
      TCEN_int = 1'b0;
      TWEN_int = {4{1'b0}};
      TA_int = {9{1'b0}};
      TD_int = {32{1'b0}};
      TQ_int = {32{1'b0}};
      GWEN_int = 1'b0;
      TGWEN_int = 1'b0;
      RETN_int = 1'b0;
      PEN_int = 1'b0;
      TPEN_int = 1'b0;
    end else begin
      Q_int = {32{1'bx}};
      Q_stage1 = {32{1'bx}};
      PEN_prev = 1'bx;
      CEN_int = 1'bx;
      WEN_int = {4{1'bx}};
      A_int = {9{1'bx}};
      D_int = {32{1'bx}};
      EMA_int = {3{1'bx}};
      TEN_int = 1'bx;
      BEN_int = 1'bx;
      TCEN_int = 1'bx;
      TWEN_int = {4{1'bx}};
      TA_int = {9{1'bx}};
      TD_int = {32{1'bx}};
      TQ_int = {32{1'bx}};
      GWEN_int = 1'bx;
      TGWEN_int = 1'bx;
      RETN_int = 1'bx;
      PEN_int = 1'bx;
      TPEN_int = 1'bx;
    end
    RETN_int = RETN_;
  end

  always @ CLK_ begin
`ifdef POWER_PINS
    if (VSSE === 1'bx || VSSE === 1'bz)
      $display("ERROR: Illegal value for VSSE %b", VSSE);
    if (VDDPE === 1'bx || VDDPE === 1'bz)
      $display("ERROR: Illegal value for VDDPE %b", VDDPE);
    if (VDDCE === 1'bx || VDDCE === 1'bz)
      $display("ERROR: Illegal value for VDDCE %b", VDDCE);
`endif
    if (CLK_ === 1'bx && (TEN_ ? CEN_ !== 1'b1 : TCEN_ !== 1'b1)) begin
      failedWrite(0);
      Q_int = {32{1'bx}};
      Q_stage1 = {32{1'bx}};
    end else if (CLK_ === 1'b1 && LAST_CLK === 1'b0) begin
      PEN_prev = PEN_int;
      CEN_int = TEN_ ? CEN_ : TCEN_;
      WEN_int = TEN_ ? WEN_ : TWEN_;
      A_int = TEN_ ? A_ : TA_;
      D_int = TEN_ ? D_ : TD_;
      EMA_int = EMA_;
      TEN_int = TEN_;
      BEN_int = BEN_;
      TCEN_int = TCEN_;
      TWEN_int = TWEN_;
      TA_int = TA_;
      TD_int = TD_;
      TQ_int = TQ_;
      GWEN_int = TEN_ ? GWEN_ : TGWEN_;
      TGWEN_int = TGWEN_;
      RETN_int = RETN_;
      PEN_int = TEN_ ? PEN_ : TPEN_;
      TPEN_int = TPEN_;
      clk0_int = 1'b0;
    // PIPELINE stage 2
    if ((PEN_prev === 1'b0 || BEN_ === 1'b0) && (RETN_int === 1'b1))
      Q_int = BEN_int ? Q_stage1 : TQ_int;
    else if (PEN_prev === 1'bx )
      Q_int = {32{1'bx}};
 
      readWrite;
    end
    LAST_CLK = CLK_;
  end


endmodule
`endcelldefine
`else
`timescale 1 ns/1 ps
`celldefine
`ifdef POWER_PINS
module sram_512w_32b_120mhz_wwm (CENY, WENY, AY, DY, GWENY, Q, QI, PENY, CLK, CEN,
    WEN, A, D, EMA, TEN, BEN, TCEN, TWEN, TA, TD, TQ, GWEN, TGWEN, RETN, PEN, TPEN,
    VSSE, VDDPE, VDDCE);
`else
module sram_512w_32b_120mhz_wwm (CENY, WENY, AY, DY, GWENY, Q, QI, PENY, CLK, CEN,
    WEN, A, D, EMA, TEN, BEN, TCEN, TWEN, TA, TD, TQ, GWEN, TGWEN, RETN, PEN, TPEN);
`endif

  parameter BITS = 32;
  parameter WORDS = 512;
  parameter MUX = 16;
  parameter MEM_WIDTH = 512; // redun block size 8, 256 on left, 256 on right
  parameter MEM_HEIGHT = 32;
  parameter WP_SIZE = 8 ;
  parameter UPM_WIDTH = 3;

  output  CENY;
  output [3:0] WENY;
  output [8:0] AY;
  output [31:0] DY;
  output  GWENY;
  output [31:0] Q;
  output [31:0] QI;
  output  PENY;
  input  CLK;
  input  CEN;
  input [3:0] WEN;
  input [8:0] A;
  input [31:0] D;
  input [2:0] EMA;
  input  TEN;
  input  BEN;
  input  TCEN;
  input [3:0] TWEN;
  input [8:0] TA;
  input [31:0] TD;
  input [31:0] TQ;
  input  GWEN;
  input  TGWEN;
  input  RETN;
  input  PEN;
  input  TPEN;
`ifdef POWER_PINS
  inout VSSE;
  inout VDDPE;
  inout VDDCE;
`endif

  integer row_address;
  integer mux_address;
  reg [511:0] mem [0:31];
  reg [511:0] row;
  reg LAST_CLK;
  reg [511:0] data_out;
  reg [511:0] row_mask;
  reg [511:0] new_data;
  reg [31:0] Q_int;
  reg [31:0] writeEnable;
  reg PEN_prev;
  reg [31:0] Q_stage1;

  reg NOT_A0, NOT_A1, NOT_A2, NOT_A3, NOT_A4, NOT_A5, NOT_A6, NOT_A7, NOT_A8, NOT_BEN;
  reg NOT_CEN, NOT_CLK_MINH, NOT_CLK_MINL, NOT_CLK_PER, NOT_D0, NOT_D1, NOT_D10, NOT_D11;
  reg NOT_D12, NOT_D13, NOT_D14, NOT_D15, NOT_D16, NOT_D17, NOT_D18, NOT_D19, NOT_D2;
  reg NOT_D20, NOT_D21, NOT_D22, NOT_D23, NOT_D24, NOT_D25, NOT_D26, NOT_D27, NOT_D28;
  reg NOT_D29, NOT_D3, NOT_D30, NOT_D31, NOT_D4, NOT_D5, NOT_D6, NOT_D7, NOT_D8, NOT_D9;
  reg NOT_EMA0, NOT_EMA1, NOT_EMA2, NOT_GWEN, NOT_PEN, NOT_RETN, NOT_TA0, NOT_TA1;
  reg NOT_TA2, NOT_TA3, NOT_TA4, NOT_TA5, NOT_TA6, NOT_TA7, NOT_TA8, NOT_TCEN, NOT_TD0;
  reg NOT_TD1, NOT_TD10, NOT_TD11, NOT_TD12, NOT_TD13, NOT_TD14, NOT_TD15, NOT_TD16;
  reg NOT_TD17, NOT_TD18, NOT_TD19, NOT_TD2, NOT_TD20, NOT_TD21, NOT_TD22, NOT_TD23;
  reg NOT_TD24, NOT_TD25, NOT_TD26, NOT_TD27, NOT_TD28, NOT_TD29, NOT_TD3, NOT_TD30;
  reg NOT_TD31, NOT_TD4, NOT_TD5, NOT_TD6, NOT_TD7, NOT_TD8, NOT_TD9, NOT_TEN, NOT_TGWEN;
  reg NOT_TPEN, NOT_TQ0, NOT_TQ1, NOT_TQ10, NOT_TQ11, NOT_TQ12, NOT_TQ13, NOT_TQ14;
  reg NOT_TQ15, NOT_TQ16, NOT_TQ17, NOT_TQ18, NOT_TQ19, NOT_TQ2, NOT_TQ20, NOT_TQ21;
  reg NOT_TQ22, NOT_TQ23, NOT_TQ24, NOT_TQ25, NOT_TQ26, NOT_TQ27, NOT_TQ28, NOT_TQ29;
  reg NOT_TQ3, NOT_TQ30, NOT_TQ31, NOT_TQ4, NOT_TQ5, NOT_TQ6, NOT_TQ7, NOT_TQ8, NOT_TQ9;
  reg NOT_TWEN0, NOT_TWEN1, NOT_TWEN2, NOT_TWEN3, NOT_WEN0, NOT_WEN1, NOT_WEN2, NOT_WEN3;
  reg clk0_int;
  reg CREN_legal;
  initial CREN_legal = 1'b1;

  wire  CENY_;
  wire [3:0] WENY_;
  wire [8:0] AY_;
  wire [31:0] DY_;
  wire  GWENY_;
  wire [31:0] Q_;
  wire [31:0] QI_;
  wire  PENY_;
 wire  CLK_;
  wire  CEN_;
  reg  CEN_int;
  wire [3:0] WEN_;
  reg [3:0] WEN_int;
  wire [8:0] A_;
  reg [8:0] A_int;
  wire [31:0] D_;
  reg [31:0] D_int;
  wire [2:0] EMA_;
  reg [2:0] EMA_int;
  wire  TEN_;
  reg  TEN_int;
  wire  BEN_;
  reg  BEN_int;
  wire  TCEN_;
  reg  TCEN_int;
  wire [3:0] TWEN_;
  reg [3:0] TWEN_int;
  wire [8:0] TA_;
  reg [8:0] TA_int;
  wire [31:0] TD_;
  reg [31:0] TD_int;
  wire [31:0] TQ_;
  reg [31:0] TQ_int;
  wire  GWEN_;
  reg  GWEN_int;
  wire  TGWEN_;
  reg  TGWEN_int;
  wire  RETN_;
  reg  RETN_int;
  wire  PEN_;
  reg  PEN_int;
  wire  TPEN_;
  reg  TPEN_int;

  buf B0(CENY, CENY_);
  buf B1(WENY[0], WENY_[0]);
  buf B2(WENY[1], WENY_[1]);
  buf B3(WENY[2], WENY_[2]);
  buf B4(WENY[3], WENY_[3]);
  buf B5(AY[0], AY_[0]);
  buf B6(AY[1], AY_[1]);
  buf B7(AY[2], AY_[2]);
  buf B8(AY[3], AY_[3]);
  buf B9(AY[4], AY_[4]);
  buf B10(AY[5], AY_[5]);
  buf B11(AY[6], AY_[6]);
  buf B12(AY[7], AY_[7]);
  buf B13(AY[8], AY_[8]);
  buf B14(DY[0], DY_[0]);
  buf B15(DY[1], DY_[1]);
  buf B16(DY[2], DY_[2]);
  buf B17(DY[3], DY_[3]);
  buf B18(DY[4], DY_[4]);
  buf B19(DY[5], DY_[5]);
  buf B20(DY[6], DY_[6]);
  buf B21(DY[7], DY_[7]);
  buf B22(DY[8], DY_[8]);
  buf B23(DY[9], DY_[9]);
  buf B24(DY[10], DY_[10]);
  buf B25(DY[11], DY_[11]);
  buf B26(DY[12], DY_[12]);
  buf B27(DY[13], DY_[13]);
  buf B28(DY[14], DY_[14]);
  buf B29(DY[15], DY_[15]);
  buf B30(DY[16], DY_[16]);
  buf B31(DY[17], DY_[17]);
  buf B32(DY[18], DY_[18]);
  buf B33(DY[19], DY_[19]);
  buf B34(DY[20], DY_[20]);
  buf B35(DY[21], DY_[21]);
  buf B36(DY[22], DY_[22]);
  buf B37(DY[23], DY_[23]);
  buf B38(DY[24], DY_[24]);
  buf B39(DY[25], DY_[25]);
  buf B40(DY[26], DY_[26]);
  buf B41(DY[27], DY_[27]);
  buf B42(DY[28], DY_[28]);
  buf B43(DY[29], DY_[29]);
  buf B44(DY[30], DY_[30]);
  buf B45(DY[31], DY_[31]);
  buf B46(GWENY, GWENY_);
  buf B47(Q[0], Q_[0]);
  buf B48(Q[1], Q_[1]);
  buf B49(Q[2], Q_[2]);
  buf B50(Q[3], Q_[3]);
  buf B51(Q[4], Q_[4]);
  buf B52(Q[5], Q_[5]);
  buf B53(Q[6], Q_[6]);
  buf B54(Q[7], Q_[7]);
  buf B55(Q[8], Q_[8]);
  buf B56(Q[9], Q_[9]);
  buf B57(Q[10], Q_[10]);
  buf B58(Q[11], Q_[11]);
  buf B59(Q[12], Q_[12]);
  buf B60(Q[13], Q_[13]);
  buf B61(Q[14], Q_[14]);
  buf B62(Q[15], Q_[15]);
  buf B63(Q[16], Q_[16]);
  buf B64(Q[17], Q_[17]);
  buf B65(Q[18], Q_[18]);
  buf B66(Q[19], Q_[19]);
  buf B67(Q[20], Q_[20]);
  buf B68(Q[21], Q_[21]);
  buf B69(Q[22], Q_[22]);
  buf B70(Q[23], Q_[23]);
  buf B71(Q[24], Q_[24]);
  buf B72(Q[25], Q_[25]);
  buf B73(Q[26], Q_[26]);
  buf B74(Q[27], Q_[27]);
  buf B75(Q[28], Q_[28]);
  buf B76(Q[29], Q_[29]);
  buf B77(Q[30], Q_[30]);
  buf B78(Q[31], Q_[31]);
  buf B79(QI[0], QI_[0]);
  buf B80(QI[1], QI_[1]);
  buf B81(QI[2], QI_[2]);
  buf B82(QI[3], QI_[3]);
  buf B83(QI[4], QI_[4]);
  buf B84(QI[5], QI_[5]);
  buf B85(QI[6], QI_[6]);
  buf B86(QI[7], QI_[7]);
  buf B87(QI[8], QI_[8]);
  buf B88(QI[9], QI_[9]);
  buf B89(QI[10], QI_[10]);
  buf B90(QI[11], QI_[11]);
  buf B91(QI[12], QI_[12]);
  buf B92(QI[13], QI_[13]);
  buf B93(QI[14], QI_[14]);
  buf B94(QI[15], QI_[15]);
  buf B95(QI[16], QI_[16]);
  buf B96(QI[17], QI_[17]);
  buf B97(QI[18], QI_[18]);
  buf B98(QI[19], QI_[19]);
  buf B99(QI[20], QI_[20]);
  buf B100(QI[21], QI_[21]);
  buf B101(QI[22], QI_[22]);
  buf B102(QI[23], QI_[23]);
  buf B103(QI[24], QI_[24]);
  buf B104(QI[25], QI_[25]);
  buf B105(QI[26], QI_[26]);
  buf B106(QI[27], QI_[27]);
  buf B107(QI[28], QI_[28]);
  buf B108(QI[29], QI_[29]);
  buf B109(QI[30], QI_[30]);
  buf B110(QI[31], QI_[31]);
  buf B111(PENY, PENY_);
  buf B112(CLK_, CLK);
  buf B113(CEN_, CEN);
  buf B114(WEN_[0], WEN[0]);
  buf B115(WEN_[1], WEN[1]);
  buf B116(WEN_[2], WEN[2]);
  buf B117(WEN_[3], WEN[3]);
  buf B118(A_[0], A[0]);
  buf B119(A_[1], A[1]);
  buf B120(A_[2], A[2]);
  buf B121(A_[3], A[3]);
  buf B122(A_[4], A[4]);
  buf B123(A_[5], A[5]);
  buf B124(A_[6], A[6]);
  buf B125(A_[7], A[7]);
  buf B126(A_[8], A[8]);
  buf B127(D_[0], D[0]);
  buf B128(D_[1], D[1]);
  buf B129(D_[2], D[2]);
  buf B130(D_[3], D[3]);
  buf B131(D_[4], D[4]);
  buf B132(D_[5], D[5]);
  buf B133(D_[6], D[6]);
  buf B134(D_[7], D[7]);
  buf B135(D_[8], D[8]);
  buf B136(D_[9], D[9]);
  buf B137(D_[10], D[10]);
  buf B138(D_[11], D[11]);
  buf B139(D_[12], D[12]);
  buf B140(D_[13], D[13]);
  buf B141(D_[14], D[14]);
  buf B142(D_[15], D[15]);
  buf B143(D_[16], D[16]);
  buf B144(D_[17], D[17]);
  buf B145(D_[18], D[18]);
  buf B146(D_[19], D[19]);
  buf B147(D_[20], D[20]);
  buf B148(D_[21], D[21]);
  buf B149(D_[22], D[22]);
  buf B150(D_[23], D[23]);
  buf B151(D_[24], D[24]);
  buf B152(D_[25], D[25]);
  buf B153(D_[26], D[26]);
  buf B154(D_[27], D[27]);
  buf B155(D_[28], D[28]);
  buf B156(D_[29], D[29]);
  buf B157(D_[30], D[30]);
  buf B158(D_[31], D[31]);
  buf B159(EMA_[0], EMA[0]);
  buf B160(EMA_[1], EMA[1]);
  buf B161(EMA_[2], EMA[2]);
  buf B162(TEN_, TEN);
  buf B163(BEN_, BEN);
  buf B164(TCEN_, TCEN);
  buf B165(TWEN_[0], TWEN[0]);
  buf B166(TWEN_[1], TWEN[1]);
  buf B167(TWEN_[2], TWEN[2]);
  buf B168(TWEN_[3], TWEN[3]);
  buf B169(TA_[0], TA[0]);
  buf B170(TA_[1], TA[1]);
  buf B171(TA_[2], TA[2]);
  buf B172(TA_[3], TA[3]);
  buf B173(TA_[4], TA[4]);
  buf B174(TA_[5], TA[5]);
  buf B175(TA_[6], TA[6]);
  buf B176(TA_[7], TA[7]);
  buf B177(TA_[8], TA[8]);
  buf B178(TD_[0], TD[0]);
  buf B179(TD_[1], TD[1]);
  buf B180(TD_[2], TD[2]);
  buf B181(TD_[3], TD[3]);
  buf B182(TD_[4], TD[4]);
  buf B183(TD_[5], TD[5]);
  buf B184(TD_[6], TD[6]);
  buf B185(TD_[7], TD[7]);
  buf B186(TD_[8], TD[8]);
  buf B187(TD_[9], TD[9]);
  buf B188(TD_[10], TD[10]);
  buf B189(TD_[11], TD[11]);
  buf B190(TD_[12], TD[12]);
  buf B191(TD_[13], TD[13]);
  buf B192(TD_[14], TD[14]);
  buf B193(TD_[15], TD[15]);
  buf B194(TD_[16], TD[16]);
  buf B195(TD_[17], TD[17]);
  buf B196(TD_[18], TD[18]);
  buf B197(TD_[19], TD[19]);
  buf B198(TD_[20], TD[20]);
  buf B199(TD_[21], TD[21]);
  buf B200(TD_[22], TD[22]);
  buf B201(TD_[23], TD[23]);
  buf B202(TD_[24], TD[24]);
  buf B203(TD_[25], TD[25]);
  buf B204(TD_[26], TD[26]);
  buf B205(TD_[27], TD[27]);
  buf B206(TD_[28], TD[28]);
  buf B207(TD_[29], TD[29]);
  buf B208(TD_[30], TD[30]);
  buf B209(TD_[31], TD[31]);
  buf B210(TQ_[0], TQ[0]);
  buf B211(TQ_[1], TQ[1]);
  buf B212(TQ_[2], TQ[2]);
  buf B213(TQ_[3], TQ[3]);
  buf B214(TQ_[4], TQ[4]);
  buf B215(TQ_[5], TQ[5]);
  buf B216(TQ_[6], TQ[6]);
  buf B217(TQ_[7], TQ[7]);
  buf B218(TQ_[8], TQ[8]);
  buf B219(TQ_[9], TQ[9]);
  buf B220(TQ_[10], TQ[10]);
  buf B221(TQ_[11], TQ[11]);
  buf B222(TQ_[12], TQ[12]);
  buf B223(TQ_[13], TQ[13]);
  buf B224(TQ_[14], TQ[14]);
  buf B225(TQ_[15], TQ[15]);
  buf B226(TQ_[16], TQ[16]);
  buf B227(TQ_[17], TQ[17]);
  buf B228(TQ_[18], TQ[18]);
  buf B229(TQ_[19], TQ[19]);
  buf B230(TQ_[20], TQ[20]);
  buf B231(TQ_[21], TQ[21]);
  buf B232(TQ_[22], TQ[22]);
  buf B233(TQ_[23], TQ[23]);
  buf B234(TQ_[24], TQ[24]);
  buf B235(TQ_[25], TQ[25]);
  buf B236(TQ_[26], TQ[26]);
  buf B237(TQ_[27], TQ[27]);
  buf B238(TQ_[28], TQ[28]);
  buf B239(TQ_[29], TQ[29]);
  buf B240(TQ_[30], TQ[30]);
  buf B241(TQ_[31], TQ[31]);
  buf B242(GWEN_, GWEN);
  buf B243(TGWEN_, TGWEN);
  buf B244(RETN_, RETN);
  buf B245(PEN_, PEN);
  buf B246(TPEN_, TPEN);

  assign CENY_ = RETN_ ? (TEN_ ? CEN_ : TCEN_) : 1'b0;
  assign WENY_ = RETN_ ? (TEN_ ? WEN_ : TWEN_) : {4{1'b0}};
  assign AY_ = RETN_ ? (TEN_ ? A_ : TA_) : {9{1'b0}};
  assign DY_ = RETN_ ? (TEN_ ? D_ : TD_) : {32{1'b0}};
  assign GWENY_ = RETN_ ? (TEN_ ? GWEN_ : TGWEN_) : 1'b0;
  assign Q_ = RETN_ ? (Q_int) : {32{1'b0}};
  assign QI_ = RETN_ ? (Q_stage1) : {32{1'b0}};
  assign PENY_ = RETN_ ? (PEN_int) : 1'b0;

`ifdef INITIALIZE_MEMORY
  integer i;
  initial
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'b0}};
`endif

  task failedWrite;
  input port;
  integer i;
  begin
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'bx}};
  end
  endtask

  function isBitX;
    input bitIn;
    begin
      isBitX = ( bitIn===1'bx || bitIn===1'bz ) ? 1'b1 : 1'b0;
    end
  endfunction


  task readWrite;
  begin
    if (RETN_int === 1'bx) begin
      failedWrite(0);
      Q_stage1 = {32{1'bx}};
    end else if (RETN_int === 1'b0 && CEN_int === 1'b0) begin
      failedWrite(0);
      Q_stage1 = {32{1'bx}};
    end else if (RETN_int === 1'b0) begin
      // no cycle in retention mode
    end else if (^{CEN_int, EMA_int, TEN_int} === 1'bx) begin
      failedWrite(0);
      Q_stage1 = {32{1'bx}};
    end else if ((A_int >= WORDS) && (CEN_int === 1'b0)) begin
      writeEnable = ~( {32{GWEN_int}} | {WEN_int[3], WEN_int[3], WEN_int[3], WEN_int[3],
         WEN_int[3], WEN_int[3], WEN_int[3], WEN_int[3], WEN_int[2], WEN_int[2], WEN_int[2],
         WEN_int[2], WEN_int[2], WEN_int[2], WEN_int[2], WEN_int[2], WEN_int[1], WEN_int[1],
         WEN_int[1], WEN_int[1], WEN_int[1], WEN_int[1], WEN_int[1], WEN_int[1], WEN_int[0],
         WEN_int[0], WEN_int[0], WEN_int[0], WEN_int[0], WEN_int[0], WEN_int[0], WEN_int[0]});
      Q_stage1 = ((writeEnable & D_int) | (~writeEnable & {32{1'bx}}));
    end else if (CEN_int === 1'b0 && (^A_int) === 1'bx) begin
      if (GWEN_int !== 1'b1 && (& WEN_int) !== 1'b1) failedWrite(0);
      Q_stage1 = {32{1'bx}};
    end else if (CEN_int === 1'b0) begin
      mux_address = (A_int & 4'b1111);
      row_address = (A_int >> 4);
      if (row_address >= 32)
        row = {512{1'bx}};
      else
        row = mem[row_address];
      if( isBitX(GWEN_int) )
        writeEnable = {32{1'bx}};
      else
        writeEnable = ~( {32{GWEN_int}} | {WEN_int[3], WEN_int[3], WEN_int[3], WEN_int[3],
         WEN_int[3], WEN_int[3], WEN_int[3], WEN_int[3], WEN_int[2], WEN_int[2], WEN_int[2],
         WEN_int[2], WEN_int[2], WEN_int[2], WEN_int[2], WEN_int[2], WEN_int[1], WEN_int[1],
         WEN_int[1], WEN_int[1], WEN_int[1], WEN_int[1], WEN_int[1], WEN_int[1], WEN_int[0],
         WEN_int[0], WEN_int[0], WEN_int[0], WEN_int[0], WEN_int[0], WEN_int[0], WEN_int[0]});
      row_mask =  ( {15'b000000000000000, writeEnable[31], 15'b000000000000000, writeEnable[30],
          15'b000000000000000, writeEnable[29], 15'b000000000000000, writeEnable[28],
          15'b000000000000000, writeEnable[27], 15'b000000000000000, writeEnable[26],
          15'b000000000000000, writeEnable[25], 15'b000000000000000, writeEnable[24],
          15'b000000000000000, writeEnable[23], 15'b000000000000000, writeEnable[22],
          15'b000000000000000, writeEnable[21], 15'b000000000000000, writeEnable[20],
          15'b000000000000000, writeEnable[19], 15'b000000000000000, writeEnable[18],
          15'b000000000000000, writeEnable[17], 15'b000000000000000, writeEnable[16],
          15'b000000000000000, writeEnable[15], 15'b000000000000000, writeEnable[14],
          15'b000000000000000, writeEnable[13], 15'b000000000000000, writeEnable[12],
          15'b000000000000000, writeEnable[11], 15'b000000000000000, writeEnable[10],
          15'b000000000000000, writeEnable[9], 15'b000000000000000, writeEnable[8],
          15'b000000000000000, writeEnable[7], 15'b000000000000000, writeEnable[6],
          15'b000000000000000, writeEnable[5], 15'b000000000000000, writeEnable[4],
          15'b000000000000000, writeEnable[3], 15'b000000000000000, writeEnable[2],
          15'b000000000000000, writeEnable[1], 15'b000000000000000, writeEnable[0]} << mux_address);
      new_data =  ( {15'b000000000000000, D_int[31], 15'b000000000000000, D_int[30],
          15'b000000000000000, D_int[29], 15'b000000000000000, D_int[28], 15'b000000000000000, D_int[27],
          15'b000000000000000, D_int[26], 15'b000000000000000, D_int[25], 15'b000000000000000, D_int[24],
          15'b000000000000000, D_int[23], 15'b000000000000000, D_int[22], 15'b000000000000000, D_int[21],
          15'b000000000000000, D_int[20], 15'b000000000000000, D_int[19], 15'b000000000000000, D_int[18],
          15'b000000000000000, D_int[17], 15'b000000000000000, D_int[16], 15'b000000000000000, D_int[15],
          15'b000000000000000, D_int[14], 15'b000000000000000, D_int[13], 15'b000000000000000, D_int[12],
          15'b000000000000000, D_int[11], 15'b000000000000000, D_int[10], 15'b000000000000000, D_int[9],
          15'b000000000000000, D_int[8], 15'b000000000000000, D_int[7], 15'b000000000000000, D_int[6],
          15'b000000000000000, D_int[5], 15'b000000000000000, D_int[4], 15'b000000000000000, D_int[3],
          15'b000000000000000, D_int[2], 15'b000000000000000, D_int[1], 15'b000000000000000, D_int[0]} << mux_address);
      row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
      mem[row_address] = row;
      data_out = (row >> mux_address);
      if (GWEN_int !== 1'b0)
        Q_stage1 = {data_out[496], data_out[480], data_out[464], data_out[448], data_out[432],
          data_out[416], data_out[400], data_out[384], data_out[368], data_out[352],
          data_out[336], data_out[320], data_out[304], data_out[288], data_out[272],
          data_out[256], data_out[240], data_out[224], data_out[208], data_out[192],
          data_out[176], data_out[160], data_out[144], data_out[128], data_out[112],
          data_out[96], data_out[80], data_out[64], data_out[48], data_out[32], data_out[16],
          data_out[0]};
      else
        Q_stage1 = {(writeEnable[31]?data_out[496]:Q_stage1[31]), (writeEnable[30]?data_out[480]:Q_stage1[30]),
          (writeEnable[29]?data_out[464]:Q_stage1[29]), (writeEnable[28]?data_out[448]:Q_stage1[28]),
          (writeEnable[27]?data_out[432]:Q_stage1[27]), (writeEnable[26]?data_out[416]:Q_stage1[26]),
          (writeEnable[25]?data_out[400]:Q_stage1[25]), (writeEnable[24]?data_out[384]:Q_stage1[24]),
          (writeEnable[23]?data_out[368]:Q_stage1[23]), (writeEnable[22]?data_out[352]:Q_stage1[22]),
          (writeEnable[21]?data_out[336]:Q_stage1[21]), (writeEnable[20]?data_out[320]:Q_stage1[20]),
          (writeEnable[19]?data_out[304]:Q_stage1[19]), (writeEnable[18]?data_out[288]:Q_stage1[18]),
          (writeEnable[17]?data_out[272]:Q_stage1[17]), (writeEnable[16]?data_out[256]:Q_stage1[16]),
          (writeEnable[15]?data_out[240]:Q_stage1[15]), (writeEnable[14]?data_out[224]:Q_stage1[14]),
          (writeEnable[13]?data_out[208]:Q_stage1[13]), (writeEnable[12]?data_out[192]:Q_stage1[12]),
          (writeEnable[11]?data_out[176]:Q_stage1[11]), (writeEnable[10]?data_out[160]:Q_stage1[10]),
          (writeEnable[9]?data_out[144]:Q_stage1[9]), (writeEnable[8]?data_out[128]:Q_stage1[8]),
          (writeEnable[7]?data_out[112]:Q_stage1[7]), (writeEnable[6]?data_out[96]:Q_stage1[6]),
          (writeEnable[5]?data_out[80]:Q_stage1[5]), (writeEnable[4]?data_out[64]:Q_stage1[4]),
          (writeEnable[3]?data_out[48]:Q_stage1[3]), (writeEnable[2]?data_out[32]:Q_stage1[2]),
          (writeEnable[1]?data_out[16]:Q_stage1[1]), (writeEnable[0]?data_out[0]:Q_stage1[0])};
    end
  end
  endtask

  always @ RETN_ begin
    if (RETN_ == 1'b0) begin
      Q_int = {32{1'b0}};
      Q_stage1 = {32{1'b0}};
      PEN_prev = 1'b0;
      CEN_int = 1'b0;
      WEN_int = {4{1'b0}};
      A_int = {9{1'b0}};
      D_int = {32{1'b0}};
      EMA_int = {3{1'b0}};
      TEN_int = 1'b0;
      BEN_int = 1'b0;
      TCEN_int = 1'b0;
      TWEN_int = {4{1'b0}};
      TA_int = {9{1'b0}};
      TD_int = {32{1'b0}};
      TQ_int = {32{1'b0}};
      GWEN_int = 1'b0;
      TGWEN_int = 1'b0;
      RETN_int = 1'b0;
      PEN_int = 1'b0;
      TPEN_int = 1'b0;
    end else begin
      Q_int = {32{1'bx}};
      Q_stage1 = {32{1'bx}};
      PEN_prev = 1'bx;
      CEN_int = 1'bx;
      WEN_int = {4{1'bx}};
      A_int = {9{1'bx}};
      D_int = {32{1'bx}};
      EMA_int = {3{1'bx}};
      TEN_int = 1'bx;
      BEN_int = 1'bx;
      TCEN_int = 1'bx;
      TWEN_int = {4{1'bx}};
      TA_int = {9{1'bx}};
      TD_int = {32{1'bx}};
      TQ_int = {32{1'bx}};
      GWEN_int = 1'bx;
      TGWEN_int = 1'bx;
      RETN_int = 1'bx;
      PEN_int = 1'bx;
      TPEN_int = 1'bx;
    end
    RETN_int = RETN_;
  end

  always @ CLK_ begin
`ifdef POWER_PINS
    if (VSSE === 1'bx || VSSE === 1'bz)
      $display("ERROR: Illegal value for VSSE %b", VSSE);
    if (VDDPE === 1'bx || VDDPE === 1'bz)
      $display("ERROR: Illegal value for VDDPE %b", VDDPE);
    if (VDDCE === 1'bx || VDDCE === 1'bz)
      $display("ERROR: Illegal value for VDDCE %b", VDDCE);
`endif
    if (CLK_ === 1'bx && (TEN_ ? CEN_ !== 1'b1 : TCEN_ !== 1'b1)) begin
      failedWrite(0);
      Q_int = {32{1'bx}};
      Q_stage1 = {32{1'bx}};
    end else if (CLK_ === 1'b1 && LAST_CLK === 1'b0) begin
      PEN_prev = PEN_int;
      CEN_int = TEN_ ? CEN_ : TCEN_;
      WEN_int = TEN_ ? WEN_ : TWEN_;
      A_int = TEN_ ? A_ : TA_;
      D_int = TEN_ ? D_ : TD_;
      EMA_int = EMA_;
      TEN_int = TEN_;
      BEN_int = BEN_;
      TCEN_int = TCEN_;
      TWEN_int = TWEN_;
      TA_int = TA_;
      TD_int = TD_;
      TQ_int = TQ_;
      GWEN_int = TEN_ ? GWEN_ : TGWEN_;
      TGWEN_int = TGWEN_;
      RETN_int = RETN_;
      PEN_int = TEN_ ? PEN_ : TPEN_;
      TPEN_int = TPEN_;
      clk0_int = 1'b0;
    // PIPELINE stage 2
    if ((PEN_prev === 1'b0 || BEN_ === 1'b0) && (RETN_int === 1'b1))
      Q_int = BEN_int ? Q_stage1 : TQ_int;
    else if (PEN_prev === 1'bx )
      Q_int = {32{1'bx}};
 
      readWrite;
    end
    LAST_CLK = CLK_;
  end

  reg globalNotifier0;
  initial globalNotifier0 = 1'b0;

  always @ globalNotifier0 begin
    if ($realtime == 0) begin
    end else if (CEN_int === 1'bx || EMA_int[0] === 1'bx || EMA_int[1] === 1'bx || 
      EMA_int[2] === 1'bx || RETN_int === 1'bx || TEN_int === 1'bx || clk0_int === 1'bx) begin
      Q_stage1 = {32{1'bx}};
      failedWrite(0);
      if(clk0_int == 1'bx) begin
        Q_int = {32{1'bx}};
      end
    end else begin
      readWrite;
   end
    globalNotifier0 = 1'b0;
  end

  always @ NOT_A0 begin
    A_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TA0 begin
    A_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A1 begin
    A_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TA1 begin
    A_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A2 begin
    A_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TA2 begin
    A_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A3 begin
    A_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TA3 begin
    A_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A4 begin
    A_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TA4 begin
    A_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A5 begin
    A_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TA5 begin
    A_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A6 begin
    A_int[6] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TA6 begin
    A_int[6] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A7 begin
    A_int[7] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TA7 begin
    A_int[7] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A8 begin
    A_int[8] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TA8 begin
    A_int[8] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_BEN begin
    BEN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CEN begin
    CEN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D0 begin
    D_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD0 begin
    D_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D10 begin
    D_int[10] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD10 begin
    D_int[10] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D11 begin
    D_int[11] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD11 begin
    D_int[11] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D12 begin
    D_int[12] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD12 begin
    D_int[12] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D13 begin
    D_int[13] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD13 begin
    D_int[13] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D14 begin
    D_int[14] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD14 begin
    D_int[14] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D15 begin
    D_int[15] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD15 begin
    D_int[15] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D16 begin
    D_int[16] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD16 begin
    D_int[16] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D17 begin
    D_int[17] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD17 begin
    D_int[17] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D18 begin
    D_int[18] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD18 begin
    D_int[18] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D19 begin
    D_int[19] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD19 begin
    D_int[19] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D1 begin
    D_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD1 begin
    D_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D20 begin
    D_int[20] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD20 begin
    D_int[20] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D21 begin
    D_int[21] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD21 begin
    D_int[21] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D22 begin
    D_int[22] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD22 begin
    D_int[22] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D23 begin
    D_int[23] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD23 begin
    D_int[23] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D24 begin
    D_int[24] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD24 begin
    D_int[24] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D25 begin
    D_int[25] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD25 begin
    D_int[25] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D26 begin
    D_int[26] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD26 begin
    D_int[26] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D27 begin
    D_int[27] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD27 begin
    D_int[27] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D28 begin
    D_int[28] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD28 begin
    D_int[28] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D29 begin
    D_int[29] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD29 begin
    D_int[29] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D2 begin
    D_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD2 begin
    D_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D30 begin
    D_int[30] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD30 begin
    D_int[30] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D31 begin
    D_int[31] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD31 begin
    D_int[31] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D3 begin
    D_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD3 begin
    D_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D4 begin
    D_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD4 begin
    D_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D5 begin
    D_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD5 begin
    D_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D6 begin
    D_int[6] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD6 begin
    D_int[6] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D7 begin
    D_int[7] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD7 begin
    D_int[7] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D8 begin
    D_int[8] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD8 begin
    D_int[8] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D9 begin
    D_int[9] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TD9 begin
    D_int[9] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMA0 begin
    EMA_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMA1 begin
    EMA_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMA2 begin
    EMA_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_GWEN begin
    GWEN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TGWEN begin
    GWEN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_PEN begin
    PEN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TPEN begin
    PEN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_RETN begin
    RETN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TCEN begin
    CEN_int = 1'bx;
    if( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TEN begin
    TEN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ0 begin
    TQ_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ10 begin
    TQ_int[10] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ11 begin
    TQ_int[11] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ12 begin
    TQ_int[12] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ13 begin
    TQ_int[13] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ14 begin
    TQ_int[14] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ15 begin
    TQ_int[15] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ16 begin
    TQ_int[16] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ17 begin
    TQ_int[17] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ18 begin
    TQ_int[18] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ19 begin
    TQ_int[19] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ1 begin
    TQ_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ20 begin
    TQ_int[20] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ21 begin
    TQ_int[21] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ22 begin
    TQ_int[22] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ23 begin
    TQ_int[23] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ24 begin
    TQ_int[24] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ25 begin
    TQ_int[25] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ26 begin
    TQ_int[26] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ27 begin
    TQ_int[27] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ28 begin
    TQ_int[28] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ29 begin
    TQ_int[29] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ2 begin
    TQ_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ30 begin
    TQ_int[30] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ31 begin
    TQ_int[31] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ3 begin
    TQ_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ4 begin
    TQ_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ5 begin
    TQ_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ6 begin
    TQ_int[6] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ7 begin
    TQ_int[7] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ8 begin
    TQ_int[8] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TQ9 begin
    TQ_int[9] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TWEN0 begin
    WEN_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN0 begin
    WEN_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TWEN1 begin
    WEN_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN1 begin
    WEN_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TWEN2 begin
    WEN_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN2 begin
    WEN_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_TWEN3 begin
    WEN_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN3 begin
    WEN_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLK_MINH begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLK_MINL begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLK_PER begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end

  wire CEN_flag;
  wire flag;
  wire D_flag0;
  wire D_flag1;
  wire D_flag2;
  wire D_flag3;
  wire D_flag4;
  wire D_flag5;
  wire D_flag6;
  wire D_flag7;
  wire D_flag8;
  wire D_flag9;
  wire D_flag10;
  wire D_flag11;
  wire D_flag12;
  wire D_flag13;
  wire D_flag14;
  wire D_flag15;
  wire D_flag16;
  wire D_flag17;
  wire D_flag18;
  wire D_flag19;
  wire D_flag20;
  wire D_flag21;
  wire D_flag22;
  wire D_flag23;
  wire D_flag24;
  wire D_flag25;
  wire D_flag26;
  wire D_flag27;
  wire D_flag28;
  wire D_flag29;
  wire D_flag30;
  wire D_flag31;
  wire cyc_flag;
  wire TCEN_flag;
  wire tflag;
  wire TD_flag0;
  wire TD_flag1;
  wire TD_flag2;
  wire TD_flag3;
  wire TD_flag4;
  wire TD_flag5;
  wire TD_flag6;
  wire TD_flag7;
  wire TD_flag8;
  wire TD_flag9;
  wire TD_flag10;
  wire TD_flag11;
  wire TD_flag12;
  wire TD_flag13;
  wire TD_flag14;
  wire TD_flag15;
  wire TD_flag16;
  wire TD_flag17;
  wire TD_flag18;
  wire TD_flag19;
  wire TD_flag20;
  wire TD_flag21;
  wire TD_flag22;
  wire TD_flag23;
  wire TD_flag24;
  wire TD_flag25;
  wire TD_flag26;
  wire TD_flag27;
  wire TD_flag28;
  wire TD_flag29;
  wire TD_flag30;
  wire TD_flag31;
  wire BEN_flag;
  wire TQ_flag;
  wire EMA2eq0andEMA1eq0andEMA0eq0;
  wire EMA2eq0andEMA1eq0andEMA0eq1;
  wire EMA2eq0andEMA1eq1andEMA0eq0;
  wire EMA2eq0andEMA1eq1andEMA0eq1;
  wire EMA2eq1andEMA1eq0andEMA0eq0;
  wire EMA2eq1andEMA1eq0andEMA0eq1;
  wire EMA2eq1andEMA1eq1andEMA0eq0;
  wire EMA2eq1andEMA1eq1andEMA0eq1;
  assign CEN_flag = TEN_;
  assign flag = !(!TEN_ || CEN_);
  assign D_flag0 = !(!TEN_ ||  CEN_ || WEN_[0] || GWEN_);
  assign D_flag1 = !(!TEN_ ||  CEN_ || WEN_[0] || GWEN_);
  assign D_flag2 = !(!TEN_ ||  CEN_ || WEN_[0] || GWEN_);
  assign D_flag3 = !(!TEN_ ||  CEN_ || WEN_[0] || GWEN_);
  assign D_flag4 = !(!TEN_ ||  CEN_ || WEN_[0] || GWEN_);
  assign D_flag5 = !(!TEN_ ||  CEN_ || WEN_[0] || GWEN_);
  assign D_flag6 = !(!TEN_ ||  CEN_ || WEN_[0] || GWEN_);
  assign D_flag7 = !(!TEN_ ||  CEN_ || WEN_[0] || GWEN_);
  assign D_flag8 = !(!TEN_ ||  CEN_ || WEN_[1] || GWEN_);
  assign D_flag9 = !(!TEN_ ||  CEN_ || WEN_[1] || GWEN_);
  assign D_flag10 = !(!TEN_ ||  CEN_ || WEN_[1] || GWEN_);
  assign D_flag11 = !(!TEN_ ||  CEN_ || WEN_[1] || GWEN_);
  assign D_flag12 = !(!TEN_ ||  CEN_ || WEN_[1] || GWEN_);
  assign D_flag13 = !(!TEN_ ||  CEN_ || WEN_[1] || GWEN_);
  assign D_flag14 = !(!TEN_ ||  CEN_ || WEN_[1] || GWEN_);
  assign D_flag15 = !(!TEN_ ||  CEN_ || WEN_[1] || GWEN_);
  assign D_flag16 = !(!TEN_ ||  CEN_ || WEN_[2] || GWEN_);
  assign D_flag17 = !(!TEN_ ||  CEN_ || WEN_[2] || GWEN_);
  assign D_flag18 = !(!TEN_ ||  CEN_ || WEN_[2] || GWEN_);
  assign D_flag19 = !(!TEN_ ||  CEN_ || WEN_[2] || GWEN_);
  assign D_flag20 = !(!TEN_ ||  CEN_ || WEN_[2] || GWEN_);
  assign D_flag21 = !(!TEN_ ||  CEN_ || WEN_[2] || GWEN_);
  assign D_flag22 = !(!TEN_ ||  CEN_ || WEN_[2] || GWEN_);
  assign D_flag23 = !(!TEN_ ||  CEN_ || WEN_[2] || GWEN_);
  assign D_flag24 = !(!TEN_ ||  CEN_ || WEN_[3] || GWEN_);
  assign D_flag25 = !(!TEN_ ||  CEN_ || WEN_[3] || GWEN_);
  assign D_flag26 = !(!TEN_ ||  CEN_ || WEN_[3] || GWEN_);
  assign D_flag27 = !(!TEN_ ||  CEN_ || WEN_[3] || GWEN_);
  assign D_flag28 = !(!TEN_ ||  CEN_ || WEN_[3] || GWEN_);
  assign D_flag29 = !(!TEN_ ||  CEN_ || WEN_[3] || GWEN_);
  assign D_flag30 = !(!TEN_ ||  CEN_ || WEN_[3] || GWEN_);
  assign D_flag31 = !(!TEN_ ||  CEN_ || WEN_[3] || GWEN_);
  assign cyc_flag = !(TEN_ ? CEN_ : TCEN_);
  assign TCEN_flag = !(TEN_);
  assign tflag = !(TEN_ || TCEN_);
  assign TD_flag0 = !(TEN_ ||  TCEN_ || TWEN_[0] || TGWEN_);
  assign TD_flag1 = !(TEN_ ||  TCEN_ || TWEN_[0] || TGWEN_);
  assign TD_flag2 = !(TEN_ ||  TCEN_ || TWEN_[0] || TGWEN_);
  assign TD_flag3 = !(TEN_ ||  TCEN_ || TWEN_[0] || TGWEN_);
  assign TD_flag4 = !(TEN_ ||  TCEN_ || TWEN_[0] || TGWEN_);
  assign TD_flag5 = !(TEN_ ||  TCEN_ || TWEN_[0] || TGWEN_);
  assign TD_flag6 = !(TEN_ ||  TCEN_ || TWEN_[0] || TGWEN_);
  assign TD_flag7 = !(TEN_ ||  TCEN_ || TWEN_[0] || TGWEN_);
  assign TD_flag8 = !(TEN_ ||  TCEN_ || TWEN_[1] || TGWEN_);
  assign TD_flag9 = !(TEN_ ||  TCEN_ || TWEN_[1] || TGWEN_);
  assign TD_flag10 = !(TEN_ ||  TCEN_ || TWEN_[1] || TGWEN_);
  assign TD_flag11 = !(TEN_ ||  TCEN_ || TWEN_[1] || TGWEN_);
  assign TD_flag12 = !(TEN_ ||  TCEN_ || TWEN_[1] || TGWEN_);
  assign TD_flag13 = !(TEN_ ||  TCEN_ || TWEN_[1] || TGWEN_);
  assign TD_flag14 = !(TEN_ ||  TCEN_ || TWEN_[1] || TGWEN_);
  assign TD_flag15 = !(TEN_ ||  TCEN_ || TWEN_[1] || TGWEN_);
  assign TD_flag16 = !(TEN_ ||  TCEN_ || TWEN_[2] || TGWEN_);
  assign TD_flag17 = !(TEN_ ||  TCEN_ || TWEN_[2] || TGWEN_);
  assign TD_flag18 = !(TEN_ ||  TCEN_ || TWEN_[2] || TGWEN_);
  assign TD_flag19 = !(TEN_ ||  TCEN_ || TWEN_[2] || TGWEN_);
  assign TD_flag20 = !(TEN_ ||  TCEN_ || TWEN_[2] || TGWEN_);
  assign TD_flag21 = !(TEN_ ||  TCEN_ || TWEN_[2] || TGWEN_);
  assign TD_flag22 = !(TEN_ ||  TCEN_ || TWEN_[2] || TGWEN_);
  assign TD_flag23 = !(TEN_ ||  TCEN_ || TWEN_[2] || TGWEN_);
  assign TD_flag24 = !(TEN_ ||  TCEN_ || TWEN_[3] || TGWEN_);
  assign TD_flag25 = !(TEN_ ||  TCEN_ || TWEN_[3] || TGWEN_);
  assign TD_flag26 = !(TEN_ ||  TCEN_ || TWEN_[3] || TGWEN_);
  assign TD_flag27 = !(TEN_ ||  TCEN_ || TWEN_[3] || TGWEN_);
  assign TD_flag28 = !(TEN_ ||  TCEN_ || TWEN_[3] || TGWEN_);
  assign TD_flag29 = !(TEN_ ||  TCEN_ || TWEN_[3] || TGWEN_);
  assign TD_flag30 = !(TEN_ ||  TCEN_ || TWEN_[3] || TGWEN_);
  assign TD_flag31 = !(TEN_ ||  TCEN_ || TWEN_[3] || TGWEN_);
  assign BEN_flag = !(TEN_ ? PEN_ : TPEN_ );
  assign TQ_flag = !(BEN_ | (TEN_ ? PEN_ : TPEN_ ));
  assign EMA2eq0andEMA1eq0andEMA0eq0 = !EMA_[2] && !EMA_[1] && !EMA_[0] && cyc_flag;
  assign EMA2eq0andEMA1eq0andEMA0eq1 = !EMA_[2] && !EMA_[1] && EMA_[0] && cyc_flag;
  assign EMA2eq0andEMA1eq1andEMA0eq0 = !EMA_[2] && EMA_[1] && !EMA_[0] && cyc_flag;
  assign EMA2eq0andEMA1eq1andEMA0eq1 = !EMA_[2] && EMA_[1] && EMA_[0] && cyc_flag;
  assign EMA2eq1andEMA1eq0andEMA0eq0 = EMA_[2] && !EMA_[1] && !EMA_[0] && cyc_flag;
  assign EMA2eq1andEMA1eq0andEMA0eq1 = EMA_[2] && !EMA_[1] && EMA_[0] && cyc_flag;
  assign EMA2eq1andEMA1eq1andEMA0eq0 = EMA_[2] && EMA_[1] && !EMA_[0] && cyc_flag;
  assign EMA2eq1andEMA1eq1andEMA0eq1 = EMA_[2] && EMA_[1] && EMA_[0] && cyc_flag;

  specify
      $hold(posedge CEN, negedge RETN, 1.000, NOT_RETN);
      $setuphold(posedge CLK &&& CEN_flag, posedge CEN, 1.000, 0.500, NOT_CEN);
      $setuphold(posedge CLK &&& CEN_flag, negedge CEN, 1.000, 0.500, NOT_CEN);
      $setuphold(posedge CLK &&& flag, posedge WEN[3], 1.000, 0.500, NOT_WEN3);
      $setuphold(posedge CLK &&& flag, negedge WEN[3], 1.000, 0.500, NOT_WEN3);
      $setuphold(posedge CLK &&& flag, posedge WEN[2], 1.000, 0.500, NOT_WEN2);
      $setuphold(posedge CLK &&& flag, negedge WEN[2], 1.000, 0.500, NOT_WEN2);
      $setuphold(posedge CLK &&& flag, posedge WEN[1], 1.000, 0.500, NOT_WEN1);
      $setuphold(posedge CLK &&& flag, negedge WEN[1], 1.000, 0.500, NOT_WEN1);
      $setuphold(posedge CLK &&& flag, posedge WEN[0], 1.000, 0.500, NOT_WEN0);
      $setuphold(posedge CLK &&& flag, negedge WEN[0], 1.000, 0.500, NOT_WEN0);
      $setuphold(posedge CLK &&& flag, posedge GWEN, 1.000, 0.500, NOT_GWEN);
      $setuphold(posedge CLK &&& flag, negedge GWEN, 1.000, 0.500, NOT_GWEN);
      $setuphold(posedge CLK &&& flag, posedge A[8], 1.000, 0.500, NOT_A8);
      $setuphold(posedge CLK &&& flag, negedge A[8], 1.000, 0.500, NOT_A8);
      $setuphold(posedge CLK &&& flag, posedge A[7], 1.000, 0.500, NOT_A7);
      $setuphold(posedge CLK &&& flag, negedge A[7], 1.000, 0.500, NOT_A7);
      $setuphold(posedge CLK &&& flag, posedge A[6], 1.000, 0.500, NOT_A6);
      $setuphold(posedge CLK &&& flag, negedge A[6], 1.000, 0.500, NOT_A6);
      $setuphold(posedge CLK &&& flag, posedge A[5], 1.000, 0.500, NOT_A5);
      $setuphold(posedge CLK &&& flag, negedge A[5], 1.000, 0.500, NOT_A5);
      $setuphold(posedge CLK &&& flag, posedge A[4], 1.000, 0.500, NOT_A4);
      $setuphold(posedge CLK &&& flag, negedge A[4], 1.000, 0.500, NOT_A4);
      $setuphold(posedge CLK &&& flag, posedge A[3], 1.000, 0.500, NOT_A3);
      $setuphold(posedge CLK &&& flag, negedge A[3], 1.000, 0.500, NOT_A3);
      $setuphold(posedge CLK &&& flag, posedge A[2], 1.000, 0.500, NOT_A2);
      $setuphold(posedge CLK &&& flag, negedge A[2], 1.000, 0.500, NOT_A2);
      $setuphold(posedge CLK &&& flag, posedge A[1], 1.000, 0.500, NOT_A1);
      $setuphold(posedge CLK &&& flag, negedge A[1], 1.000, 0.500, NOT_A1);
      $setuphold(posedge CLK &&& flag, posedge A[0], 1.000, 0.500, NOT_A0);
      $setuphold(posedge CLK &&& flag, negedge A[0], 1.000, 0.500, NOT_A0);
      $setuphold(posedge CLK &&& D_flag31, posedge D[31], 1.000, 0.500, NOT_D31);
      $setuphold(posedge CLK &&& D_flag31, negedge D[31], 1.000, 0.500, NOT_D31);
      $setuphold(posedge CLK &&& D_flag30, posedge D[30], 1.000, 0.500, NOT_D30);
      $setuphold(posedge CLK &&& D_flag30, negedge D[30], 1.000, 0.500, NOT_D30);
      $setuphold(posedge CLK &&& D_flag29, posedge D[29], 1.000, 0.500, NOT_D29);
      $setuphold(posedge CLK &&& D_flag29, negedge D[29], 1.000, 0.500, NOT_D29);
      $setuphold(posedge CLK &&& D_flag28, posedge D[28], 1.000, 0.500, NOT_D28);
      $setuphold(posedge CLK &&& D_flag28, negedge D[28], 1.000, 0.500, NOT_D28);
      $setuphold(posedge CLK &&& D_flag27, posedge D[27], 1.000, 0.500, NOT_D27);
      $setuphold(posedge CLK &&& D_flag27, negedge D[27], 1.000, 0.500, NOT_D27);
      $setuphold(posedge CLK &&& D_flag26, posedge D[26], 1.000, 0.500, NOT_D26);
      $setuphold(posedge CLK &&& D_flag26, negedge D[26], 1.000, 0.500, NOT_D26);
      $setuphold(posedge CLK &&& D_flag25, posedge D[25], 1.000, 0.500, NOT_D25);
      $setuphold(posedge CLK &&& D_flag25, negedge D[25], 1.000, 0.500, NOT_D25);
      $setuphold(posedge CLK &&& D_flag24, posedge D[24], 1.000, 0.500, NOT_D24);
      $setuphold(posedge CLK &&& D_flag24, negedge D[24], 1.000, 0.500, NOT_D24);
      $setuphold(posedge CLK &&& D_flag23, posedge D[23], 1.000, 0.500, NOT_D23);
      $setuphold(posedge CLK &&& D_flag23, negedge D[23], 1.000, 0.500, NOT_D23);
      $setuphold(posedge CLK &&& D_flag22, posedge D[22], 1.000, 0.500, NOT_D22);
      $setuphold(posedge CLK &&& D_flag22, negedge D[22], 1.000, 0.500, NOT_D22);
      $setuphold(posedge CLK &&& D_flag21, posedge D[21], 1.000, 0.500, NOT_D21);
      $setuphold(posedge CLK &&& D_flag21, negedge D[21], 1.000, 0.500, NOT_D21);
      $setuphold(posedge CLK &&& D_flag20, posedge D[20], 1.000, 0.500, NOT_D20);
      $setuphold(posedge CLK &&& D_flag20, negedge D[20], 1.000, 0.500, NOT_D20);
      $setuphold(posedge CLK &&& D_flag19, posedge D[19], 1.000, 0.500, NOT_D19);
      $setuphold(posedge CLK &&& D_flag19, negedge D[19], 1.000, 0.500, NOT_D19);
      $setuphold(posedge CLK &&& D_flag18, posedge D[18], 1.000, 0.500, NOT_D18);
      $setuphold(posedge CLK &&& D_flag18, negedge D[18], 1.000, 0.500, NOT_D18);
      $setuphold(posedge CLK &&& D_flag17, posedge D[17], 1.000, 0.500, NOT_D17);
      $setuphold(posedge CLK &&& D_flag17, negedge D[17], 1.000, 0.500, NOT_D17);
      $setuphold(posedge CLK &&& D_flag16, posedge D[16], 1.000, 0.500, NOT_D16);
      $setuphold(posedge CLK &&& D_flag16, negedge D[16], 1.000, 0.500, NOT_D16);
      $setuphold(posedge CLK &&& D_flag15, posedge D[15], 1.000, 0.500, NOT_D15);
      $setuphold(posedge CLK &&& D_flag15, negedge D[15], 1.000, 0.500, NOT_D15);
      $setuphold(posedge CLK &&& D_flag14, posedge D[14], 1.000, 0.500, NOT_D14);
      $setuphold(posedge CLK &&& D_flag14, negedge D[14], 1.000, 0.500, NOT_D14);
      $setuphold(posedge CLK &&& D_flag13, posedge D[13], 1.000, 0.500, NOT_D13);
      $setuphold(posedge CLK &&& D_flag13, negedge D[13], 1.000, 0.500, NOT_D13);
      $setuphold(posedge CLK &&& D_flag12, posedge D[12], 1.000, 0.500, NOT_D12);
      $setuphold(posedge CLK &&& D_flag12, negedge D[12], 1.000, 0.500, NOT_D12);
      $setuphold(posedge CLK &&& D_flag11, posedge D[11], 1.000, 0.500, NOT_D11);
      $setuphold(posedge CLK &&& D_flag11, negedge D[11], 1.000, 0.500, NOT_D11);
      $setuphold(posedge CLK &&& D_flag10, posedge D[10], 1.000, 0.500, NOT_D10);
      $setuphold(posedge CLK &&& D_flag10, negedge D[10], 1.000, 0.500, NOT_D10);
      $setuphold(posedge CLK &&& D_flag9, posedge D[9], 1.000, 0.500, NOT_D9);
      $setuphold(posedge CLK &&& D_flag9, negedge D[9], 1.000, 0.500, NOT_D9);
      $setuphold(posedge CLK &&& D_flag8, posedge D[8], 1.000, 0.500, NOT_D8);
      $setuphold(posedge CLK &&& D_flag8, negedge D[8], 1.000, 0.500, NOT_D8);
      $setuphold(posedge CLK &&& D_flag7, posedge D[7], 1.000, 0.500, NOT_D7);
      $setuphold(posedge CLK &&& D_flag7, negedge D[7], 1.000, 0.500, NOT_D7);
      $setuphold(posedge CLK &&& D_flag6, posedge D[6], 1.000, 0.500, NOT_D6);
      $setuphold(posedge CLK &&& D_flag6, negedge D[6], 1.000, 0.500, NOT_D6);
      $setuphold(posedge CLK &&& D_flag5, posedge D[5], 1.000, 0.500, NOT_D5);
      $setuphold(posedge CLK &&& D_flag5, negedge D[5], 1.000, 0.500, NOT_D5);
      $setuphold(posedge CLK &&& D_flag4, posedge D[4], 1.000, 0.500, NOT_D4);
      $setuphold(posedge CLK &&& D_flag4, negedge D[4], 1.000, 0.500, NOT_D4);
      $setuphold(posedge CLK &&& D_flag3, posedge D[3], 1.000, 0.500, NOT_D3);
      $setuphold(posedge CLK &&& D_flag3, negedge D[3], 1.000, 0.500, NOT_D3);
      $setuphold(posedge CLK &&& D_flag2, posedge D[2], 1.000, 0.500, NOT_D2);
      $setuphold(posedge CLK &&& D_flag2, negedge D[2], 1.000, 0.500, NOT_D2);
      $setuphold(posedge CLK &&& D_flag1, posedge D[1], 1.000, 0.500, NOT_D1);
      $setuphold(posedge CLK &&& D_flag1, negedge D[1], 1.000, 0.500, NOT_D1);
      $setuphold(posedge CLK &&& D_flag0, posedge D[0], 1.000, 0.500, NOT_D0);
      $setuphold(posedge CLK &&& D_flag0, negedge D[0], 1.000, 0.500, NOT_D0);
      $setuphold(posedge CLK &&& cyc_flag, posedge EMA[2], 1.000, 0.500, NOT_EMA2);
      $setuphold(posedge CLK &&& cyc_flag, negedge EMA[2], 1.000, 0.500, NOT_EMA2);
      $setuphold(posedge CLK &&& cyc_flag, posedge EMA[1], 1.000, 0.500, NOT_EMA1);
      $setuphold(posedge CLK &&& cyc_flag, negedge EMA[1], 1.000, 0.500, NOT_EMA1);
      $setuphold(posedge CLK &&& cyc_flag, posedge EMA[0], 1.000, 0.500, NOT_EMA0);
      $setuphold(posedge CLK &&& cyc_flag, negedge EMA[0], 1.000, 0.500, NOT_EMA0);
      $setuphold(posedge CLK, posedge TEN, 1.000, 0.500, NOT_TEN);
      $setuphold(posedge CLK, negedge TEN, 1.000, 0.500, NOT_TEN);
      $setuphold(posedge CLK &&& TCEN_flag, posedge TCEN, 1.000, 0.500, NOT_TCEN);
      $setuphold(posedge CLK &&& TCEN_flag, negedge TCEN, 1.000, 0.500, NOT_TCEN);
      $setuphold(posedge CLK &&& tflag, posedge TWEN[3], 1.000, 0.500, NOT_TWEN3);
      $setuphold(posedge CLK &&& tflag, negedge TWEN[3], 1.000, 0.500, NOT_TWEN3);
      $setuphold(posedge CLK &&& tflag, posedge TWEN[2], 1.000, 0.500, NOT_TWEN2);
      $setuphold(posedge CLK &&& tflag, negedge TWEN[2], 1.000, 0.500, NOT_TWEN2);
      $setuphold(posedge CLK &&& tflag, posedge TWEN[1], 1.000, 0.500, NOT_TWEN1);
      $setuphold(posedge CLK &&& tflag, negedge TWEN[1], 1.000, 0.500, NOT_TWEN1);
      $setuphold(posedge CLK &&& tflag, posedge TWEN[0], 1.000, 0.500, NOT_TWEN0);
      $setuphold(posedge CLK &&& tflag, negedge TWEN[0], 1.000, 0.500, NOT_TWEN0);
      $setuphold(posedge CLK &&& tflag, posedge TGWEN, 1.000, 0.500, NOT_TGWEN);
      $setuphold(posedge CLK &&& tflag, negedge TGWEN, 1.000, 0.500, NOT_TGWEN);
      $setuphold(posedge CLK &&& tflag, posedge TA[8], 1.000, 0.500, NOT_TA8);
      $setuphold(posedge CLK &&& tflag, negedge TA[8], 1.000, 0.500, NOT_TA8);
      $setuphold(posedge CLK &&& tflag, posedge TA[7], 1.000, 0.500, NOT_TA7);
      $setuphold(posedge CLK &&& tflag, negedge TA[7], 1.000, 0.500, NOT_TA7);
      $setuphold(posedge CLK &&& tflag, posedge TA[6], 1.000, 0.500, NOT_TA6);
      $setuphold(posedge CLK &&& tflag, negedge TA[6], 1.000, 0.500, NOT_TA6);
      $setuphold(posedge CLK &&& tflag, posedge TA[5], 1.000, 0.500, NOT_TA5);
      $setuphold(posedge CLK &&& tflag, negedge TA[5], 1.000, 0.500, NOT_TA5);
      $setuphold(posedge CLK &&& tflag, posedge TA[4], 1.000, 0.500, NOT_TA4);
      $setuphold(posedge CLK &&& tflag, negedge TA[4], 1.000, 0.500, NOT_TA4);
      $setuphold(posedge CLK &&& tflag, posedge TA[3], 1.000, 0.500, NOT_TA3);
      $setuphold(posedge CLK &&& tflag, negedge TA[3], 1.000, 0.500, NOT_TA3);
      $setuphold(posedge CLK &&& tflag, posedge TA[2], 1.000, 0.500, NOT_TA2);
      $setuphold(posedge CLK &&& tflag, negedge TA[2], 1.000, 0.500, NOT_TA2);
      $setuphold(posedge CLK &&& tflag, posedge TA[1], 1.000, 0.500, NOT_TA1);
      $setuphold(posedge CLK &&& tflag, negedge TA[1], 1.000, 0.500, NOT_TA1);
      $setuphold(posedge CLK &&& tflag, posedge TA[0], 1.000, 0.500, NOT_TA0);
      $setuphold(posedge CLK &&& tflag, negedge TA[0], 1.000, 0.500, NOT_TA0);
      $setuphold(posedge CLK &&& TD_flag31, posedge TD[31], 1.000, 0.500, NOT_TD31);
      $setuphold(posedge CLK &&& TD_flag31, negedge TD[31], 1.000, 0.500, NOT_TD31);
      $setuphold(posedge CLK &&& TD_flag30, posedge TD[30], 1.000, 0.500, NOT_TD30);
      $setuphold(posedge CLK &&& TD_flag30, negedge TD[30], 1.000, 0.500, NOT_TD30);
      $setuphold(posedge CLK &&& TD_flag29, posedge TD[29], 1.000, 0.500, NOT_TD29);
      $setuphold(posedge CLK &&& TD_flag29, negedge TD[29], 1.000, 0.500, NOT_TD29);
      $setuphold(posedge CLK &&& TD_flag28, posedge TD[28], 1.000, 0.500, NOT_TD28);
      $setuphold(posedge CLK &&& TD_flag28, negedge TD[28], 1.000, 0.500, NOT_TD28);
      $setuphold(posedge CLK &&& TD_flag27, posedge TD[27], 1.000, 0.500, NOT_TD27);
      $setuphold(posedge CLK &&& TD_flag27, negedge TD[27], 1.000, 0.500, NOT_TD27);
      $setuphold(posedge CLK &&& TD_flag26, posedge TD[26], 1.000, 0.500, NOT_TD26);
      $setuphold(posedge CLK &&& TD_flag26, negedge TD[26], 1.000, 0.500, NOT_TD26);
      $setuphold(posedge CLK &&& TD_flag25, posedge TD[25], 1.000, 0.500, NOT_TD25);
      $setuphold(posedge CLK &&& TD_flag25, negedge TD[25], 1.000, 0.500, NOT_TD25);
      $setuphold(posedge CLK &&& TD_flag24, posedge TD[24], 1.000, 0.500, NOT_TD24);
      $setuphold(posedge CLK &&& TD_flag24, negedge TD[24], 1.000, 0.500, NOT_TD24);
      $setuphold(posedge CLK &&& TD_flag23, posedge TD[23], 1.000, 0.500, NOT_TD23);
      $setuphold(posedge CLK &&& TD_flag23, negedge TD[23], 1.000, 0.500, NOT_TD23);
      $setuphold(posedge CLK &&& TD_flag22, posedge TD[22], 1.000, 0.500, NOT_TD22);
      $setuphold(posedge CLK &&& TD_flag22, negedge TD[22], 1.000, 0.500, NOT_TD22);
      $setuphold(posedge CLK &&& TD_flag21, posedge TD[21], 1.000, 0.500, NOT_TD21);
      $setuphold(posedge CLK &&& TD_flag21, negedge TD[21], 1.000, 0.500, NOT_TD21);
      $setuphold(posedge CLK &&& TD_flag20, posedge TD[20], 1.000, 0.500, NOT_TD20);
      $setuphold(posedge CLK &&& TD_flag20, negedge TD[20], 1.000, 0.500, NOT_TD20);
      $setuphold(posedge CLK &&& TD_flag19, posedge TD[19], 1.000, 0.500, NOT_TD19);
      $setuphold(posedge CLK &&& TD_flag19, negedge TD[19], 1.000, 0.500, NOT_TD19);
      $setuphold(posedge CLK &&& TD_flag18, posedge TD[18], 1.000, 0.500, NOT_TD18);
      $setuphold(posedge CLK &&& TD_flag18, negedge TD[18], 1.000, 0.500, NOT_TD18);
      $setuphold(posedge CLK &&& TD_flag17, posedge TD[17], 1.000, 0.500, NOT_TD17);
      $setuphold(posedge CLK &&& TD_flag17, negedge TD[17], 1.000, 0.500, NOT_TD17);
      $setuphold(posedge CLK &&& TD_flag16, posedge TD[16], 1.000, 0.500, NOT_TD16);
      $setuphold(posedge CLK &&& TD_flag16, negedge TD[16], 1.000, 0.500, NOT_TD16);
      $setuphold(posedge CLK &&& TD_flag15, posedge TD[15], 1.000, 0.500, NOT_TD15);
      $setuphold(posedge CLK &&& TD_flag15, negedge TD[15], 1.000, 0.500, NOT_TD15);
      $setuphold(posedge CLK &&& TD_flag14, posedge TD[14], 1.000, 0.500, NOT_TD14);
      $setuphold(posedge CLK &&& TD_flag14, negedge TD[14], 1.000, 0.500, NOT_TD14);
      $setuphold(posedge CLK &&& TD_flag13, posedge TD[13], 1.000, 0.500, NOT_TD13);
      $setuphold(posedge CLK &&& TD_flag13, negedge TD[13], 1.000, 0.500, NOT_TD13);
      $setuphold(posedge CLK &&& TD_flag12, posedge TD[12], 1.000, 0.500, NOT_TD12);
      $setuphold(posedge CLK &&& TD_flag12, negedge TD[12], 1.000, 0.500, NOT_TD12);
      $setuphold(posedge CLK &&& TD_flag11, posedge TD[11], 1.000, 0.500, NOT_TD11);
      $setuphold(posedge CLK &&& TD_flag11, negedge TD[11], 1.000, 0.500, NOT_TD11);
      $setuphold(posedge CLK &&& TD_flag10, posedge TD[10], 1.000, 0.500, NOT_TD10);
      $setuphold(posedge CLK &&& TD_flag10, negedge TD[10], 1.000, 0.500, NOT_TD10);
      $setuphold(posedge CLK &&& TD_flag9, posedge TD[9], 1.000, 0.500, NOT_TD9);
      $setuphold(posedge CLK &&& TD_flag9, negedge TD[9], 1.000, 0.500, NOT_TD9);
      $setuphold(posedge CLK &&& TD_flag8, posedge TD[8], 1.000, 0.500, NOT_TD8);
      $setuphold(posedge CLK &&& TD_flag8, negedge TD[8], 1.000, 0.500, NOT_TD8);
      $setuphold(posedge CLK &&& TD_flag7, posedge TD[7], 1.000, 0.500, NOT_TD7);
      $setuphold(posedge CLK &&& TD_flag7, negedge TD[7], 1.000, 0.500, NOT_TD7);
      $setuphold(posedge CLK &&& TD_flag6, posedge TD[6], 1.000, 0.500, NOT_TD6);
      $setuphold(posedge CLK &&& TD_flag6, negedge TD[6], 1.000, 0.500, NOT_TD6);
      $setuphold(posedge CLK &&& TD_flag5, posedge TD[5], 1.000, 0.500, NOT_TD5);
      $setuphold(posedge CLK &&& TD_flag5, negedge TD[5], 1.000, 0.500, NOT_TD5);
      $setuphold(posedge CLK &&& TD_flag4, posedge TD[4], 1.000, 0.500, NOT_TD4);
      $setuphold(posedge CLK &&& TD_flag4, negedge TD[4], 1.000, 0.500, NOT_TD4);
      $setuphold(posedge CLK &&& TD_flag3, posedge TD[3], 1.000, 0.500, NOT_TD3);
      $setuphold(posedge CLK &&& TD_flag3, negedge TD[3], 1.000, 0.500, NOT_TD3);
      $setuphold(posedge CLK &&& TD_flag2, posedge TD[2], 1.000, 0.500, NOT_TD2);
      $setuphold(posedge CLK &&& TD_flag2, negedge TD[2], 1.000, 0.500, NOT_TD2);
      $setuphold(posedge CLK &&& TD_flag1, posedge TD[1], 1.000, 0.500, NOT_TD1);
      $setuphold(posedge CLK &&& TD_flag1, negedge TD[1], 1.000, 0.500, NOT_TD1);
      $setuphold(posedge CLK &&& TD_flag0, posedge TD[0], 1.000, 0.500, NOT_TD0);
      $setuphold(posedge CLK &&& TD_flag0, negedge TD[0], 1.000, 0.500, NOT_TD0);
      $setuphold(posedge CLK &&& BEN_flag, posedge BEN, 1.000, 0.500, NOT_BEN);
      $setuphold(posedge CLK &&& BEN_flag, negedge BEN, 1.000, 0.500, NOT_BEN);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[31], 1.000, 0.500, NOT_TQ31);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[31], 1.000, 0.500, NOT_TQ31);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[30], 1.000, 0.500, NOT_TQ30);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[30], 1.000, 0.500, NOT_TQ30);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[29], 1.000, 0.500, NOT_TQ29);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[29], 1.000, 0.500, NOT_TQ29);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[28], 1.000, 0.500, NOT_TQ28);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[28], 1.000, 0.500, NOT_TQ28);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[27], 1.000, 0.500, NOT_TQ27);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[27], 1.000, 0.500, NOT_TQ27);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[26], 1.000, 0.500, NOT_TQ26);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[26], 1.000, 0.500, NOT_TQ26);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[25], 1.000, 0.500, NOT_TQ25);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[25], 1.000, 0.500, NOT_TQ25);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[24], 1.000, 0.500, NOT_TQ24);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[24], 1.000, 0.500, NOT_TQ24);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[23], 1.000, 0.500, NOT_TQ23);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[23], 1.000, 0.500, NOT_TQ23);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[22], 1.000, 0.500, NOT_TQ22);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[22], 1.000, 0.500, NOT_TQ22);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[21], 1.000, 0.500, NOT_TQ21);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[21], 1.000, 0.500, NOT_TQ21);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[20], 1.000, 0.500, NOT_TQ20);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[20], 1.000, 0.500, NOT_TQ20);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[19], 1.000, 0.500, NOT_TQ19);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[19], 1.000, 0.500, NOT_TQ19);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[18], 1.000, 0.500, NOT_TQ18);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[18], 1.000, 0.500, NOT_TQ18);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[17], 1.000, 0.500, NOT_TQ17);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[17], 1.000, 0.500, NOT_TQ17);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[16], 1.000, 0.500, NOT_TQ16);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[16], 1.000, 0.500, NOT_TQ16);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[15], 1.000, 0.500, NOT_TQ15);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[15], 1.000, 0.500, NOT_TQ15);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[14], 1.000, 0.500, NOT_TQ14);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[14], 1.000, 0.500, NOT_TQ14);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[13], 1.000, 0.500, NOT_TQ13);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[13], 1.000, 0.500, NOT_TQ13);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[12], 1.000, 0.500, NOT_TQ12);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[12], 1.000, 0.500, NOT_TQ12);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[11], 1.000, 0.500, NOT_TQ11);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[11], 1.000, 0.500, NOT_TQ11);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[10], 1.000, 0.500, NOT_TQ10);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[10], 1.000, 0.500, NOT_TQ10);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[9], 1.000, 0.500, NOT_TQ9);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[9], 1.000, 0.500, NOT_TQ9);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[8], 1.000, 0.500, NOT_TQ8);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[8], 1.000, 0.500, NOT_TQ8);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[7], 1.000, 0.500, NOT_TQ7);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[7], 1.000, 0.500, NOT_TQ7);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[6], 1.000, 0.500, NOT_TQ6);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[6], 1.000, 0.500, NOT_TQ6);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[5], 1.000, 0.500, NOT_TQ5);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[5], 1.000, 0.500, NOT_TQ5);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[4], 1.000, 0.500, NOT_TQ4);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[4], 1.000, 0.500, NOT_TQ4);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[3], 1.000, 0.500, NOT_TQ3);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[3], 1.000, 0.500, NOT_TQ3);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[2], 1.000, 0.500, NOT_TQ2);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[2], 1.000, 0.500, NOT_TQ2);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[1], 1.000, 0.500, NOT_TQ1);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[1], 1.000, 0.500, NOT_TQ1);
      $setuphold(posedge CLK &&& TQ_flag, posedge TQ[0], 1.000, 0.500, NOT_TQ0);
      $setuphold(posedge CLK &&& TQ_flag, negedge TQ[0], 1.000, 0.500, NOT_TQ0);
      $setuphold(posedge CLK &&& CEN_flag, posedge PEN, 1.000, 0.500, NOT_PEN);
      $setuphold(posedge CLK &&& CEN_flag, negedge PEN, 1.000, 0.500, NOT_PEN);
      $setuphold(posedge CLK &&& TCEN_flag, posedge TPEN, 1.000, 0.500, NOT_TPEN);
      $setuphold(posedge CLK &&& TCEN_flag, negedge TPEN, 1.000, 0.500, NOT_TPEN);
      $setuphold(posedge CLK, posedge RETN, 1.000, 0.500, NOT_RETN);
      $setuphold(posedge CLK, negedge RETN, 1.000, 0.500, NOT_RETN);
      $hold(posedge RETN, negedge CEN, 1.000, NOT_RETN);

      $width(posedge CLK &&& cyc_flag, 1.000, 0, NOT_CLK_MINH);
      $width(negedge CLK &&& cyc_flag, 1.000, 0, NOT_CLK_MINL);
`ifdef NO_SDTC
      $period(posedge CLK  &&& cyc_flag, 3.000, NOT_CLK_PER);
`else
      $period(posedge CLK &&& EMA2eq0andEMA1eq0andEMA0eq0, 3.000, NOT_CLK_PER);
      $period(posedge CLK &&& EMA2eq0andEMA1eq0andEMA0eq1, 3.000, NOT_CLK_PER);
      $period(posedge CLK &&& EMA2eq0andEMA1eq1andEMA0eq0, 3.000, NOT_CLK_PER);
      $period(posedge CLK &&& EMA2eq0andEMA1eq1andEMA0eq1, 3.000, NOT_CLK_PER);
      $period(posedge CLK &&& EMA2eq1andEMA1eq0andEMA0eq0, 3.000, NOT_CLK_PER);
      $period(posedge CLK &&& EMA2eq1andEMA1eq0andEMA0eq1, 3.000, NOT_CLK_PER);
      $period(posedge CLK &&& EMA2eq1andEMA1eq1andEMA0eq0, 3.000, NOT_CLK_PER);
      $period(posedge CLK &&& EMA2eq1andEMA1eq1andEMA0eq1, 3.000, NOT_CLK_PER);
`endif

      (posedge CLK => (Q[31]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[31]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[31]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[31]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[31]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[31]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[31]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[31]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[31]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[30]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[30]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[30]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[30]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[30]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[30]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[30]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[30]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[30]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[29]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[29]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[29]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[29]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[29]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[29]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[29]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[29]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[29]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[28]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[28]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[28]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[28]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[28]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[28]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[28]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[28]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[28]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[27]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[27]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[27]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[27]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[27]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[27]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[27]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[27]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[27]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[26]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[26]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[26]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[26]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[26]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[26]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[26]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[26]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[26]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[25]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[25]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[25]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[25]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[25]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[25]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[25]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[25]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[25]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[24]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[24]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[24]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[24]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[24]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[24]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[24]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[24]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[24]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[23]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[23]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[23]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[23]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[23]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[23]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[23]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[23]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[23]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[22]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[22]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[22]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[22]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[22]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[22]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[22]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[22]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[22]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[21]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[21]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[21]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[21]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[21]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[21]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[21]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[21]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[21]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[20]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[20]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[20]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[20]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[20]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[20]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[20]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[20]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[20]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[19]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[19]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[19]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[19]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[19]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[19]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[19]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[19]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[19]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[18]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[18]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[18]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[18]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[18]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[18]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[18]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[18]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[18]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[17]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[17]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[17]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[17]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[17]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[17]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[17]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[17]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[17]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[16]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[16]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[16]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[16]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[16]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[16]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[16]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[16]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[16]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[15]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[15]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[15]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[15]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[15]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[15]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[15]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[15]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[15]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[14]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[14]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[14]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[14]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[14]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[14]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[14]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[14]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[14]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[13]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[13]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[13]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[13]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[13]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[13]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[13]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[13]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[13]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[12]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[12]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[12]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[12]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[12]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[12]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[12]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[12]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[12]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[11]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[11]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[11]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[11]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[11]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[11]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[11]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[11]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[11]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[10]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[10]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[10]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[10]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[10]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[10]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[10]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[10]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[10]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[9]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[9]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[9]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[9]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[9]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[9]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[9]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[9]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[9]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[8]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[8]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[8]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[8]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[8]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[8]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[8]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[8]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[8]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[7]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[7]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[7]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[7]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[7]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[7]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[7]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[7]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[7]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[6]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[6]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[6]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[6]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[6]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[6]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[6]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[6]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[6]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[5]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[5]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[5]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[5]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[5]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[5]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[5]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[5]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[5]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[4]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[4]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[4]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[4]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[4]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[4]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[4]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[4]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[4]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[3]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[3]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[3]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[3]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[3]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[3]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[3]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[3]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[3]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[2]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[2]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[2]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[2]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[2]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[2]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[2]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[2]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[2]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[1]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[1]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[1]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[1]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[1]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[1]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[1]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[1]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[1]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[0]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[0]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[0]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[0]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[0]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[0]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[0]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (QI[0]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (QI[0]:1'b0))=(1.000, 1.000);
      (TEN => CENY)=(1.000, 1.000);
      (CLK => PENY)=(1.000, 1.000);
      (TEN => WENY[3])=(1.000, 1.000);
      (TEN => WENY[2])=(1.000, 1.000);
      (TEN => WENY[1])=(1.000, 1.000);
      (TEN => WENY[0])=(1.000, 1.000);
      (TEN => GWENY)=(1.000, 1.000);
      (TEN => AY[8])=(1.000, 1.000);
      (TEN => AY[7])=(1.000, 1.000);
      (TEN => AY[6])=(1.000, 1.000);
      (TEN => AY[5])=(1.000, 1.000);
      (TEN => AY[4])=(1.000, 1.000);
      (TEN => AY[3])=(1.000, 1.000);
      (TEN => AY[2])=(1.000, 1.000);
      (TEN => AY[1])=(1.000, 1.000);
      (TEN => AY[0])=(1.000, 1.000);
      (TEN => DY[31])=(1.000, 1.000);
      (TEN => DY[30])=(1.000, 1.000);
      (TEN => DY[29])=(1.000, 1.000);
      (TEN => DY[28])=(1.000, 1.000);
      (TEN => DY[27])=(1.000, 1.000);
      (TEN => DY[26])=(1.000, 1.000);
      (TEN => DY[25])=(1.000, 1.000);
      (TEN => DY[24])=(1.000, 1.000);
      (TEN => DY[23])=(1.000, 1.000);
      (TEN => DY[22])=(1.000, 1.000);
      (TEN => DY[21])=(1.000, 1.000);
      (TEN => DY[20])=(1.000, 1.000);
      (TEN => DY[19])=(1.000, 1.000);
      (TEN => DY[18])=(1.000, 1.000);
      (TEN => DY[17])=(1.000, 1.000);
      (TEN => DY[16])=(1.000, 1.000);
      (TEN => DY[15])=(1.000, 1.000);
      (TEN => DY[14])=(1.000, 1.000);
      (TEN => DY[13])=(1.000, 1.000);
      (TEN => DY[12])=(1.000, 1.000);
      (TEN => DY[11])=(1.000, 1.000);
      (TEN => DY[10])=(1.000, 1.000);
      (TEN => DY[9])=(1.000, 1.000);
      (TEN => DY[8])=(1.000, 1.000);
      (TEN => DY[7])=(1.000, 1.000);
      (TEN => DY[6])=(1.000, 1.000);
      (TEN => DY[5])=(1.000, 1.000);
      (TEN => DY[4])=(1.000, 1.000);
      (TEN => DY[3])=(1.000, 1.000);
      (TEN => DY[2])=(1.000, 1.000);
      (TEN => DY[1])=(1.000, 1.000);
      (TEN => DY[0])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TCEN => CENY)=(1.000, 1.000);
      if (TEN == 1'b0)
        (TWEN[3] => WENY[3])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TWEN[2] => WENY[2])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TWEN[1] => WENY[1])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TWEN[0] => WENY[0])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TGWEN => GWENY)=(1.000, 1.000);
      if (TEN == 1'b0)
        (TA[8] => AY[8])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TA[7] => AY[7])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TA[6] => AY[6])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TA[5] => AY[5])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TA[4] => AY[4])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TA[3] => AY[3])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TA[2] => AY[2])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TA[1] => AY[1])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TA[0] => AY[0])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[31] => DY[31])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[30] => DY[30])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[29] => DY[29])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[28] => DY[28])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[27] => DY[27])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[26] => DY[26])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[25] => DY[25])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[24] => DY[24])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[23] => DY[23])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[22] => DY[22])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[21] => DY[21])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[20] => DY[20])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[19] => DY[19])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[18] => DY[18])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[17] => DY[17])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[16] => DY[16])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[15] => DY[15])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[14] => DY[14])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[13] => DY[13])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[12] => DY[12])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[11] => DY[11])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[10] => DY[10])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[9] => DY[9])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[8] => DY[8])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[7] => DY[7])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[6] => DY[6])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[5] => DY[5])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[4] => DY[4])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[3] => DY[3])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[2] => DY[2])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[1] => DY[1])=(1.000, 1.000);
      if (TEN == 1'b0)
        (TD[0] => DY[0])=(1.000, 1.000);
      if (TEN == 1'b1)
        (CEN => CENY)=(1.000, 1.000);
      if (TEN == 1'b1)
        (WEN[3] => WENY[3])=(1.000, 1.000);
      if (TEN == 1'b1)
        (WEN[2] => WENY[2])=(1.000, 1.000);
      if (TEN == 1'b1)
        (WEN[1] => WENY[1])=(1.000, 1.000);
      if (TEN == 1'b1)
        (WEN[0] => WENY[0])=(1.000, 1.000);
      if (TEN == 1'b1)
        (GWEN => GWENY)=(1.000, 1.000);
      if (TEN == 1'b1)
        (A[8] => AY[8])=(1.000, 1.000);
      if (TEN == 1'b1)
        (A[7] => AY[7])=(1.000, 1.000);
      if (TEN == 1'b1)
        (A[6] => AY[6])=(1.000, 1.000);
      if (TEN == 1'b1)
        (A[5] => AY[5])=(1.000, 1.000);
      if (TEN == 1'b1)
        (A[4] => AY[4])=(1.000, 1.000);
      if (TEN == 1'b1)
        (A[3] => AY[3])=(1.000, 1.000);
      if (TEN == 1'b1)
        (A[2] => AY[2])=(1.000, 1.000);
      if (TEN == 1'b1)
        (A[1] => AY[1])=(1.000, 1.000);
      if (TEN == 1'b1)
        (A[0] => AY[0])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[31] => DY[31])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[30] => DY[30])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[29] => DY[29])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[28] => DY[28])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[27] => DY[27])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[26] => DY[26])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[25] => DY[25])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[24] => DY[24])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[23] => DY[23])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[22] => DY[22])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[21] => DY[21])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[20] => DY[20])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[19] => DY[19])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[18] => DY[18])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[17] => DY[17])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[16] => DY[16])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[15] => DY[15])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[14] => DY[14])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[13] => DY[13])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[12] => DY[12])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[11] => DY[11])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[10] => DY[10])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[9] => DY[9])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[8] => DY[8])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[7] => DY[7])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[6] => DY[6])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[5] => DY[5])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[4] => DY[4])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[3] => DY[3])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[2] => DY[2])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[1] => DY[1])=(1.000, 1.000);
      if (TEN == 1'b1)
        (D[0] => DY[0])=(1.000, 1.000);

      (RETN => (Q[31] +: 1'b0)) = (1.000);
      (RETN => (QI[31] +: 1'b0)) = (1.000);
      (RETN => (Q[30] +: 1'b0)) = (1.000);
      (RETN => (QI[30] +: 1'b0)) = (1.000);
      (RETN => (Q[29] +: 1'b0)) = (1.000);
      (RETN => (QI[29] +: 1'b0)) = (1.000);
      (RETN => (Q[28] +: 1'b0)) = (1.000);
      (RETN => (QI[28] +: 1'b0)) = (1.000);
      (RETN => (Q[27] +: 1'b0)) = (1.000);
      (RETN => (QI[27] +: 1'b0)) = (1.000);
      (RETN => (Q[26] +: 1'b0)) = (1.000);
      (RETN => (QI[26] +: 1'b0)) = (1.000);
      (RETN => (Q[25] +: 1'b0)) = (1.000);
      (RETN => (QI[25] +: 1'b0)) = (1.000);
      (RETN => (Q[24] +: 1'b0)) = (1.000);
      (RETN => (QI[24] +: 1'b0)) = (1.000);
      (RETN => (Q[23] +: 1'b0)) = (1.000);
      (RETN => (QI[23] +: 1'b0)) = (1.000);
      (RETN => (Q[22] +: 1'b0)) = (1.000);
      (RETN => (QI[22] +: 1'b0)) = (1.000);
      (RETN => (Q[21] +: 1'b0)) = (1.000);
      (RETN => (QI[21] +: 1'b0)) = (1.000);
      (RETN => (Q[20] +: 1'b0)) = (1.000);
      (RETN => (QI[20] +: 1'b0)) = (1.000);
      (RETN => (Q[19] +: 1'b0)) = (1.000);
      (RETN => (QI[19] +: 1'b0)) = (1.000);
      (RETN => (Q[18] +: 1'b0)) = (1.000);
      (RETN => (QI[18] +: 1'b0)) = (1.000);
      (RETN => (Q[17] +: 1'b0)) = (1.000);
      (RETN => (QI[17] +: 1'b0)) = (1.000);
      (RETN => (Q[16] +: 1'b0)) = (1.000);
      (RETN => (QI[16] +: 1'b0)) = (1.000);
      (RETN => (Q[15] +: 1'b0)) = (1.000);
      (RETN => (QI[15] +: 1'b0)) = (1.000);
      (RETN => (Q[14] +: 1'b0)) = (1.000);
      (RETN => (QI[14] +: 1'b0)) = (1.000);
      (RETN => (Q[13] +: 1'b0)) = (1.000);
      (RETN => (QI[13] +: 1'b0)) = (1.000);
      (RETN => (Q[12] +: 1'b0)) = (1.000);
      (RETN => (QI[12] +: 1'b0)) = (1.000);
      (RETN => (Q[11] +: 1'b0)) = (1.000);
      (RETN => (QI[11] +: 1'b0)) = (1.000);
      (RETN => (Q[10] +: 1'b0)) = (1.000);
      (RETN => (QI[10] +: 1'b0)) = (1.000);
      (RETN => (Q[9] +: 1'b0)) = (1.000);
      (RETN => (QI[9] +: 1'b0)) = (1.000);
      (RETN => (Q[8] +: 1'b0)) = (1.000);
      (RETN => (QI[8] +: 1'b0)) = (1.000);
      (RETN => (Q[7] +: 1'b0)) = (1.000);
      (RETN => (QI[7] +: 1'b0)) = (1.000);
      (RETN => (Q[6] +: 1'b0)) = (1.000);
      (RETN => (QI[6] +: 1'b0)) = (1.000);
      (RETN => (Q[5] +: 1'b0)) = (1.000);
      (RETN => (QI[5] +: 1'b0)) = (1.000);
      (RETN => (Q[4] +: 1'b0)) = (1.000);
      (RETN => (QI[4] +: 1'b0)) = (1.000);
      (RETN => (Q[3] +: 1'b0)) = (1.000);
      (RETN => (QI[3] +: 1'b0)) = (1.000);
      (RETN => (Q[2] +: 1'b0)) = (1.000);
      (RETN => (QI[2] +: 1'b0)) = (1.000);
      (RETN => (Q[1] +: 1'b0)) = (1.000);
      (RETN => (QI[1] +: 1'b0)) = (1.000);
      (RETN => (Q[0] +: 1'b0)) = (1.000);
      (RETN => (QI[0] +: 1'b0)) = (1.000);
  endspecify

endmodule
`endcelldefine
`endif
