
module toplevel (
    input logic clk,
    input logic rst
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
    .logic vproc_mem_req_o(),
    .vproc_mem_addr_o(vproc_mem_addr_o),
    .vproc_mem_we_o(vproc_mem_we_o),
    .vproc_mem_be_o(vproc_mem_be_o),
    .vproc_mem_wdata_o(vproc_mem_wdata_o),
    .vproc_mem_rvalid_i(vproc_mem_rvalid_i),
    .vproc_mem_err_i(vproc_mem_err_i),
    .vproc_mem_rdata_i(vproc_mem_rdata_i),
    .vproc_pend_vreg_wr_map_o(vproc_pend_vreg_wr_map_o)
);

sram sram (
    .clk(clk),
    .rst(rst)
);

// uart uart (
//     .clk(clk),
//     .rst(rst)
// );

// digitalTimer digitalTimer (
//     .clk(clk),
//     .rst(rst)
// );

endmodule : toplevel
