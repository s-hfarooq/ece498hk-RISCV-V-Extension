
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
    logic [3:0] external_qspi_io_i;
    logic [3:0] programming_qspi_io_o;
    logic [3:0] programming_qspi_io_t;
    logic programming_qspi_ck_o;
    logic programming_qspi_cs_o;
 
    // Outputs
    logic [31:0] d_out;
    logic out_valid;
    logic [3:0] external_qspi_io_o;
    logic [3:0] external_qspi_io_t;
    logic external_qspi_ck_o;
    logic external_qspi_cs_o;
    logic [3:0] programming_qspi_io_i;

    storage_controller dut(.*);
    qspi_stub qspi_stub(
        .qspi_io_i(external_qspi_io_i),
        .qspi_io_o(external_qspi_io_o),
        .qspi_io_t(external_qspi_io_t),
        .qspi_ck_o(external_qspi_ck_o),
        .qspi_cs_o(external_qspi_cs_o)
    );

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
        programming_qspi_io_o <= 4'b0;
        programming_qspi_io_t <= 4'b0;
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

        // Set all possible methods of programming SPI, ensure output at storage SPI is same as input
        for(int unsigned i = 0; i <= 10'hFFF; i++) begin
            // $displayh("Current iteration: %p", i[2:0]);
            programming_qspi_io_o <= i[3:0];
            programming_qspi_io_t <= i[7:4];
            programming_qspi_ck_o <= i[8];
            programming_qspi_cs_o <= i[9];

            ##1; // should this delay exist?
            assert (external_qspi_io_o == i[3:0]) else $error("external_qspi_io_o not same as expected (i = %p)", i);
            assert (external_qspi_io_t == i[7:4]) else $error("external_qspi_io_t not same as expected (i = %p)", i);
            assert (external_qspi_ck_o == i[8]) else $error("external_qspi_ck_o not same as expected (i = %p)", i);
            assert (external_qspi_cs_o == i[9]) else $error("external_qspi_cs_o not same as expected (i = %p)", i);
            ##1;
        end

        // Ensure storage output sets programming input correctly
        // external_storage_spi_miso <= 1'b0;
        // ##1;
        // assert (programming_spi_miso == 1'b0) else $error("programming_spi_miso not same as expected (should be 0)");
        // ##1;
        // external_storage_spi_miso <= 1'b1;
        // ##1;
        // assert (programming_spi_miso == 1'b1) else $error("programming_spi_miso not same as expected (should be 1)");
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
        ##1;

        d_in <= 32'b0;
        mem_be <= 4'b0;
        memory_is_writing <= 1'b0;
        memory_access <= 1'b1;
        external_storage_access <= 1'b1;
        addr <= addr_val_in;

        @(posedge out_valid);
        $display("DOUT = %h", d_out);
        memory_access <= 1'b0;
        // assert (d_out == opcode[7 - i]) else $error("OUT DIFFERENT THAN EXPECTED (i = %p, o_SPI_MOSI = %h, expected_val = %h", i, external_storage_spi_mosi, opcode[7 - i]); 
    endtask : read_from_external

    
    initial begin : TESTS
        $display("Starting storage controller tests...");
        reset();

        ##1;
        $display("Starting read_from_external tests...");
        read_from_external(32'h0000_0005);
        $display("Finished read_from_external tests...");
        reset();
        ##1;

        ##1;
        $display("Starting spi_passthrough tests...");
        spi_passthrough();
        $display("Finished spi_passthrough tests...");
        reset();
        ##1;

        ##1;
        $display("Starting write_and_read_to_sram tests...");
        write_and_read_to_sram();
        $display("Finished write_and_read_to_sram tests...");
        reset();
        ##1;

        $display("Finished storage controller tests...");
        $finish;
    end
endmodule
