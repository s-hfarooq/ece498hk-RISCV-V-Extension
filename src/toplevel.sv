
module toplevel_498 #(
        parameter int unsigned MEM_W           = 32,
        parameter int unsigned VMEM_W          = 32,
        parameter int unsigned ICACHE_SZ       = 0,   // instruction cache size in bytes
        parameter int unsigned ICACHE_LINE_W   = 128, // instruction cache line width in bits
        parameter int unsigned DCACHE_SZ       = 0,   // data cache size in bytes
        parameter int unsigned DCACHE_LINE_W   = 512  // data cache line width in bits
    )(
    input vdd,
    input vss,
    input logic clk,
    input logic rst,
    inout wire [9:0] gpio_pins,

    // To/from storage SPI
    inout   wire    [3:0]           external_qspi_pins,
    output  logic                   external_qspi_ck_o,
    output  logic                   external_qspi_cs_o,

    // To/from programming SPI
    // inout  wire    [3:0]           programming_qspi_pins,
    // input  logic                   programming_qspi_ck_o,
    // input  logic                   programming_qspi_cs_o,

    // Programming/debug set pins
    input logic set_programming_mode
);

// TODO
/// NEED TO CHANGE VICUNA/IBEX TO HAVE PC START AT X2000
///
///

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
vproc_top #(
        .MEM_W         ( MEM_W                       ),
        .VMEM_W        ( VMEM_W                      ),
        .VREG_TYPE     ( vproc_pkg::VREG_GENERIC     ),
        .MUL_TYPE      ( vproc_pkg::MUL_GENERIC      ),
        .ICACHE_SZ     ( ICACHE_SZ                   ),
        .ICACHE_LINE_W ( ICACHE_LINE_W               ),
        .DCACHE_SZ     ( DCACHE_SZ                   ),
        .DCACHE_LINE_W ( DCACHE_LINE_W               )
    ) vproc_top (
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
    .external_qspi_pins(external_qspi_pins),
    .external_qspi_ck_o(external_qspi_ck_o),
    .external_qspi_cs_o(external_qspi_cs_o)

    // To/from programming SPI
    // .programming_qspi_pins(programming_qspi_pins),
    // .programming_qspi_ck_o(programming_qspi_ck_o),
    // .programming_qspi_cs_o(programming_qspi_cs_o)
);

endmodule : toplevel_498
