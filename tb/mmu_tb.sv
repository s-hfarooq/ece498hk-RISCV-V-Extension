
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
    // Flash storage SPI
    logic external_storage_spi_cs_n;
    logic external_storage_spi_sck;
    logic external_storage_spi_mosi;
    // Programming SPI
    logic programming_spi_miso;

    // Inout
    // To/from GPIO
    wire [9:0] gpio_pins;

    // Set input pins to 0's
    genvar gpio_incr;
    generate
        for(gpio_incr = 1; gpio_incr < 10; gpio_incr += 2) begin
            assign gpio_pins[gpio_incr] = 1'b0;
        end
    endgenerate

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
        // Set pin direction
        for(int unsigned i = 32'h0000_0101; i <= 32'h0000_010A; i++) begin
            vproc_mem_req_o <= 1'b1;
            vproc_mem_addr_o <= i[31:0];
            vproc_mem_we_o <= 1'b1;

            if(i % 2 == 0) begin
                $displayh("Setting pin %h to input", i);
                vproc_mem_wdata_o <= 32'h0000_0001;
            end else begin
                vproc_mem_wdata_o <= 32'h0000_0000;
            end

            ##1;
            assert (dut.gpio_direction[i - 32'h0000_0101] == (i % 2 == 0)) else $error("Pin direction did not set properly (i = %p)", i);
            vproc_mem_req_o <= 1'b0;
            vproc_mem_we_o <= 1'b0;
            ##1;
        end
        
        $displayh("Finished setting direction");
        $displayh("State: %b", dut.gpio_direction);
        $displayh("Value: %b", dut.gpio_curr_value);

        // Write to output pins
        for(int unsigned i = 32'h0000_010B; i <= 32'h0000_0114; i++) begin
            if(i % 2 == 1) begin
                vproc_mem_req_o <= 1'b1;
                vproc_mem_addr_o <= i[31:0];
                vproc_mem_we_o <= 1'b1;
                vproc_mem_wdata_o <= 32'h0000_0001;

                $displayh("Setting pin %h to high", i);
            end
            ##1;

            if (i % 2 == 1) begin
                assert (gpio_pins[i - 32'h0000_010B] == 1'b1) else $error("Pin value (1) did not set properly (i = %p)", i);
            end

            vproc_mem_req_o <= 1'b0;
            vproc_mem_we_o <= 1'b0;
            ##1;
        end

        $displayh("Finished setting output pins");
        $displayh("State: %b", dut.gpio_direction);
        $displayh("Value: %b", dut.gpio_curr_value);
        $displayh("gpio_pins: %b", gpio_pins);

        // Read input pins
        for(int unsigned i = 32'h0000_010B; i <= 32'h0000_0114; i++) begin
            if(i % 2 == 0) begin
                vproc_mem_req_o <= 1'b1;
                vproc_mem_addr_o <= i[31:0];
                vproc_mem_we_o <= 1'b0;
                vproc_mem_wdata_o <= 32'h0000_0000;

                ##1;
                $displayh("Reading pin %h... val = %b", i, vproc_mem_rdata_i[0]);
                assert (vproc_mem_rdata_i[0] == 1'b0) else $error("Read pin value is incorrect (i = %p)", i);
            end

            vproc_mem_req_o <= 1'b0;
            vproc_mem_we_o <= 1'b0;
            ##1;
        end
    endtask: gpio_test

    task timer_test();
        for(int unsigned i = 1; i < 100; i += 5) begin
            vproc_mem_req_o <= 1'b1;
            vproc_mem_we_o <= 1'b1;
            vproc_mem_addr_o <= 32'h0000_0115;
            vproc_mem_wdata_o <= i[31:0];
            ##2; // TODO: works when this is 2, but should it also work when 1?
            vproc_mem_req_o <= 1'b0;
            vproc_mem_we_o <= 1'b0;
            assert (dut.digitalTimer.counter_trigger_val == i[31:0]) else $error("Timer did not set properly (i = %p)", i);

            for(int j = 1; j < i; j++) begin
                ##1;
                assert (dut.digitalTimer.timer_is_high == 1'b0) else $error("timer_is_high HIGH BEFORE IT SHOULD BE (i = %p)", i);
            end

            vproc_mem_req_o <= 1'b1;
            vproc_mem_addr_o <= 32'h0000_0115;
            ##1;
            assert (vproc_mem_rdata_i[0] == 1'b1) else $error("timer_is_high IS NOT HIGH WHEN IT SHOULD BE (i = %p)", i);

            vproc_mem_req_o <= 1'b0;
            ##1;
        end
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
