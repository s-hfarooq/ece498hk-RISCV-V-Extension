
module storage_controller_tb();
    timeunit 10ns;
    timeprecision 1ns; // TODO: are these correct?

    // Inputs
    logic clk;
    logic rst;
    logic memory_access;
    logic memory_is_writing;
    logic [31:0] addr;
    logic [31:0] d_in;
    logic [32/8-1:0] mem_be;
    logic set_programming_mode;
    logic external_storage_access;
    logic programming_qspi_ck_o;
    logic programming_qspi_cs_o;
 
    // Outputs
    logic [31:0] d_out;
    logic out_valid;
    logic external_qspi_ck_o;
    logic external_qspi_cs_o;

    // inout
    wire [3:0] external_qspi_pins;
    wire [3:0] programming_qspi_pins;

    // QSPI stub
    logic [3:0] external_qspi_io_i;
    logic [3:0] external_qspi_io_o;
    logic [3:0] external_qspi_io_t;

    logic [3:0] tmp_i;

    logic [3:0] external_pin_tmp;

    assign external_pin_tmp = external_qspi_pins;

    genvar i_incr;
    generate
        for(i_incr = 0; i_incr < 4; i_incr++) begin
            assign programming_qspi_pins[i_incr] = tmp_i[i_incr];

            // assign external_qspi_io_o[i_incr] = (external_qspi_pins[i_incr] == 'z) ? 'z : external_qspi_pins[i_incr];
            // assign external_qspi_io_t[i_incr] = (external_qspi_pins[i_incr] == 'z) ? 1'b1 : 1'b0;


            // assign external_qspi_pins[i_incr] = (external_qspi_pins[i_incr] === 'z) ? external_qspi_io_i[i_incr] : external_pin_tmp[i_incr];

            // assign external_qspi_pins[i_incr] = (external_qspi_io_t[i_incr] == 1'b1) ? external_qspi_io_i[i_incr] : external_pin_tmp[i_incr];            

            assign external_qspi_pins[i_incr] = (external_qspi_io_t[i_incr] == 1'b1) ? external_qspi_io_i[i_incr] : external_pin_tmp[i_incr];            
        end
    endgenerate

    always_comb begin
        for(int unsigned i = 0; i < 4; i++) begin
            if(external_qspi_pins[i] === 'z) begin
                external_qspi_io_o[i] <= 'z;
                // external_qspi_io_t[i] <= 1'b1;
                // external_qspi_pins[i] <= external_qspi_io_i[i];
            end else begin
                external_qspi_io_o[i] <= external_qspi_pins[i];
                // external_qspi_io_t[i] <= 1'b0;
            end
        end
    end

    always begin
        ##1;
        for(int unsigned i = 0; i < 4; i++) begin
            if(external_qspi_io_i[i] === 'z) begin
                //
            end else begin
                $display("external_qspi_io_i[%p] = %x", i, external_qspi_io_i[i]);
            end
        end
    end

    storage_controller dut(.*);
    qspi_stub qspi_stub(
        .qspi_io_i(external_qspi_io_i),
        .qspi_io_o(external_qspi_io_o),
        .qspi_io_t(external_qspi_io_t),
        .qspi_ck_o(external_qspi_ck_o & ~set_programming_mode),
        .qspi_cs_o(external_qspi_cs_o & ~set_programming_mode)
    );

    logic [31:0] mem [2**24];
    initial begin
        $readmemh("/home/hfaroo9/498-integ/ece498hk-RISCV-V-Extension/src/vicuna/sim/vadd_16.vmem", mem);
        // $displayh("mem = %p", mem);
    end

    // Clock Synchronizer for Student Use
    default clocking tb_clk @(negedge clk); endclocking

    always begin
        #1 clk = ~clk;
    end

    initial begin
        clk = 0;
    end

    task reset();
        ##1;
        rst <= 1'b0;

        memory_access <= 1'b0;
        memory_is_writing <= 1'b0;
        addr <= 32'b0;
        d_in <= 32'b0;
        mem_be <= '{default: '0};
        set_programming_mode <= 1'b0;
        external_storage_access <= 1'b0;
        programming_qspi_ck_o <= 1'b0;
        programming_qspi_cs_o <= 1'b0;

        ##1;
        rst <= 1'b1;
        ##1;
    endtask : reset

    task spi_passthrough();
        set_programming_mode <= 1'b1;

        rst <= 1'b0;
        ##1;
        rst <= 1'b1;
        ##1;

        // external_qspi_io_o <= 4'b0;
        // external_qspi_io_t <= 4'b0;

        for(int unsigned i = 0; i < 6'h3F; i++) begin
            programming_qspi_ck_o <= i[0];
            programming_qspi_cs_o <= i[1];
            tmp_i <= i[5:2];

            ##1;
            
            assert (external_qspi_ck_o == i[0]) else $error("external_qspi_ck_o not same as expected (external_qspi_ck_o = %p, i = %p)", external_qspi_ck_o, i);
            assert (external_qspi_cs_o == i[1]) else $error("external_qspi_cs_o not same as expected (external_qspi_cs_o = %p, i = %p)", external_qspi_cs_o, i);
            assert (external_qspi_pins == i[5:2]) else $error("external_qspi_io_o not same as expected (external_qspi_io_o = %p, i = %p)", external_qspi_pins, i);
        end
    endtask : spi_passthrough

    task write_and_read_to_sram();
        external_storage_access <= 1'b0;

        for(int unsigned i = 0; i <= 11'h7FF; i++) begin
            ##1;
            memory_access <= 1'b1;
            memory_is_writing <= 1'b1;
            addr <= i[31:0];
            d_in <= i[31:0];
            mem_be <= 4'hF;
            ##1;

            memory_access <= 1'b0;
            memory_is_writing <= 1'b0;
            addr <= 32'b0;
            d_in <= 32'b0;
            mem_be <= 4'b0;
            ##1;

            memory_access <= 1'b1;
            addr <= i[31:0];
            while(out_valid == 1'b0) begin
                ##1;
            end
            assert (i[31:0] == d_out) else $error("d_out not same as expected (i = %p, d_out = %p)", i, d_out);
            ##1;

            memory_access <= 1'b0;
            addr <= 32'b0;
            ##1;
        end
    endtask : write_and_read_to_sram

    task read_from_external(input [31:0] addr_val_in);
        $display("Starting addr %x", addr_val_in);
        ##1;

        d_in <= 32'b0;
        mem_be <= 4'b0;
        memory_is_writing <= 1'b0;
        memory_access <= 1'b1;
        external_storage_access <= 1'b1;
        addr <= addr_val_in;

        while(out_valid == 1'b0) begin
            ##1;
        end

        memory_access <= 1'b0;
        assert (d_out == mem[addr_val_in]) else $error("d_out DIFFERENT THAN EXPECTED (addr = %h, d_out = %h, expected = %h", addr_val_in, d_out, mem[addr_val_in]); 
    endtask : read_from_external

    
    initial begin : TESTS
        $display("Starting storage controller tests...");
        reset();

        // ##1;
        // $display("Starting spi_passthrough tests...");
        // spi_passthrough();
        // $display("Finished spi_passthrough tests...");
        // reset();
        // ##1;

        ##1;
        $display("Starting read_from_external tests...");
        // TODO: For some reason when this is the last test it fails
        for(int unsigned i = 0; i < 32'h0000_0050; i++) begin
            read_from_external(i[31:0]);
        end
        $display("Finished read_from_external tests...");
        reset();
        ##1;

        // ##1;
        // $display("Starting write_and_read_to_sram tests...");
        // write_and_read_to_sram();
        // $display("Finished write_and_read_to_sram tests...");
        // reset();
        // ##1;
        

        $display("Finished storage controller tests...");
        $finish;
    end

    initial begin
        $dumpfile("storage_controller_tb.vcd");
        $dumpvars(0, storage_controller_tb);
    end
endmodule
