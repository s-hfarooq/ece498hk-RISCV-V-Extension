// // Copyright TU Wien
// // Licensed under the Solderpad Hardware License v2.1, see LICENSE.txt for details
// // SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1

// Copyright TU Wien
// Licensed under the Solderpad Hardware License v2.1, see LICENSE.txt for details
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1


module vproc_tb #(
        parameter              PROG_PATHS_LIST = "/home/hfaroo9/498-integ/ece498hk-RISCV-V-Extension/src/vicuna/sim/files.txt",
        parameter int unsigned MEM_W           = 32,
        parameter int unsigned MEM_SZ          = 262144,
        parameter int unsigned MEM_LATENCY     = 1,
        parameter int unsigned VMEM_W          = 32,
        parameter int unsigned ICACHE_SZ       = 0,   // instruction cache size in bytes
        parameter int unsigned ICACHE_LINE_W   = 128, // instruction cache line width in bits
        parameter int unsigned DCACHE_SZ       = 0,   // data cache size in bytes
        parameter int unsigned DCACHE_LINE_W   = 512  // data cache line width in bits
    );

    logic clk, rst;
    always begin
        clk = 1'b0;
        #1;
        clk = 1'b1;
        #1;
    end

    logic vss, vdd;
    wire [9:0] gpio_pins;
    wire [3:0] external_qspi_pins;
    // wire [3:0] programming_qspi_pins;
    logic external_qspi_ck_o;
    logic external_qspi_cs_o;
    // logic programming_qspi_ck_o;
    // logic programming_qspi_cs_o;
    logic set_programming_mode;

    logic [3:0] external_qspi_io_i;
    logic [3:0] external_qspi_io_o;
    logic [3:0] external_qspi_io_t;

    assign set_programming_mode = 1'b0;

    toplevel_498 toplevel_498 (
        .vss(vss),
        .vdd(vdd),
        .clk(clk),
        .rst(rst),
        .gpio_pins(gpio_pins),

        // To/from storage SPI
        .external_qspi_pins(external_qspi_pins),
        .external_qspi_ck_o(external_qspi_ck_o),
        .external_qspi_cs_o(external_qspi_cs_o),

        // To/from external programming pins
        // .programming_qspi_pins(programming_qspi_pins),
        // .programming_qspi_ck_o(programming_qspi_ck_o),
        // .programming_qspi_cs_o(programming_qspi_cs_o),

        // Programming set pins
        .set_programming_mode(set_programming_mode)
    );

    qspi_stub qspi_stub (
        .qspi_io_i  (external_qspi_io_i),
        .qspi_io_o  (external_qspi_io_o),
        .qspi_io_t  (external_qspi_io_t),
        .qspi_ck_o  (external_qspi_ck_o),
        .qspi_cs_o  (external_qspi_cs_o)
    );

    genvar n;
    logic [3:0] io_tmp;
    generate
        for(n = 0; n < 4; n++) begin
            io_pad io_pad_qspi_io (
                .io(external_qspi_pins[n]),
                .i(io_tmp[n]),
                .o(external_qspi_io_i[n]),
                .t(~toplevel_498.mmu.storage_controller.qspi_io_t)
            );
        end
    endgenerate

    always_comb begin
        for(int unsigned i = 0; i < 4; i++) begin
            if(toplevel_498.mmu.storage_controller.qspi_io_t == 1'b1) begin
                external_qspi_io_t[i] = 1'b1;
            end else begin
                external_qspi_io_t[i] = 1'b0;
            end

            external_qspi_io_o[i] = external_qspi_pins[i];
        end
    end

    // memory
    initial begin
        $display("STARTING TB");
    end

    initial begin
        $dumpfile("498_tb_toplevel_out.vcd");
        $dumpvars(0, vproc_tb);
    end

    initial begin
        #30000
        $display("full_tb ending at 30000");
        $finish;
    end

endmodule