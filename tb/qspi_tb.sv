// From Stanley, modified

module qspi_tb;

            logic           s_pclk;
            logic           s_presetn;
            logic   [31:0]  s_paddr;
            logic           s_psel;
            // logic           s_penable;
            logic           s_pwrite;
            logic           s_pready;
            logic   [31:0]  s_prdata;

            logic   [3:0]   qspi_io_i;
            logic   [3:0]   qspi_io_o;
            logic   [3:0]   qspi_io_t;
            logic           qspi_ck_o;
            logic           qspi_cs_o;

initial s_pclk = 1'b0;
always #1 s_pclk = ~s_pclk;

qspi_controller qspi_controller_dut(.*);
qspi_stub qspi_stub(.*);

task reset();
    s_presetn <= 1'b0;
    s_paddr <= 'x;
    s_psel <= '0;
    // s_penable <= '0;
    s_pwrite <= 'x;
    // qspi_io_i <= '1;
    #2
    s_presetn <= 1'b1;
    #2 begin end
endtask

task test_read(input [31:0] addr_in);
    @(posedge s_pclk)
    $display("s_pclk posedge");
    // s_paddr <= 32'h0000_0007;
    s_paddr <= addr_in;
    s_pwrite <= 1'b0;
    s_psel <= 1'b1;
    // s_penable <= 1'b0;
    @(posedge s_pclk)
    $display(qspi_controller_dut.state);
    $display("s_pclk posedge");
    // s_penable <= 1'b1;
    @(posedge s_pready)
    $display("received data = %h", s_prdata);
    @(negedge s_pready)
    s_paddr <= 'x;
    s_pwrite <= 'x;
    s_psel <= 1'b0;
    // s_penable <= 1'b0;
endtask

// task test_write();
//     @(posedge s_pclk)
//     s_paddr <= 32'haa551234;
//     s_pwrite <= 1'b1;
//     s_psel <= 1'b1;
//     s_penable <= 1'b0;
//     @(posedge s_pclk)
//     s_penable <= 1'b1;
//     @(posedge s_pready)
//     @(negedge s_pready)
//     s_paddr <= 'x;
//     s_pwrite <= 'x;
//     s_psel <= 1'b0;
//     s_penable <= 1'b0;
// endtask

initial begin
    // $fsdbDumpfile("dump.fsdb");
    // $fsdbDumpvars();
    for(int unsigned i = 28; i < 32; i++) begin
        reset();
        test_read(i[31:0]);
    end
    // test_write();
    #2
    $finish;
end

// initial begin
//     #1000
//     $finish;
// end

endmodule
