
module toplevel (
    input logic clk,
    input logic rst,
    inout logic [9:0] gpio_pins // should this be inout? 
);

// VPROC_TOP SIGNALS
// 32 here should be the same as the MEM_W value specified in vproc_top.sv
logic vproc_mem_req_o;
logic [31:0] vproc_mem_addr_o,
logic vproc_mem_we_o;
logic [32/8-1:0] vproc_mem_be_o;
logic [32-1:0] vproc_mem_wdata_o;
logic vproc_mem_rvalid_i;
logic vproc_mem_err_i;
logic [32-1:0] vproc_mem_rdata_i;
logic [31:0] vproc_pend_vreg_wr_map_o;

// TIMER SIGNALS
logic timer_is_high;
logic [31:0] timer_set_val;
logic set_timer;

// MODULE DECLARATIONS
vproc_top vproc_top (
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

mmu mmu (
    .clk(clk),
    .rst(rst),

    // To/from Vicuna/Ibex
    .vproc_mem_req_o(vproc_mem_req_o),
    .vproc_mem_addr_o(vproc_mem_addr_o),
    .vproc_mem_we_o(vproc_mem_we_o),
    .vproc_mem_be_o(vproc_mem_be_o),
    .vproc_mem_wdata_o(vproc_mem_wdata_o),
    .vproc_mem_rvalid_i(vproc_mem_rvalid_i),
    .vproc_mem_err_i(vproc_mem_err_i),
    .vproc_mem_rdata_i(vproc_mem_rdata_i),
    .vproc_pend_vreg_wr_map_o(vproc_pend_vreg_wr_map_o),

    // To/from digital timer
    .timer_is_high(timer_is_high),
    .timer_set_val(timer_set_val),
    .set_timer(set_timer),

    // To/from GPIO
    .gpio_pins(gpio_pins)

    // To/from external SPI
    
);

digitalTimer digitalTimer (
    .clk(clk),
    .rst(rst),
    .timer_is_high(timer_is_high),
    .timer_set_val(timer_set_val),
    .set_timer(set_timer)
);

spi external_spi (
    .clk(clk),
    .rst(rst)
);

endmodule : toplevel
