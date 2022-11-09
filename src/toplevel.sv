
module toplevel_498 #(
    parameter int unsigned     MEM_W         = 32 // memory bus width in bits, same as value in vproc_top.sv
    )(
    input logic clk,
    input logic rst,
    inout wire [9:0] gpio_pins,

    // To/from storage SPI
    input   logic   [3:0]           external_qspi_io_i,
    output  logic   [3:0]           external_qspi_io_o,
    output  logic   [3:0]           external_qspi_io_t,
    output  logic                   external_qspi_ck_o,
    output  logic                   external_qspi_cs_o,

    // To/from programming SPI
    output logic   [3:0]           programming_qspi_io_i,
    input  logic   [3:0]           programming_qspi_io_o,
    input  logic   [3:0]           programming_qspi_io_t,
    input  logic                   programming_qspi_ck_o,
    input  logic                   programming_qspi_cs_o,

    // Programming/debug set pins
    input logic set_programming_mode,
    input logic set_debug_mode // Never used, maybe should add a debug mode
);

// VPROC_TOP SIGNALS
logic vproc_mem_req_o;
logic [31:0] vproc_mem_addr_o;
logic vproc_mem_we_o;
logic [MEM_W/8-1:0] vproc_mem_be_o;
logic [MEM_W-1:0] vproc_mem_wdata_o;
logic vproc_mem_rvalid_i;
logic vproc_mem_err_i;
logic [MEM_W-1:0] vproc_mem_rdata_i;
logic [31:0] vproc_pend_vreg_wr_map_o;  // Debug, may not be needed (could be helpful for SPI debug)

// TIMER SIGNALS
logic timer_is_high;
logic [31:0] timer_set_val;
logic set_timer;

// MODULE DECLARATIONS
vproc_top #(.MEM_W(MEM_W)) vproc_top (
    .clk_i(clk),
    .rst_ni(rst),
    .mem_req_o(vproc_mem_req_o),
    .mem_addr_o(vproc_mem_addr_o),
    .mem_we_o(vproc_mem_we_o),
    .mem_be_o(vproc_mem_be_o),
    .mem_wdata_o(vproc_mem_wdata_o),
    .mem_rvalid_i(vproc_mem_rvalid_i),
    .mem_err_i(vproc_mem_err_i),
    .mem_rdata_i(vproc_mem_rdata_i),
    .pend_vreg_wr_map_o(vproc_pend_vreg_wr_map_o)
);

mmu #(.MEM_W(MEM_W)) mmu (
    .clk(clk),
    .rst(rst),

    // Set mode inputs
    .set_programming_mode(set_programming_mode),
    .set_debug_mode(set_debug_mode),

    // To/from Vicuna/Ibex
    .vproc_mem_req_o(vproc_mem_req_o),
    .vproc_mem_addr_o(vproc_mem_addr_o),
    .vproc_mem_we_o(vproc_mem_we_o),
    .vproc_mem_be_o(vproc_mem_be_o),
    .vproc_mem_wdata_o(vproc_mem_wdata_o),
    .vproc_mem_rvalid_i(vproc_mem_rvalid_i),
    .vproc_mem_err_i(vproc_mem_err_i),
    .vproc_mem_rdata_i(vproc_mem_rdata_i),

    // To/from GPIO
    .gpio_pins(gpio_pins),

    // To/from storage SPI
    .external_qspi_io_i(external_qspi_io_i),
    .external_qspi_io_o(external_qspi_io_o),
    .external_qspi_io_t(external_qspi_io_t),
    .external_qspi_ck_o(external_qspi_ck_o),
    .external_qspi_cs_o(external_qspi_cs_o),

    // To/from programming SPI
    .programming_qspi_io_i(programming_qspi_io_i),
    .programming_qspi_io_o(programming_qspi_io_o),
    .programming_qspi_io_t(programming_qspi_io_t),
    .programming_qspi_ck_o(programming_qspi_ck_o),
    .programming_qspi_cs_o(programming_qspi_cs_o)
);

endmodule : toplevel_498
