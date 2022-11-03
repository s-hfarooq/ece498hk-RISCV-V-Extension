
module storage_controller #(
    parameter int unsigned     MEM_W         = 32 // memory bus width in bits, same as value in vproc_top.sv
    )(
    input logic clk,
    input logic rst,
    input logic memory_access,
    input logic memory_is_writing,
    input logic [31:0] addr,
    input logic [31:0] d_in,
    input logic [MEM_W/8-1:0] mem_be, // TODO: never used, probably should 
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
logic [10:0] sram_addr;
logic [31:0] sram_d_in;
logic [2:0] sram_ema;
logic [3:0] sram_byte_en;
logic sram_retn;
logic [31:0] d_out_tmp;

// EXTERNAL STORAGE SPI SIGNALS
// logic spi_wb_cyc;
// logic spi_wb_stb;
// logic spi_cfg_stb;
// logic spi_wb_we;
// logic [21:0] spi_wb_addr;
// logic [31:0] spi_i_wb_data;
// logic spi_wb_stall;
// logic spi_wb_ack;
// logic [31:0] spi_o_wb_data;

logic spixpress_spi_cs_n;
logic spixpress_spi_sck;
logic spixpress_spi_mosi;

// Will be using SRAM as scratchpad memory
sram_2048_32_wmask_8bit sram (
    .Q(sram_d_out),
    .CLK(clk),
    .CEN(sram_chip_en),
    .WEN(sram_byte_en),
    .GWEN(sram_wr_en),
    .A(sram_addr),
    .D(sram_d_in),
    .EMA(sram_ema),
    .RETN(sram_retn)
);

// EXTERNAL STORAGE SPI SIGNALS
logic [7:0] spi_curr_send_byte;
logic [7:0] spi_curr_recv_byte;
logic spi_in_valid;
logic spi_out_valid;
logic spi_done; 
logic [31:0] spi_read_full_val;

SPI_Master_With_Single_CS storage_spi (
    // Control/Data Signals,
    .i_Rst_L(rst),     // FPGA Reset
    .i_Clk(clk),       // FPGA Clock

    // TX (MOSI) Signals
    .i_TX_Count(1'b0),  // # bytes per CS low
    .i_TX_Byte(spi_curr_send_byte),       // Byte to transmit on MOSI
    .i_TX_DV(spi_in_valid),         // Data Valid Pulse with i_TX_Byte
    .o_TX_Ready(spi_done),      // Transmit Ready for next byte

    // RX (MISO) Signals
    .o_RX_Count(),  // Index RX byte
    .o_RX_DV(spi_out_valid),     // Data Valid pulse (1 clock cycle)
    .o_RX_Byte(spi_curr_recv_byte),   // Byte received on MISO

    // SPI Interface
    .o_SPI_Clk(spixpress_spi_sck),
    .i_SPI_MISO(external_storage_spi_miso),
    .o_SPI_MOSI(spixpress_spi_mosi),
    .o_SPI_CS_n(spixpress_spi_cs_n)
);

// spixpress storage_spi (
//     .i_clk(clk),
//     .i_reset(~rst),
//     //
//     .i_wb_cyc(spi_wb_cyc),
//     .i_wb_stb(spi_wb_stb),
//     .i_cfg_stb(spi_cfg_stb),
//     .i_wb_we(spi_wb_we),
//     .i_wb_addr(spi_wb_addr),
//     .i_wb_data(spi_i_wb_data),
//     .o_wb_stall(spi_wb_stall),
//     .o_wb_ack(spi_wb_ack),
//     .o_wb_data(spi_o_wb_data),
//     //	
//     .o_spi_cs_n(spixpress_spi_cs_n),
//     .o_spi_sck(spixpress_spi_sck),
//     .o_spi_mosi(spixpress_spi_mosi),
//     .i_spi_miso(external_storage_spi_miso)
// );


enum logic [3:0] {
    default_state,
    waiting_for_sram,
    waiting_for_external,
    programming_state,
    external_send_1,
    external_send_2,
    external_send_3,
    external_send_4,
    external_stall_1,
    external_stall_2,
    external_stall_3,
    external_stall_4,
    external_read_1,
    external_read_2,
    external_read_3,
    external_read_4
} state, next_state, stalled_ret_state;

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
        next_state = default_state;
    end else if (set_programming_mode) begin
        next_state = programming_state;
    end else begin
        unique case (state) 
            default_state:
                begin
                    if (memory_access) begin
                        if (addr < 32'h0000_0FFF) begin
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
            external_send_1:
                begin
                    if (spi_done) begin
                        next_state = external_stall_1;
                    end else begin
                        next_state = external_send_1;
                    end
                end
            external_stall_1:
                begin
                    next_state = external_send_2;
                end
            external_send_2:
                begin
                    if (spi_done) begin
                        next_state = external_stall_2;
                    end else begin
                        next_state = external_send_2;
                    end
                end
            external_stall_2:
                begin
                    next_state = external_send_3;
                end
            external_send_3:
                begin
                    if (spi_done) begin
                        next_state = external_stall_3;
                    end else begin
                        next_state = external_send_3;
                    end
                end
            external_stall_3:
                begin
                    next_state = external_send_4;
                end
            external_send_4:
                begin
                    if (spi_done) begin
                        next_state = external_stall_4;
                    end else begin
                        next_state = external_send_4;
                    end
                end
            external_stall_4:
                begin
                    next_state = external_read_1;
                end
            external_read_1:
                begin
                    if (spi_out_valid) begin
                        next_state = external_read_2;
                    end else begin
                        next_state = external_read_1;
                    end
                end
            external_read_2:
                begin
                    if (spi_out_valid) begin
                        next_state = external_read_3;
                    end else begin
                        next_state = external_read_2;
                    end
                end
            external_read_3:
                begin
                    if (spi_out_valid) begin
                        next_state = external_read_4;
                    end else begin
                        next_state = external_read_3;
                    end
                end
            external_read_4:
                begin
                    if (spi_out_valid) begin
                        next_state = default_state;
                    end else begin
                        next_state = external_read_4;
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

// SRAM signals
always_comb begin
    if (memory_access && addr < 32'h0000_0FFF) begin
        sram_chip_en = ~memory_access;
        sram_wr_en = ~memory_is_writing;
        sram_addr = addr[10:0];
        sram_d_in = d_in;
        sram_ema = 3'b0;
        sram_retn = 1'b1;
        d_out_tmp = sram_d_out;
        sram_byte_en = ~mem_be;
    end else begin
        sram_chip_en = 1'b1;
        sram_wr_en = 1'b1;
        sram_addr = 11'b0;
        sram_d_in = 32'b0;
        sram_ema = 3'b0;
        sram_retn = 1'b1;
        sram_byte_en = 4'hF;
    end
end

// Determine signal values
always_comb begin
    // Module output defaults
    d_out = 32'b0;
    out_valid = 1'b0;

    // SPI defaults
    // spi_wb_cyc = 1'b0;
    // spi_wb_stb = 1'b0;
    // spi_cfg_stb = 1'b0;
    // spi_wb_we = 1'b0;
    // spi_wb_addr  = 22'b0;
    // spi_i_wb_data = 32'b0;

    spi_curr_send_byte <= 8'b0;
    spi_in_valid <= 1'b0;

    external_storage_spi_cs_n = spixpress_spi_cs_n;
    external_storage_spi_sck = spixpress_spi_sck;
    external_storage_spi_mosi = spixpress_spi_mosi;

    unique case (state)
        default_state:
            begin
                // Nothing should happen in default state?
            end
        waiting_for_sram:
            begin
                d_out = d_out_tmp;
                out_valid = 1'b1;
            end
        external_send_1:
            begin
                spi_curr_send_byte <= 8'h03; // 0x03 = read opcode
                spi_in_valid <= 1'b1;
            end
        external_send_2:
            begin
                spi_curr_send_byte <= addr[23:16]; // addr pt1
                spi_in_valid <= 1'b1;
            end
        external_send_3:
            begin
                spi_curr_send_byte <= addr[15:8]; // addr pt2
                spi_in_valid <= 1'b1;
            end
        external_send_4:
            begin
                spi_curr_send_byte <= addr[7:0]; // addr pt3
                spi_in_valid <= 1'b1;
            end
        external_read_1:
            begin
                if (spi_out_valid) begin
                    spi_read_full_val[31:24] = spi_curr_recv_byte;
                end
            end
        external_read_2:
            begin
                if (spi_out_valid) begin
                    spi_read_full_val[23:16] = spi_curr_recv_byte;
                end
            end
        external_read_3:
            begin
                if (spi_out_valid) begin
                    spi_read_full_val[15:8] = spi_curr_recv_byte;
                end
            end
        external_read_4:
            begin
                if (spi_out_valid) begin
                    spi_read_full_val[7:0] = spi_curr_recv_byte;
                end
            end
        programming_state:
            begin
                // Route programming SPI pins directly to external storage if in programming state
                external_storage_spi_cs_n = programming_spi_cs_n;
                external_storage_spi_sck = programming_spi_sck;
                external_storage_spi_mosi = programming_spi_mosi;
                programming_spi_miso = external_storage_spi_miso;
            end
        default:
            begin
                // external_stall_n goes here
                // Nothing should happen in default state?
            end
    endcase
end

endmodule : storage_controller
