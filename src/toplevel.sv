
module toplevel #(
    parameter int unsigned     MEM_W         = 32 // memory bus width in bits, same as value in vproc_top.sv
    )(
    input logic clk,
    input logic rst,
    inout logic [9:0] gpio_pins,

    // Flash storage SPI
    output logic external_storage_spi_cs_n,
    output logic external_storage_spi_sck,
    output logic external_storage_spi_mosi,
    input logic external_storage_spi_miso,

    // Programming SPI
    input logic programming_spi_cs_n,
    input logic programming_spi_sck,
    input logic programming_spi_mosi,
    output logic programming_spi_miso,

    // Programming/debug set pins
    input logic set_programming_mode,
    input logic set_debug_mode // Never used, maybe should add a debug mode
);

// VPROC_TOP SIGNALS
logic vproc_mem_req_o;
logic [31:0] vproc_mem_addr_o,
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
    .clk(clk),
    .rst(rst),
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

    // Flash storage SPI
    .external_storage_spi_cs_n(external_storage_spi_cs_n),
    .external_storage_spi_sck(external_storage_spi_sck),
    .external_storage_spi_mosi(external_storage_spi_mosi),
    .external_storage_spi_miso(external_storage_spi_miso),

    // Programming SPI
    .programming_spi_cs_n(programming_spi_cs_n),
    .programming_spi_sck(programming_spi_sck),
    .programming_spi_mosi(programming_spi_mosi),
    .programming_spi_miso(programming_spi_miso)
);

endmodule : toplevel
