
module mmu_tb();
    timeunit 10ns;
    timeprecision 1ns; // TODO: are these correct?

    // Inputs
    logic clk;
    logic rst;
    // Set mode inputs
    logic set_programming_mode;
    logic set_debug_mode;
    // To Vicuna/Ibex
    logic vproc_mem_req_o;
    logic [31:0] vproc_mem_addr_o;
    logic vproc_mem_we_o; // high when writing, low when reading
    logic [32/8-1:0] vproc_mem_be_o;
    logic [32  -1:0] vproc_mem_wdata_o;
    // To digital timer
    logic timer_is_high;
    // Flash storage SPI
    logic external_storage_spi_miso;
    // Programming SPI
    logic programming_spi_cs_n;
    logic programming_spi_sck;
    logic programming_spi_mosi;

    // Outputs
    // From Vicuna/Ibex
    logic vproc_mem_rvalid_i;
    logic vproc_mem_err_i;
    logic [32  -1:0] vproc_mem_rdata_i;
    // From digital timer
    logic [31:0] timer_set_val;
    logic set_timer;
    // Flash storage SPI
    logic external_storage_spi_cs_n;
    logic external_storage_spi_sck;
    logic external_storage_spi_mosi;
    // Programming SPI
    logic programming_spi_miso;

    // Inout
    // To/from GPIO
    logic [9:0] gpio_pins;


    mmu dut(.*);

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

        set_programming_mode <= 1'b0;
        set_debug_mode <= 1'b0;
        // To Vicuna/Ibex
        vproc_mem_req_o <= 1'b0;
        vproc_mem_addr_o <= 32'b0;
        vproc_mem_we_o <= 1'b0; // high when writing, low when reading
        vproc_mem_be_o <= '{default: '0};
        vproc_mem_wdata_o <= 32'b0;
        // To digital timer
        timer_is_high <= 1'b0;
        // Flash storage SPI
        external_storage_spi_miso <= 1'b0;
        // Programming SPI
        programming_spi_cs_n <= 1'b0;
        programming_spi_sck <= 1'b0;
        programming_spi_mosi <= 1'b0;

        ##1;
        rst <= 1'b1;
        ##1;
    endtask : reset

    task gpio_test();
        for(int unsigned i = 32'h0000_0101; i <= 32'h0000_010A; i++) begin
            vproc_mem_req_o <= 1'b1;
            vproc_mem_addr_o <= i[31:0];
            if(i % 2 == 0) begin
                $displayh("Setting pin %h to high", i);
                vproc_mem_wdata_o <= 32'h0000_0001;
            end else begin
                vproc_mem_wdata_o <= 32'h0000_0000;
            end
        end
        $displayh("State: %b", dut.gpio_direction);
        $displayh("Value: %b", dut.gpio_curr_value);
        
    endtask: gpio_test

    task timer_test();
    endtask : timer_test

    task sram_test();
    endtask : sram_test

    task external_storage_test();
    endtask : external_storage_test

    task reserved_addr_test();
    endtask : reserved_addr_test

    initial begin : TESTS
        $display("Starting mmu tests...");
        reset();

        ##1;
        $display("Starting gpio_test tests...");
        gpio_test();
        $display("Finished gpio_test tests...");
        reset();
        ##1;

        // ##1;
        // $display("Starting timer_test tests...");
        // timer_test();
        // $display("Finished timer_test tests...");
        // reset();
        // ##1;

        // ##1;
        // $display("Starting sram_test tests...");
        // sram_test();
        // $display("Finished sram_test tests...");
        // reset();
        // ##1;

        // ##1;
        // $display("Starting external_storage_test tests...");
        // external_storage_test();
        // $display("Finished external_storage_test tests...");
        // reset();
        // ##1;

        // ##1;
        // $display("Starting reserved_addr_test tests...");
        // reserved_addr_test();
        // $display("Finished reserved_addr_test tests...");
        // reset();
        // ##1;

        $display("Finished mmu tests...");
        $finish;
    end
endmodule
