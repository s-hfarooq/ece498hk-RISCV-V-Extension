
module mmu #(
    parameter int unsigned     MEM_W         = 32 // memory bus width in bits, same as value in vproc_top.sv
    )(
    input  logic clk,
    input  logic rst,

    // To/from Vicuna/Ibex
    input  logic               vproc_mem_req_o,
    input  logic [31:0]        vproc_mem_addr_o,
    input  logic               vproc_mem_we_o,
    input  logic [MEM_W/8-1:0] vproc_mem_be_o,
    input  logic [MEM_W  -1:0] vproc_mem_wdata_o,
    output logic               vproc_mem_rvalid_i,
    output logic               vproc_mem_err_i,
    output logic [MEM_W  -1:0] vproc_mem_rdata_i,
    input  logic [31:0]        vproc_pend_vreg_wr_map_o,

    // To/from digital timer
    input  logic timer_is_high,
    output logic [31:0] timer_set_val,
    output logic set_timer,

    // To/from GPIO
    inout  logic [9:0] gpio_pins,

    // To/from storage SPI

    // To/from external SPI
);

//                       MEMORY ADDRESSES
// | Address Range              | Device                |
// | -------------------------- | --------------------- |
// | 0x0000_0000 - 0x0000_0100  | Reserved              |
// | 0x0000_0101 - 0x0000_010A  | GPIO                  |
// | 0x0000_010B                | Digital Timer         |
// | 0x0000_010C - 0x0000_0FFF  | Reserved              |
// | 0x0000_1000 - 0xFFFF_FFFF  | SRAM/External Storage |


storage_controller storage_controller (
    .clk(clk),
    .rst(rst)
);

endmodule : mmu
