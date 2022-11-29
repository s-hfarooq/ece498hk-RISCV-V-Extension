
module storage_controller #(
    parameter int unsigned     MEM_W         = 32, // memory bus width in bits, same as value in vproc_top.sv
    parameter int unsigned     MEM_SZ        = 262144
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
    input logic external_storage_access,

    // To/from storage SPI
    inout   wire    [3:0]           external_qspi_pins,
    output  wire                    external_qspi_ck_o,
    output  wire                    external_qspi_cs_o

    // To/from programming SPI
    // inout  wire    [3:0]           programming_qspi_pins,
    // input  logic                   programming_qspi_ck_o,
    // input  logic                   programming_qspi_cs_o

    // output logic external_qspi_io_t // shouldn't be needed as an output
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

// QSPI SIGNALS
logic [3:0] external_qspi_io_i;
logic [3:0] external_qspi_io_o;
logic external_qspi_io_t;

// QSPI SIGNALS
logic [31:0] qspi_addr;
logic qspi_sel;
logic qspi_write;
logic qspi_ready;
logic [31:0] qspi_rdata;
logic [3:0] qspi_io_i;
logic [3:0] qspi_io_o;
logic qspi_io_t;
// logic qspi_ck_o;
logic qspi_ck_o_tmp;
// logic qspi_cs_o;
logic qspi_cs_o_tmp;
logic [3:0] io_pad_qpsi_io;

qspi_controller qspi_controller (
    .s_pclk(clk),
    .s_presetn(rst),
    .s_paddr(qspi_addr),
    .s_psel(qspi_sel),
    .s_pwrite(qspi_write),
    .s_pready(qspi_ready),
    .s_prdata(qspi_rdata),
    .qspi_io_i(external_qspi_io_i),
    .qspi_io_o(qspi_io_o),
    .qspi_io_t(qspi_io_t),
    .qspi_ck_o(qspi_ck_o_tmp),
    .qspi_cs_o(qspi_cs_o_tmp)
);

enum logic [2:0] {
    default_state,
    waiting_for_sram,
    programming_state,
    external_send,
    external_done
} state, next_state;

// external_qspi_io_t determines direction of QSPI IO pins -- TODO: QSPI passthrough commented out
// always_comb begin
//     external_qspi_io_i = (set_programming_mode == 1'b1) ? 4'hF : external_qspi_pins;
// end

// genvar qspi_incr;
// generate
//     for(qspi_incr = 0; qspi_incr < 4; qspi_incr++) begin
//         // This is terrible but it doesn't compile if I use an if statement instead
//         assign external_qspi_pins[qspi_incr] = (set_programming_mode == 1'b1) ? (programming_qspi_pins[qspi_incr]) : (external_qspi_io_t == 1'b1 ? 'z : external_qspi_io_o[qspi_incr]);
//     end
// endgenerate

genvar n;
generate
    for(n = 0; n < 4; n++) begin
        io_pad io_pad_qspi_io (
            .io(external_qspi_pins[n]), //io_pad_qpsi_io[n]),
            .i(external_qspi_io_i[n]),
            .o(qspi_io_o[n]),
            .t(qspi_io_t)
        );
    end
endgenerate

logic qspi_ck_i;
logic qspi_cs_i;

io_pad io_pad_qspi_ck (
    .io(external_qspi_ck_o),
    .i(qspi_ck_i),
    .o(qspi_ck_o_tmp),
    .t(1'b0)
);

io_pad io_pad_qspi_cs (
    .io(external_qspi_cs_o),
    .i(qspi_cs_i),
    .o(qspi_cs_o_tmp),
    .t(1'b0)
);

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
                        if (~external_storage_access) begin
                            next_state = waiting_for_sram;
                        end else begin
                            next_state = external_send;
                        end
                    end else begin
                        next_state = default_state;
                    end
                end
            waiting_for_sram:
                begin
                    next_state = default_state;
                end
            external_send:
                begin
                    if (qspi_ready) begin
                        next_state = external_done;
                    end else begin
                        next_state = external_send;
                    end
                end
            external_done:
                begin
                    next_state = default_state;
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
    // external_qspi_io_o = qspi_io_o;
    // external_qspi_io_t = qspi_io_t;
    // external_qspi_ck_o = qspi_ck_o;
    // external_qspi_cs_o = qspi_cs_o;

    qspi_addr = 32'b0;
    qspi_write = 1'b0;
    qspi_sel = 1'b0;

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
        external_send:
            begin
                // qspi_addr = addr;
                qspi_addr = addr[$clog2(MEM_SZ)-1 : $clog2(MEM_W/8)]; // convert addr to idx
                qspi_write = 1'b0;
                qspi_sel = 1'b1;
            end
        external_done:
            begin
                out_valid = 1'b1;
                d_out = qspi_rdata;
                qspi_sel = 1'b0;
            end
        programming_state:
            begin
                // Route programming SPI pins directly to external storage if in programming state
                // external_qspi_pins = programming_qspi_pins; // TODO: Will this compile? It does not
                // external_qspi_ck_o = programming_qspi_ck_o;
                // external_qspi_cs_o = programming_qspi_cs_o;
            end
        default:
            begin
                // Nothing should happen in default state?
            end
    endcase
end

endmodule : storage_controller
