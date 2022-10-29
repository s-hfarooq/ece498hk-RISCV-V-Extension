
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

    // To/from digital timer
    input  logic timer_is_high,
    output logic [31:0] timer_set_val,
    output logic set_timer,

    // To/from GPIO
    inout  logic [9:0] gpio_pins

    // To/from external SPI
);

//                       MEMORY ADDRESSES
// | Address Range              | Device                |
// | -------------------------- | --------------------- |
// | 0x0000_0000 - 0x0000_0100  | Reserved              |
// | 0x0000_0101 - 0x0000_010A  | GPIO                  |
// | 0x0000_010B                | Digital Timer         |
// | 0x0000_010C - 0x0000_0FFF  | Reserved              |
// | 0x0000_1000 - 0x0000_1FFF  | SRAM Scratch Memory   |
// | 0x0000_2000 - 0xFFFF_FFFF  | External Storage      |


// STORAGE_CONTROLLER SIGNALS
logic memory_access;
logic [31:0] storage_controller_d_out;
logic storage_out_valid;

// Save data in since mem access can take >1 clock cycle and the input values are only valid for 1
// TODO: make sure vicuna stalls until mem_rvalid_i goes high for data read/write
logic [31:0] curr_addr;
logic [MEM_W  -1:0] curr_d_in;
logic [MEM_W/8-1:0] curr_mem_be;
logic curr_mem_we;
logic started_mem_access; 

storage_controller storage_controller (
    .clk(clk),
    .rst(rst),
    .memory_access(memory_access), // If high, we're doing something with memory
    .memory_is_writing(memory_is_writing),
    .addr(curr_addr),
    .d_in(curr_d_in),
    .mem_be(curr_mem_be),
    .d_out(storage_controller_d_out),
    .out_valid(storage_out_valid)

    // To/from external SPI
);


enum logic [2:0] {
    default_state,
    memory_state_init,
    memory_state_continue,
    timer_state,
    gpio_state
} state, next_state;

always_ff @(posedge clk) begin
    if (rst) begin
        state <= default_state;
        next_state <= default_state;
        
        curr_addr <= 32'b0;
        curr_d_in <= '{default: '0};
        curr_mem_be <= '{default: '0};
        curr_mem_we <= 1'b0;
        started_mem_access <= 1'b0;
    end else begin
        state <= next_state;
    end
end

// Determine next state
always_comb begin
    if (state == memory_state && ~memory_response) begin
        // Stay in memory state if memory hasn't responded yet
        next_state <= memory_state;
    end else if (vproc_mem_req_o) begin
        if (vproc_mem_addr_o >= 32'h0000_0000 && vproc_mem_addr_o <=  32'h0000_0100) begin
            // Reserved
            next_state <= default_state;
        end else if (vproc_mem_addr_o >= 32'h0000_0101 && vproc_mem_addr_o <= 32'h0000_010A) begin
            // GPIO
            next_state <= gpio_state;
        end else if (vproc_mem_addr_o == 32'h0000_010B) begin
            // Digital timer
                next_state <= timer_state;
        end else if (vproc_mem_addr_o >= 32'h0000_010C && vproc_mem_addr_o <= 32'h0000_0FFF) begin
            // Reserved
            next_state <= default_state;
        end else begin
            // SRAM/external storage
            if (vproc_mem_err_i) begin
                // If we get a error, go to default state
                next_state <= default_state;
            end else begin
                // Go to default state once storage returns valid value
                if (storage_out_valid) begin
                    next_state <= default_state;
                end else begin
                    if (started_mem_access) begin
                        next_state <= memory_state_continue;
                    end else begin
                        next_state <= memory_state_init;
                    end
                end
            end
        end
    end else begin
        // Stay in same state if mem req goes low (or should this be default state instead?)
        next_state <= state;
    end
end

// Determine signal values
always_comb begin
    // Default values for outputs
    // To/from Vicuna/Ibex
    vproc_mem_rvalid_i <= 1'b0;
    vproc_mem_err_i <= 1'b0;
    vproc_mem_rdata_i <= '{default: '0};

    // To/from digital timer
    timer_set_val <= 32'b0;
    set_timer <= 1'b0;

    memory_access <= 1'b0;
    memory_is_writing <= 1'b0;
    
    unique case (state)
        default_state:
            begin
                // Nothing should happen in default state?
            end
        memory_state_init:
            begin
                // Initial memory access cycle - set values so that we save them since input becomes invalidated
                if (vproc_mem_req_o) begin
                    if (vproc_mem_we_o && (vproc_mem_addr_o >= 32'h0000_2000 || vproc_mem_addr_o <= 32'h0000_0FFF)) begin
                        vproc_mem_err_i <= 1'b1;
                    end else begin
                        curr_addr <= vproc_mem_addr_o;
                        curr_d_in <= vproc_mem_wdata_o;
                        curr_mem_be <= vproc_mem_be_o;
                        curr_mem_we <= vproc_mem_we_o;
                        started_mem_access <= 1'b1;

                        memory_access <= 1'b1;
                        if (vproc_mem_we_o) begin
                            memory_is_writing <= 1'b1;
                        end

                        if (storage_out_valid) begin
                            vproc_mem_rdata_i <= storage_controller_d_out;
                            vproc_mem_rvalid_i <= 1'b1;
                            started_mem_access <= 1'b0;
                        end
                    end
                end
            end
        memory_state_continue:
            begin
                // Continue giving storage controller same input until it returns that it's done
                if (~storage_out_valid) begin
                    memory_access <= 1'b1;
                    if (curr_mem_we) begin
                        memory_is_writing <= 1'b1;
                    end
                end else begin
                    vproc_mem_rdata_i <= storage_controller_d_out;
                    vproc_mem_rvalid_i <= 1'b1;
                    started_mem_access <= 1'b0;
                end
            end
        timer_state:
            begin
                if (vproc_mem_req_o) begin
                    // If writing to timer, we should be setting its value
                    if (vproc_mem_we_o) begin
                        timer_set_val <= vproc_mem_wdata_o; 
                        set_timer <= 1'b1;
                    end else begin
                        vproc_mem_rdata_i <= {31'b0, timer_is_high};
                        vproc_mem_rvalid_i < 1'b1;
                    end
                end
            end
        gpio_state:
            begin
                if (vproc_mem_req_o) begin
                    // TODO: figure out how to determine if pin in input or output
                    if (vproc_mem_we_o) begin
                        
                    end else begin
                        
                    end
                end
            end
        default:
            begin
                // Nothing should happen in default state?
            end
    endcase
end

endmodule : mmu
