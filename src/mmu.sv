
module mmu #(
    parameter int unsigned     MEM_W         = 32 // memory bus width in bits, same as value in vproc_top.sv
    )(
    input logic clk,
    input logic rst,

    // To/from Vicuna/Ibex
    output logic               vproc_mem_req_o,
    output logic [31:0]        vproc_mem_addr_o,
    output logic               vproc_mem_we_o,
    output logic [MEM_W/8-1:0] vproc_mem_be_o,
    output logic [MEM_W  -1:0] vproc_mem_wdata_o,
    input  logic               vproc_mem_rvalid_i,
    input  logic               vproc_mem_err_i,
    input  logic [MEM_W  -1:0] vproc_mem_rdata_i,
    output logic [31:0]        vproc_pend_vreg_wr_map_o
);

endmodule : mmu
