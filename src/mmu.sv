
module mmu #(
    parameter int unsigned     MEM_W         = 32 // memory bus width in bits, same as value in vproc_top.sv
    )(
    input  logic clk,
    input  logic rst,

    // To/from Vicuna/Ibex
    input  logic               vproc_mem_req_o,
    input  logic [31:0]        vproc_mem_addr_o,
    input  logic               vproc_mem_we_o,
    input  logic [MEM_W/8-1:0] vproc_mem_be_o,
    input  logic [MEM_W  -1:0] vproc_mem_wdata_o,
    output logic               vproc_mem_rvalid_i,
    output logic               vproc_mem_err_i,
    output logic [MEM_W  -1:0] vproc_mem_rdata_i,
    input  logic [31:0]        vproc_pend_vreg_wr_map_o,

    // To/from digital timer
    input  logic timer_is_high,
    output logic [31:0] timer_set_val,
    output logic set_timer,

    // To/from GPIO
    inout logic [9:0] gpio_pins
);

//                       MEMORY ADDRESSES
// | Address Range              | Device                |
// | -------------------------- | --------------------- |
// | 0x0000_0000 - 0x0000_0100  | Reserved              |
// | 0x0000_0101 - 0x0000_010A  | GPIO                  |
// | 0x0000_010B                | Digital Timer         |
// | 0x0000_010C - 0x0000_0FFF  | Reserved              |
// | 0x0000_1000 - 0xFFFF_FFFF  | SRAM/External Storage |


// Possible states
enum logic [2:0] {
    default_state,
    timer_state,
    uart_state,
    sram_state,
    gpio_state
} state, next_state;

// Set state
always_ff @ (posedge Clk) begin
    if (rst) 
        state <= default_state;
        next_state <= default_state;
    else 
        state <= next_state;
end

// State logic
always_comb begin
    unique case (state)
        default_state:
            begin
            end
        timer_state:
            begin
                vproc_mem_rvalid_i <= 1'b1;
                vproc_mem_err_i <= 1'b0;
                vproc_mem_rdata_i <= {(MEM_W-2)'b0, timer_is_high};
            end
        uart_state:
            begin
            end
        sram_state:
            begin
            end
        gpio_state:
            begin
            end
        default:
            begin
                vproc_mem_rvalid_i <= 1'b0;
                vproc_mem_err_i <= 1'b0;
                vproc_mem_rdata_i <= (MEM_W-1)'b0;
            end
    endcase
end

// State machine
always_comb begin
    if (rst) begin
        vproc_mem_rvalid_i <= 1'b0;
        vproc_mem_err_i <= 1'b0;
        vproc_mem_rdata_i <= (MEM_W-1)'b0;
    end else begin
        unique case (state)
            default_state:
                begin
                    if (addr == 32'h10) begin // timer
                        next_state <= gpio_state;
                    end else if (read_uart) begin // uart
                        next_state <= uart_state;
                    end else if (read_sram) begin // sram
                        next_state <= sram_state;
                    end else if (addr >= 32'h11 && addr <= 32'h1B) begin // gpio
                        next_state <= gpio_state;
                    end
                end
            timer_state:
                begin
                    next_state <= default_state;
                end
            uart_state:
                begin
                    if (uart_done_signal)
                        next_state <= default_state;
                    else
                        next_state <= uart_state;
                end
            sram_state:
                begin
                    next_state <= default_state;
                end
            gpio_state:
                begin
                    next_state <= default_state;
                end
            default:
                begin
                    next_state <= default_state;
                end
        endcase
    end
end


endmodule : mmu
