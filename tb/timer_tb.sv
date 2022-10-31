
module timer_tb();
    // timeunit 10ns;
    // timeprecision 1ns; // TODO: are these needed?

    // Inputs
    logic clk;
    logic rst;
    logic [31:0] timer_set_val;
    logic set_timer;

    // Outputs
    logic timer_is_high;

    digitalTimer dut(.*);

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
        timer_set_val <= 32'b0;
        set_timer <= 1'b0;

        ##1;
        rst <= 1'b1;
        ##1;
    endtask : reset

    task set_timer_val(int val);
        // $displayh("Setting timer to %p", val[31:0]);
        timer_set_val <= val[31:0];
        set_timer <= 1'b1;
        ##1;
        set_timer <= 1'b0;
    endtask : set_timer_val
    
    initial begin : TESTS
        $display("Starting digital timer tests...");
        reset();
        ##1;

        for(int i = 1; i < 32'hFFFF_FFFF; i++) begin
            reset();
            ##1;

            if(i % 1000 == 0)
                $displayh("On iteration %p", i);

            set_timer_val(i);

            for(int j = 0; j < i; j++) begin
                assert (timer_is_high == 1'b0) else $error("timer_is_high HIGH BEFORE IT SHOULD BE (i = %p)", i);
                ##1;
            end

            assert (timer_is_high == 1'b1) else $error("timer_is_high IS NOT HIGH WHEN IT SHOULD BE (i = %p)", i);
        end

        $display("Finished digital timer tests...");
        $finish;
    end
endmodule
