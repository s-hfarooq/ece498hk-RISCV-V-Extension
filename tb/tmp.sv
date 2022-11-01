// I thought sram no work but it do I may be stupid/
module tmp_tb();
    timeunit 10ns;
    timeprecision 1ns; // TODO: are these correct?

    // Inputs
    logic clk;
    logic rst;
    logic [31:0] sram_d_out; // out
    logic sram_chip_en; // in
    logic sram_wr_en; // in
    logic [10:0] sram_addr; // in
    logic [31:0] sram_d_in; // in
    logic [2:0] sram_ema; // in
    logic sram_retn; // in

    sram_sp_hdc_svt_rvt_hvt dut(
        .Q(sram_d_out),
        .CLK(clk),
        .CEN(sram_chip_en),
        .WEN(sram_wr_en),
        .A(sram_addr),
        .D(sram_d_in),
        .EMA(sram_ema),
        .RETN(sram_retn)
    );

    // Clock Synchronizer for Student Use
    default clocking tb_clk @(negedge clk); endclocking

    always begin
        #1 clk = ~clk;
    end

    initial begin
        clk = 0;
    end

    task test_sram();
        ##1;

        sram_chip_en <= 1'b0;
        sram_wr_en <= 1'b0; // in
        sram_addr <= 11'h00F; // in
        sram_d_in <= 32'h0000_000E; // in
        sram_ema <= 3'b0; // in
        sram_retn <= 1'b1; // in
        ##1;

        sram_chip_en <= 1'b1;
        sram_wr_en <= 1'b1; // in
        sram_addr <= 11'h000; // in
        sram_d_in <= 32'h0000_0000; // in
        sram_ema <= 3'b0; // in
        sram_retn <= 1'b1; // in
        ##1;

        sram_chip_en <= 1'b0;
        sram_wr_en <= 1'b1; // in
        sram_addr <= 11'h00F; // in
        sram_ema <= 3'b0; // in
        sram_retn <= 1'b1; // in
        assert (sram_d_out == 32'h0000_000E) else $error("NOT CORRECT OUTPUT (%p)", sram_d_out);
    endtask : test_sram
    
    initial begin : TESTS
        $display("Starting storage controller tests...");

        ##1;
        $display("Starting test_sram tests...");
        test_sram();
        $display("Finished test_sram tests...");
        ##1;

        $display("Finished storage controller tests...");
        $finish;
    end
endmodule
