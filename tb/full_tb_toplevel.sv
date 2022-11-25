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

    // to mem
    logic        mem_req;
    logic [31:0] mem_addr;
    logic [31:0] mem_addr_m2k;
    logic        mem_we;
    logic [3:0]  mem_be;
    logic [31:0] mem_wdata;
    // from mem
    logic        mem_rvalid;
    logic        mem_err;
    logic [31:0] mem_rdata;

    logic mmu_rvalid;
    logic mmu_err;
    logic [31:0] mmu_rdata;

    logic rvalid_i;
    logic err_i;
    logic [31:0]  rdata_i; 

    logic sel_mem = 1;  // 1 == MMU, 0 == memarr

    // assign mem_req = mem_req_curr; 
    assign rvalid_i = sel_mem ? mmu_rvalid : mem_rvalid;
    assign err_i = sel_mem ? mmu_err : mem_err;
    assign rdata_i = sel_mem ? mmu_rdata : mem_rdata;

    vproc_top #(
        .MEM_W         ( MEM_W                       ),
        .VMEM_W        ( VMEM_W                      ),
        .VREG_TYPE     ( vproc_pkg::VREG_GENERIC     ),
        .MUL_TYPE      ( vproc_pkg::MUL_GENERIC      ),
        .ICACHE_SZ     ( ICACHE_SZ                   ),
        .ICACHE_LINE_W ( ICACHE_LINE_W               ),
        .DCACHE_SZ     ( DCACHE_SZ                   ),
        .DCACHE_LINE_W ( DCACHE_LINE_W               )
    ) top (
        .clk_i         ( clk                         ),
        .rst_ni        ( ~rst                        ),
        .mem_req_o     ( mem_req                     ),
        .mem_addr_o    ( mem_addr                    ),
        .mem_we_o      ( mem_we                      ),
        .mem_be_o      ( mem_be                      ),
        .mem_wdata_o   ( mem_wdata                   ),
        .mem_rvalid_i  ( rvalid_i                    ),
        .mem_err_i     ( err_i                       ),
        .mem_rdata_i   ( rdata_i                     ),
        .pend_vreg_wr_map_o ()
    );
    wire [9:0] gpio_pins;

    // To/from storage SPI
    logic   [3:0]           external_qspi_io_i;
    logic   [3:0]           external_qspi_io_o;
    logic   [3:0]           external_qspi_io_t;
    logic                   external_qspi_ck_o;
    logic                   external_qspi_cs_o;

    // To/from programming SPI
    logic   [3:0]           programming_qspi_io_i;
    logic   [3:0]           programming_qspi_io_o;
    logic   [3:0]           programming_qspi_io_t;
    logic                   programming_qspi_ck_o;
    logic                   programming_qspi_cs_o;

    wire [3:0] external_qspi_pins;
    wire [3:0] programming_qspi_pins;

    mmu #(.MEM_W(MEM_W)) mmu (
        .clk(clk),
        .rst(~rst),

        // Set mode inputs
        .set_programming_mode   ('0                     ),

        // To/from Vicuna/Ibex
        .vproc_mem_req_o    (mem_req                    ),
        .vproc_mem_addr_o   (mem_addr                   ),
        .vproc_mem_we_o     ('0                         ),
        .vproc_mem_be_o     (mem_be                     ),
        .vproc_mem_wdata_o  (mem_wdata                  ),
        .vproc_mem_rvalid_i (mmu_rvalid                 ),
        .vproc_mem_err_i    (mmu_err                    ),
        .vproc_mem_rdata_i  (mmu_rdata                  ),

        // To/from GPIO
        .gpio_pins          (gpio_pins                  ),

        // To/from storage SPI
        // .external_qspi_io_i (external_qspi_io_i         ),
        // .external_qspi_io_o (external_qspi_io_o         ),
        // .external_qspi_io_t (external_qspi_io_t         ),
        .external_qspi_pins (external_qspi_pins         ),
        .external_qspi_ck_o (external_qspi_ck_o         ),
        .external_qspi_cs_o (external_qspi_cs_o         ),

        // To/from programming SPI
        // .programming_qspi_io_i  (programming_qspi_io_i  ),
        // .programming_qspi_io_o  (programming_qspi_io_o  ),
        // .programming_qspi_io_t  (programming_qspi_io_t  ),
        .programming_qspi_pins  (programming_qspi_pins  ),
        .programming_qspi_ck_o  (programming_qspi_ck_o  ),
        .programming_qspi_cs_o  (programming_qspi_cs_o  )
    );

    qspi_stub qspi_stub(
        .qspi_io_i  (external_qspi_io_i                 ),
        .qspi_io_o  (external_qspi_io_o                 ),
        .qspi_io_t  (external_qspi_io_t                 ),
        .qspi_ck_o  (external_qspi_ck_o                 ),
        .qspi_cs_o  (external_qspi_cs_o                 )
    );

    // memory
    logic [MEM_W-1:0]                    mem[MEM_SZ/(MEM_W/8)];
    logic [$clog2(MEM_SZ/(MEM_W/8))-1:0] mem_idx;
    assign mem_addr_m2k = mem_addr - 32'h0000_2000;
    assign mem_idx = mem_addr_m2k[$clog2(MEM_SZ)-1 : $clog2(MEM_W/8)];
    // latency pipeline
    logic        mem_rvalid_queue[MEM_LATENCY];
    logic [31:0] mem_rdata_queue [MEM_LATENCY];
    logic        mem_err_queue   [MEM_LATENCY];
    always begin
	#5;
        if (mem_req & mem_we) begin
            for (int i = 0; i < MEM_W/8; i++) begin
                if (mem_be[i]) begin
                    mem[mem_idx][i*8 +: 8] <= mem_wdata[i*8 +: 8];
                end
            end
        end
        for (int i = 1; i < MEM_LATENCY; i++) begin
            if (i == 1) begin
                mem_rvalid_queue[i] <= mem_req;
                mem_rdata_queue [i] <= mem[mem_idx];
                mem_err_queue   [i] <= mem_addr_m2k[31:$clog2(MEM_SZ)] != '0;
            end else begin
                mem_rvalid_queue[i] <= mem_rvalid_queue[i-1];
                mem_rdata_queue [i] <= mem_rdata_queue [i-1];
                mem_err_queue   [i] <= mem_err_queue   [i-1];
            end
        end
        if ((MEM_LATENCY) == 1)begin
            mem_rvalid <= mem_req;
            mem_rdata  <= mem[mem_idx];
            mem_err    <= mem_addr_m2k[31:$clog2(MEM_SZ)] != '0;
        end else begin
            mem_rvalid <= mem_rvalid_queue[MEM_LATENCY-1];
            mem_rdata  <= mem_rdata_queue [MEM_LATENCY-1];
            mem_err    <= mem_err_queue   [MEM_LATENCY-1];
        end

	#5;
    end

    logic prog_end, done;
    assign prog_end = mem_req & (mem_addr_m2k == '0);

    integer fd1, fd2, cnt, ref_start, ref_end, dump_start, dump_end;
    string  line, prog_path, ref_path, dump_path;

    initial begin
	$display("STARTING TB");
        done = 1'b0;

        fd1 = $fopen(PROG_PATHS_LIST, "r");
        for (int i = 0; !$feof(fd1); i++) begin
            rst = 1'b1;

            $fgets(line, fd1);

            ref_path   = "/dev/null";
            ref_start  = 0;
            ref_end    = 0;
            dump_path  = "/dev/null";
            dump_start = 0;
            dump_end   = 0;
            cnt = $sscanf(line, "%s %s %x %x %s %x %x", prog_path, ref_path, ref_start, ref_end, dump_path, dump_start, dump_end);

            // continue with next line in case of an empty line (cnt == 0) or an EOF (cnt == -1)
            if (cnt < 1) begin
                continue;
            end

            $display("ABOUT TO READ MEM (%s)", prog_path);
            $readmemh(prog_path, mem);
            $display("FINISHED READ MEM");

	    for(int j = 0; j < MEM_SZ; j++) begin
		    if($isunknown(mem[j])) begin
		        mem[j] = 0;
		    end
	    end

            fd2 = $fopen(ref_path, "w");
	    $display("REF PATH OPEN (%s)", ref_path);
            for (int j = ref_start / (MEM_W/8); j < ref_end / (MEM_W/8); j++) begin
                for (int k = 0; k < MEM_W/32; k++) begin
		    if($isunknown(mem[j][k*32 +: 32])) begin
		        mem[j][k*32 +: 32] = 0;
		    end
 
		    // $display("%x", mem[j][k*32 +: 32]);
                    $fwrite(fd2, "%x\n", mem[j][k*32 +: 32]);
                end
            end
            $fclose(fd2);
	    $display("REF PATH CLOSED");
            #100
            rst = 1'b0;

        // TODO return here
	    $display("STARTING WHILE LOOP");
        while (1) begin
            @(posedge clk);
            if(mem_req == 1'b1) begin
                if(mem_we) begin
                    for (int i = 0; i < MEM_W/8; i++) begin
                        if (mem_be[i]) begin
                            mem[mem_idx][i*8 +: 8] <= mem_wdata[i*8 +: 8];
                        end
                    end
                end 
                else begin
                    @(posedge mmu_rvalid);
                    // $display("INFO: mmu_rdata=%x, correct_val=%x, mem_addr=%x, idx=%x, time=%p", mmu_rdata, mem[mem_idx], mem_addr, mem_idx, $time);
                
                    // assert(mmu_rdata == mem[mem_idx]) else $error("GOT DIFFERENT VAL (mem_addr=%x, mmu_rdata=%x, mem[]=%x", mem_addr, mmu_rdata, mem[mem_idx]);
                end
            end

            if (prog_end) begin
                break;
            end
        end
	    $display("OUT OF WHILE LOOP");

        fd2 = $fopen(dump_path, "w");
        for (int j = dump_start / (MEM_W/8); j < dump_end / (MEM_W/8); j++) begin
            for (int k = 0; k < MEM_W/32; k++) begin
                $fwrite(fd2, "%x\n", mem[j][k*32 +: 32]);
            end
        end
        $fclose(fd2);
    end
    $fclose(fd1);
    done = 1'b1;
    $finish;
end

initial begin
    $dumpfile("v_add_new.vcd");
    $dumpvars(0, vproc_tb);
end

initial begin
    #30000
    $display("full_tb ending at 20000");
    $finish;
end


endmodule