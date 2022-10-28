
module storage_controller (
    input logic clk,
    input logic rst
);

// SRAM SIGNALS
logic [31:0] sram_d_out;
logic sram_chip_en;
logic sram_wr_en;
logic [31:0] sram_addr;
logic [31:0] sram_d_in;
logic [2:0] sram_ema;
logic sram_retn;

sram_sp_hdc_svt_rvt_hvt sram (
    .Q(sram_d_out),
    .CLK(clk),
    .CEN(sram_chip_en),
    .WEN(sram_wr_en),
    .A(sram_addr),
    .D(sram_d_in),
    .EMA(sram_ema),
    .RETN(sram_retn)
);

spi storage_spi (
    .clk(clk),
    .rst(rst)
);

endmodule : storage_controller
