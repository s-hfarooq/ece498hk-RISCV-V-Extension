
module spi_test_tb();

    parameter SPI_MODE = 3;           // CPOL = 1, CPHA = 1
    parameter CLKS_PER_HALF_BIT = 4;  // 6.25 MHz
    parameter MAIN_CLK_DELAY = 2;     // 25 MHz
    parameter MAX_BYTES_PER_CS = 2;   // 2 bytes per chip select
    parameter CS_INACTIVE_CLKS = 10;  // Adds delay between bytes
  
    // Inputs
    logic i_Rst_L;     // FPGA Reset
    logic i_Clk;       // FPGA Clock

    // TX (MOSI) Signals
    logic [$clog2(MAX_BYTES_PER_CS+1)-1:0] i_TX_Count;  // # bytes per CS low
    logic [7:0]  i_TX_Byte;       // Byte to transmit on MOSI
    logic        i_TX_DV;         // Data Valid Pulse with i_TX_Byte
    logic  i_SPI_MISO;

    // Outputs
    // RX (MISO) Signals
    logic       o_TX_Ready;      // Transmit Ready for next byte
    logic [$clog2(MAX_BYTES_PER_CS+1)-1:0] o_RX_Count;  // Index RX byte
    logic       o_RX_DV;     // Data Valid pulse (1 clock cycle)
    logic [7:0] o_RX_Byte;   // Byte received on MISO

    // SPI Interface
    logic o_SPI_Clk;
    logic o_SPI_MOSI;
    logic o_SPI_CS_n;

    logic [7:0] expected_val;
    assign expected_val = 8'hBE;
    
    SPI_Master_With_Single_CS dut(.*);

    // Clock Synchronizer for Student Use
    default clocking tb_clk @(negedge i_Clk); endclocking

    always begin
        #1 i_Clk = ~i_Clk;
    end

    initial begin
        i_Clk = 0;
    end

    task reset();
        ##1;
        i_Rst_L <= 1'b0;

        i_TX_Count <= '{default: '0};  // # bytes per CS low
        i_TX_Byte <= 8'b0;       // Byte to transmit on MOSI
        i_TX_DV <= 1'b0;         // Data Valid Pulse with i_TX_Byte
        i_SPI_MISO <= 1'b0;

        ##1;
        i_Rst_L <= 1'b1;
        ##1;
    endtask : reset

    task write_to_spi(input [7:0] data);
        ##1;
        i_TX_Byte <= data;
        i_TX_DV   <= 1'b1;
        ##1;
        i_TX_DV <= 1'b0;

        for(int unsigned i = 0; i < 8; i++) begin
            @(posedge o_SPI_Clk);
            $displayh("(i = %p, o_SPI_MOSI = %h, expected_val = %h", i, o_SPI_MOSI, data[7 - i]);
            assert (o_SPI_MOSI == data[7 - i]) else $error("OUT DIFFERENT THAN EXPECTED (i = %p, o_SPI_MOSI = %h, expected_val = %h", i, o_SPI_MOSI, data[7 - i]); 
        end
        @(posedge o_TX_Ready);
    endtask : write_to_spi


    
    initial begin : TESTS
        $display("Starting SPI tests...");
        reset();
        ##1;

        // write_to_spi(8'h03);
        // write_to_spi(8'hAD);
        write_to_spi(8'hBE);
        // write_to_spi(8'hEF);

        $display("Finished SPI tests...");
        $finish;
    end
endmodule
