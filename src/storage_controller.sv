
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
    input logic set_programming_mode,

    // To/from storage SPI
    output logic external_storage_spi_cs_n,
    output logic external_storage_spi_sck,
    output logic external_storage_spi_mosi,
    input logic external_storage_spi_miso,

    // To/from programming SPI
    input logic programming_spi_cs_n,
    input logic programming_spi_sck,
    input logic programming_spi_mosi,
    output logic programming_spi_miso
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
logic [31:0] spi_i_wb_data;
logic spi_wb_stall;
logic spi_wb_ack;
logic [31:0] spi_o_wb_data;

logic spixpress_spi_cs_n;
logic spixpress_spi_sck;
logic spixpress_spi_mosi;

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
    .i_cfg_stb(spi_cfg_stb),
    .i_wb_we(spi_wb_we),
    .i_wb_addr(spi_wb_addr),
    .i_wb_data(spi_i_wb_data),
    .o_wb_stall(spi_wb_stall),
    .o_wb_ack(spi_wb_ack),
    .o_wb_data(spi_o_wb_data),
    //	
    .o_spi_cs_n(spixpress_spi_cs_n),
    .o_spi_sck(spixpress_spi_sck),
    .o_spi_mosi(spixpress_spi_mosi),
    .i_spi_miso(external_storage_spi_miso)
);


enum logic [1:0] {
    default_state,
    waiting_for_sram,
    waiting_for_external,
    programming_state
} state, next_state;

always_ff @(posedge clk) begin
    if (~rst) begin
        state <= default_state;
    end else begin
        state <= next_state;
    end
end

// Determine next state
always_comb begin
    if (~rst) begin
        next_state <= default_state;
    end else if (set_programming_mode) begin
        next_state = programming_state;
    end else begin
        unique case (state) 
            default_state:
                begin
                    if (memory_access) begin
                        if (addr < 32'h0000_2000) begin
                            next_state = waiting_for_sram;
                        end else begin
                            next_state = waiting_for_external;
                        end
                    end else begin
                        next_state = default_state;
                    end
                end
            waiting_for_sram:
                begin
                    next_state = default_state; // does sram always return immediately for both read and write?
                end
            waiting_for_external:
                begin
                    if (spi_wb_ack && ~spi_wb_stall) begin // might be possible that this never occurs and we're stuck in the waiting_for_external state
                        next_state = default_state;
                    end else begin
                        next_state = waiting_for_external;
                    end
                end
            programming_state:
                begin
                    next_state = programming_state;
                end
            default:
                begin
                    next_state = default_state;
                end
        endcase
    end
end

// Determine signal values
always_comb begin
    // Module output defaults
    d_out = 32'b0;
    out_valid = 1'b0;

    // SRAM defaults
    // sram_d_out = 32'b0;
    sram_chip_en = 1'b0;
    sram_wr_en = 1'b0;
    sram_addr = 32'b0;
    sram_d_in = 32'b0;
    sram_ema = 3'b0;
    sram_retn = 1'b0;

    // SPI defaults
    spi_wb_cyc = 1'b0;
    spi_wb_stb = 1'b0;
    spi_cfg_stb = 1'b0;
    spi_wb_we = 1'b0;
    spi_wb_addr  = 22'b0;
    spi_i_wb_data = 32'b0;

    unique case (state)
        default_state:
            begin
                // Nothing should happen in default state?
            end
        waiting_for_sram:
            begin
                sram_chip_en = 1'b1;
                sram_wr_en = memory_is_writing;
                d_out = sram_d_out;
                sram_addr = addr;
                sram_d_in = d_in; // TODO: need to use byte enable
                // sram_ema = // TODO: what should this be?
                sram_retn = 1'b0; // TODO: is this correct?

                if (~memory_is_writing) begin
                    out_valid = 1'b1; // Assume SRAM is ready immediatly - is this correct? 
                end
            end
        waiting_for_external:
            begin
                if (spi_wb_ack) begin
                    d_out = spi_o_wb_data;
                    out_valid = 1'b1;
                end else begin
                    spi_wb_cyc = 1'b0; // no idea what this is for
                    spi_wb_stb = 1'b1; // high when accessing memory
                    spi_cfg_stb = 1'b0; // high when accessing register values
                    spi_wb_we = 1'b0; // high when writing, low when reading (should never be writing to memory values)
                    spi_wb_addr  = addr[21:0];
                    spi_i_wb_data = 32'b0; // used by config register only, so always 0
                end
            end
        programming_state:
            begin
                // Route programming SPI pins directly to external storage if in programming state
                external_storage_spi_cs_n = (state == programming_state) ? programming_spi_cs_n : spixpress_spi_cs_n;
                external_storage_spi_sck = (state == programming_state) ? programming_spi_sck : spixpress_spi_sck;
                external_storage_spi_mosi = (state == programming_state) ? programming_spi_mosi : spixpress_spi_mosi;
                programming_spi_miso = external_storage_spi_miso;
            end
        default:
            begin
                // Nothing should happen in default state?
            end
    endcase
end

endmodule : storage_controller
