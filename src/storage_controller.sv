
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

    output logic out_valid,

    // To/from external SPI
    output logic external_storage_spi_cs_n,
    output logic external_storage_spi_sck,
    output logic external_storage_spi_mosi,
    input logic external_storage_spi_miso
);

// SRAM SIGNALS
logic [31:0] sram_d_out;
logic sram_chip_en;
logic sram_wr_en;
logic [31:0] sram_addr;
logic [31:0] sram_d_in;
logic [2:0] sram_ema;
logic sram_retn;

// EXTERNAL STORAGE SPI SIGNALS
logic spi_wb_cyc;
logic spi_wb_stb;
logic spi_cfg_stb;
logic spi_wb_we;
logic [21:0] spi_wb_addr;
logic [31:0] spi_wb_data;
logic spi_wb_stall;
logic spi_wb_ack;
logic [31:0] spi_wb_data;

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

spixpress storage_spi (
    .i_clk(clk),
    .i_reset(rst),
    //
    .i_wb_cyc(spi_wb_cyc),
    .i_wb_stb(spi_wb_stb),
    .i_cfg_stb(spi_cfg_stbv),
    .i_wb_we(spi_wb_we),
    .i_wb_addr(spi_wb_addr),
    .i_wb_data(spi_wb_data),
    .o_wb_stall(spi_wb_stall),
    .o_wb_ack(spi_wb_ack),
    .o_wb_data(spi_wb_data),
    //	
    .o_spi_cs_n(external_storage_spi_cs_n),
    .o_spi_sck(external_storage_spi_sck),
    .o_spi_mosi(external_storage_spi_mosi),
    .i_spi_miso(external_storage_spi_miso)
);

// TODO: need state machine to wait until spi returns data before returning anything
// will also need to change mmu to support this

enum logic [1:0] = {
    default_state,
    waiting_for_sram,
    waiting_for_external
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
    unique case (state) 
        default_state:
            begin
                if (memory_access) begin
                    if (addr < 32'h0000_2000) begin
                        next_state <= waiting_for_sram;
                    end else begin
                        next_state <= waiting_for_external;
                    end
                end else begin
                    next_state <= default_state;
                end
            end
        waiting_for_sram:
            begin
                next_state <= default_state; // does sram always return in 1 cycle for both read and write?
            end
        waiting_for_external:
            begin
                if (spi_ack) begin
                    next_state <= default_state;
                end else begin
                    next_state <= waiting_for_external;
                end
            end
        default:
            begin
                next_state <= default_state;
            end
    endcase

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

    unique case (state)
        default_state:
            begin
                // Nothing should happen in default state?
            end
        waiting_for_sram:
            begin
                sram_chip_en <= 1'b1;
                sram_wr_en <= memory_is_writing;
                d_out <= sram_d_out;
                sram_addr <= addr;
                sram_d_in <= d_in; // TODO: need to use byte enable
                // sram_ema <= // TODO: what should this be?
                sram_retn <= 1'b0; // TODO: is this correct?
                out_valid <= 1'b1; // Assume SRAM is ready within 1 cycle - is this correct? 
            end
        waiting_for_external:
            begin
                
            end
        default:
            begin
                // Nothing should happen in default state?
            end
    endcase
end

endmodule : storage_controller
