
module storage_controller #(
    parameter int unsigned     MEM_W         = 32 // memory bus width in bits, same as value in vproc_top.sv
    )(
    input logic clk,
    input logic rst,
    input logic memory_access,
    input logic memory_is_writing,
    input logic [31:0] addr,
    input logic [31:0] d_in,
    input logic [MEM_W/8-1:0] mem_be,
    output logic [31:0] d_out,

    output logic out_valid

    // To/from external SPI
);

// SRAM SIGNALS
logic [31:0] sram_d_out;
logic sram_chip_en;
logic sram_wr_en;
logic [31:0] sram_addr;
logic [31:0] sram_d_in;
logic [2:0] sram_ema;
logic sram_retn;

// Will be using SRAM as a cache
// TODO: Needs byte enable
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

// TODO: need state machine to wait until spi returns data before returning anything
// will also need to change mmu to support this

enum logic [1:0] = {
    default_state,
    waiting_for_mem
} state, next_state;

always_ff @(posedge clk) begin
    if (~rst) begin
        state <= default_state;
        next_state <= default_state;
    end else begin
        state <= next_state;
    end
end

// Determine next state
always_comb begin

end

// Determine signal values
always_comb begin
    sram_d_out <= 32'b0;
    sram_chip_en <= 1'b0;
    sram_wr_en <= 1'b0;
    sram_addr <= 32'b0;
    sram_d_in <= 32'b0;
    sram_ema <= 3'b0;
    sram_retn <= 1'b0;
    d_out <= 32'b0;
    out_valid <= 1'b0;

    if (memory_access) begin
        if (addr < 32'h0000_2000) begin
            // SRAM access
            sram_chip_en <= 1'b1;
            sram_wr_en <= memory_is_writing;
            d_out <= sram_d_out;
            sram_addr <= addr;
            sram_d_in <= d_in; // TODO: need to use byte enable
            // sram_ema <= // TODO: what should this be?
            sram_retn <= 1'b0; // TODO: is this correct?
            out_valid <= 1'b1;
        end else begin
            // External storage access
        end
    end

end

endmodule : storage_controller
