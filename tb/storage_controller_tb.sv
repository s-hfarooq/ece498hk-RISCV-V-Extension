
module timer_tb();
    // timeunit 10ns;
    // timeprecision 1ns; // TODO: are these needed?

    // Inputs
    logic clk;
    logic rst;
    logic memory_access;
    logic memory_is_writing;
    logic [31:0] addr;
    logic [31:0] d_in;
    logic [32/8-1:0] mem_be;
    logic set_programming_mode;
    logic external_storage_spi_miso;
    logic programming_spi_miso;

    // Outputs
    logic [31:0] d_out;
    logic out_valid;
    logic external_storage_spi_cs_n;
    logic external_storage_spi_sck;
    logic external_storage_spi_mosi;
    logic programming_spi_cs_n;
    logic programming_spi_sck;
    logic programming_spi_mosi;

    storage_controller dut(.*);

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
        [31:0] addr <= 32'b0;
        [31:0] d_in <= 32'b0;
        [32/8-1:0] mem_be <= '{default: '0};
        set_programming_mode <= 1'b0;
        external_storage_spi_miso <= 1'b0;
        programming_spi_miso <= 1'b0;

        ##1;
        rst <= 1'b1;
        ##1;
    endtask : reset

    task spi_passthrough();
    endtask : spi_passthrough

    task read_from_sram();
    endtask : read_from_sram

    task write_to_sram();
    endtask : write_to_sram

    task read_from_external();
    endtask : read_from_external

    
    initial begin : TESTS
        $display("Starting storage controller tests...");
        reset();
        ##1;

        $display("Finished storage controller tests...");
        $finish;
    end
endmodule
