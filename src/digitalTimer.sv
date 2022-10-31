
module digitalTimer (
    input logic clk,
    input logic rst,

    output logic timer_is_high,
    input logic [31:0] timer_set_val,
    input logic set_timer
);

logic [31:0] counter;
logic [31:0] counter_trigger_val;

always_ff @ (posedge clk) begin
    counter <= counter + 1'b1;

    if (~rst) begin
        // Reset state
        counter <= 32'b0;
        counter_trigger_val <= 32'b0;
        timer_is_high <= 1'b0;
    end else if (set_timer) begin
        // Set timer to new val
        counter <= 32'b0;
        counter_trigger_val <= timer_set_val;
        timer_is_high <= 1'b0;
    end else if (counter >= counter_trigger_val) begin
        // Set output to high when timer val reached
        counter <= 32'b0;
        timer_is_high <= 1'b1;
    end else begin
        timer_is_high <= 1'b1;
    end
end

endmodule : digitalTimer
