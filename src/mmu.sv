
module mmu #(
    parameter int unsigned     MEM_W         = 32 // memory bus width in bits, same as value in vproc_top.sv
    )(
    input  logic clk,
    input  logic rst,

    // Set mode inputs
    input  logic set_programming_mode,
    input  logic set_debug_mode, // Never used

    // To/from Vicuna/Ibex
    input  logic               vproc_mem_req_o,
    input  logic [31:0]        vproc_mem_addr_o,
    input  logic               vproc_mem_we_o, // high when writing, low when reading
    input  logic [MEM_W/8-1:0] vproc_mem_be_o,
    input  logic [MEM_W  -1:0] vproc_mem_wdata_o,
    output logic               vproc_mem_rvalid_i,
    output logic               vproc_mem_err_i,
    output logic [MEM_W  -1:0] vproc_mem_rdata_i,

    // To/from GPIO
    inout wire [9:0] gpio_pins,

    // To/from storage SPI
    input   logic   [3:0]           external_qspi_io_i,
    output  logic   [3:0]           external_qspi_io_o,
    output  logic   [3:0]           external_qspi_io_t,
    output  logic                   external_qspi_ck_o,
    output  logic                   external_qspi_cs_o,

    // To/from programming SPI
    output logic   [3:0]           programming_qspi_io_i,
    input  logic   [3:0]           programming_qspi_io_o,
    input  logic   [3:0]           programming_qspi_io_t,
    input  logic                   programming_qspi_ck_o,
    input  logic                   programming_qspi_cs_o
);

//                       MEMORY ADDRESSES
// | Address Range              | Device                |
// | -------------------------- | --------------------- |
// | 0x0000_0000 - 0x0000_0100  | Reserved              |
// | 0x0000_0101 - 0x0000_010A  | GPIO Pin Set          |
// | 0x0000_010B - 0x0000_0114  | GPIO                  |
// | 0x0000_0115                | Digital Timer         |
// | 0x0000_0116 - 0x0000_0FFF  | Reserved              |
// | 0x0000_1000 - 0x0000_1FFF  | SRAM Scratch Memory   |
// | 0x0000_2000 - 0xFFFF_FFFF  | External Storage      |


// STORAGE_CONTROLLER SIGNALS
logic memory_access;
logic [31:0] storage_controller_d_out;
logic storage_out_valid;
logic external_storage_access;

// Save data in since mem access can take >1 clock cycle and the input values are only valid for 1
// TODO: make sure vicuna stalls until mem_rvalid_i goes high for data read/write
logic [31:0] curr_addr;
logic [MEM_W  -1:0] curr_d_in;
logic [MEM_W/8-1:0] curr_mem_be;
logic curr_mem_we;

// GPIO pin logic
logic [9:0] gpio_direction; // 0 = output, 1 = input
logic [9:0] gpio_curr_value;

// TIMER LOGIC
logic timer_is_high;
logic [31:0] timer_set_val;
logic set_timer;

storage_controller #(.MEM_W(MEM_W)) storage_controller (
    .clk(clk),
    .rst(rst),
    .memory_access(memory_access), // If high, we're doing something with memory
    .memory_is_writing(curr_mem_we),
    .addr(curr_addr),
    .d_in(curr_d_in),
    .mem_be(curr_mem_be),
    .d_out(storage_controller_d_out),
    .out_valid(storage_out_valid),

    .set_programming_mode(set_programming_mode),
    .external_storage_access(external_storage_access),

    // // Flash storage SPI
    // .external_storage_spi_cs_n(external_storage_spi_cs_n),
    // .external_storage_spi_sck(external_storage_spi_sck),
    // .external_storage_spi_mosi(external_storage_spi_mosi),
    // .external_storage_spi_miso(external_storage_spi_miso),

    // // Programming SPI
    // .programming_spi_cs_n(programming_spi_cs_n),
    // .programming_spi_sck(programming_spi_sck),
    // .programming_spi_mosi(programming_spi_mosi),
    // .programming_spi_miso(programming_spi_miso)

    
    // To/from storage SPI
    .external_qspi_io_i(external_qspi_io_i),
    .external_qspi_io_o(external_qspi_io_o),
    .external_qspi_io_t(external_qspi_io_t),
    .external_qspi_ck_o(external_qspi_ck_o),
    .external_qspi_cs_o(external_qspi_cs_o),

    // To/from programming SPI
    .programming_qspi_io_i(programming_qspi_io_i),
    .programming_qspi_io_o(programming_qspi_io_o),
    .programming_qspi_io_t(programming_qspi_io_t),
    .programming_qspi_ck_o(programming_qspi_ck_o),
    .programming_qspi_cs_o(programming_qspi_cs_o)
);

digitalTimer digitalTimer (
    .clk(clk),
    .rst(rst),
    .timer_is_high(timer_is_high),
    .timer_set_val(timer_set_val),
    .set_timer(set_timer)
);

enum logic [3:0] {
    default_state,
    external_init,
    external_continue,
    sram_state_init,
    sram_state_done,
    timer_state,
    gpio_state,
    error_state,
    programming_state
} state, next_state;

// TODO: if this is negedge the SRAM timing volations go away
always_ff @(negedge clk) begin
    if (~rst) begin
        state <= default_state;
    end else begin
        state <= next_state;
    end
end

// Assign GPIO pins
genvar gpio_incr;
generate
    for(gpio_incr = 0; gpio_incr < 10; gpio_incr++) begin
        assign gpio_pins[gpio_incr] = gpio_direction[gpio_incr] ? 'z : gpio_curr_value[gpio_incr];
    end
endgenerate

// Determine next state
always_comb begin
    if (~rst) begin
        next_state = default_state;
    end else if (state == error_state) begin
        next_state = default_state;
    end else if (state == sram_state_init) begin
        next_state = sram_state_done;
    end else if (state == sram_state_done) begin
        next_state = default_state;
    end else if (state == external_continue && storage_out_valid) begin
        next_state = default_state;
    end else if ((state == external_init || state == external_continue) && ~storage_out_valid) begin
        // Stay in memory state if memory hasn't responded yet
        next_state = external_continue;
    end else if (vproc_mem_req_o) begin
        if (vproc_mem_addr_o >= 32'h0000_0000 && vproc_mem_addr_o <=  32'h0000_0100) begin
            // Reserved
            next_state = error_state;
        end else if (vproc_mem_addr_o >= 32'h0000_0101 && vproc_mem_addr_o <= 32'h0000_0114) begin
            // GPIO
            next_state = gpio_state;
        end else if (vproc_mem_addr_o == 32'h0000_0115) begin
            // Digital timer
            next_state = timer_state;
        end else if (vproc_mem_addr_o >= 32'h0000_0116 && vproc_mem_addr_o <= 32'h0000_0FFF) begin
            // Reserved
            next_state = error_state;
        end else if (vproc_mem_addr_o >= 32'h0000_1000 && vproc_mem_addr_o <= 32'h0000_1FFF) begin
            // SRAM
            next_state = sram_state_init;
        end else begin
            // External storage
            if (vproc_mem_err_i) begin
                // If we get a error, go to default state
                next_state = default_state;
            end else if (storage_out_valid) begin
                next_state = default_state;
            end else begin
                if (state == external_init || state == external_continue) begin
                    next_state = external_continue;
                end else begin
                    next_state = external_init;
                end
            end
        end
    end else begin
        next_state = default_state;
    end
end

// Determine signal values
always_comb begin
    if (~rst) begin
        curr_addr = 32'b0;
        curr_d_in = '{default: '0};
        curr_mem_be = '{default: '0};
        curr_mem_we = 1'b0;
        gpio_direction = 10'b0;
        gpio_curr_value = 10'b0;
        external_storage_access = 1'b0;
    end else begin
        // Default values for outputs
        // To/from Vicuna/Ibex
        vproc_mem_rvalid_i = 1'b0;
        vproc_mem_err_i = 1'b0;
        vproc_mem_rdata_i = '{default: '0};

        // To/from digital timer
        timer_set_val = 32'b0;
        set_timer = 1'b0;


        external_storage_access = 1'b0;
        
        unique case (state)
            default_state:
                begin
                    // curr_addr = 32'b0;
                    if(vproc_mem_req_o) begin
                        curr_d_in = vproc_mem_wdata_o;
                        curr_mem_be = vproc_mem_be_o;
                        curr_mem_we = vproc_mem_we_o;
                        memory_access = 1'b0;
                        if(vproc_mem_addr_o >= 32'h0000_2000) begin
                            curr_addr = vproc_mem_addr_o - 32'h0000_2000;
                            external_storage_access = 1'b1;
                        end else begin
                            curr_addr = vproc_mem_addr_o;
                            external_storage_access = 1'b0;
                        end
                    end else begin
                        curr_d_in = '{default: '0};
                        curr_mem_be = '{default: '0};
                        curr_mem_we = 1'b0;
                        memory_access = 1'b0;
                        curr_addr = 32'b0;
                        external_storage_access = 1'b0;
                    end
                end
            external_init:
                begin
                    // Initial memory access cycle - set values so that we save them since input becomes invalidated
                    //if (vproc_mem_req_o) begin
                        if (curr_mem_we) begin
                            // Can't write to external memory
                            vproc_mem_err_i = 1'b1;
                            memory_access = 1'b0;
                        end else begin
                            memory_access = 1'b1;
                            external_storage_access = 1'b1;
                            // curr_addr = vproc_mem_addr_o - 32'h0000_2000;
                            // curr_d_in = '{default: '0};
                            // curr_mem_be = '{default: '0};
                            // curr_mem_we = 1'b0;
                            // memory_access = 1'b1;
                        end
                    //end
                end
            external_continue:
                begin
                    // Continue giving storage controller same input until it returns that it's done
                    if (~storage_out_valid) begin
                        memory_access = 1'b1;
                        external_storage_access = 1'b1;
                    end else begin
                        vproc_mem_rdata_i = storage_controller_d_out;
                        vproc_mem_rvalid_i = 1'b1;
                        
                        // curr_addr = 32'b0;
                        curr_d_in = '{default: '0};
                        curr_mem_be = '{default: '0};
                        curr_mem_we = 1'b0;
                        memory_access = 1'b0;
                        external_storage_access = 1'b0;
                    end
                end
            sram_state_init:
                begin
                    if (vproc_mem_addr_o >= 32'h0000_1000) begin
                        curr_addr = vproc_mem_addr_o - 32'h0000_1000;
                        curr_d_in = vproc_mem_wdata_o;
                        curr_mem_be = vproc_mem_be_o;
                        curr_mem_we = vproc_mem_we_o;
                        memory_access = 1'b1;
                        vproc_mem_rdata_i = storage_controller_d_out;
                    end
                end
            sram_state_done:
                begin
                    memory_access = 1'b1;
                    vproc_mem_rdata_i = storage_controller_d_out;
                    vproc_mem_rvalid_i = 1'b1;
                end
            timer_state:
                begin
                    if (vproc_mem_req_o) begin
                        // If writing to timer, we should be setting its value
                        if (vproc_mem_we_o) begin
                            timer_set_val = vproc_mem_wdata_o; 
                            set_timer = 1'b1;
                        end else begin
                            vproc_mem_rdata_i = {31'b0, timer_is_high};
                            vproc_mem_rvalid_i = 1'b1;
                        end
                    end
                end
            gpio_state:
                begin
                    if (vproc_mem_req_o) begin
                        if (vproc_mem_addr_o >= 32'h0000_0101 && vproc_mem_addr_o <= 32'h0000_010A) begin
                            // Setting pin direction
                            if (vproc_mem_we_o) begin
                                gpio_direction[vproc_mem_addr_o - 32'h0000_0101] = vproc_mem_wdata_o[0];
                            end else begin
                                vproc_mem_rdata_i = {31'b0, gpio_direction[vproc_mem_addr_o - 32'h0000_0101]};
                                vproc_mem_rvalid_i = 1'b1;
                            end
                        end else begin
                            // Writing/reading from pin
                            if (vproc_mem_we_o) begin
                                // Ensure curr pin is output otherwise error
                                if (gpio_direction[vproc_mem_addr_o - 32'h0000_010B] != 1'b0) begin
                                    vproc_mem_err_i = 1'b1;
                                end else begin
                                    // Set pin
                                    gpio_curr_value[vproc_mem_addr_o - 32'h0000_010B] = vproc_mem_wdata_o[0];
                                end
                            end else begin
                                // Ensure curr pin is input otherwise error
                                if (gpio_direction[vproc_mem_addr_o - 32'h0000_010B] != 1'b1) begin
                                    vproc_mem_err_i = 1'b1;
                                end else begin
                                    // Read pin
                                    vproc_mem_rdata_i = {31'b0, gpio_pins[vproc_mem_addr_o - 32'h0000_010B]};
                                    vproc_mem_rvalid_i = 1'b1;
                                end
                            end
                        end
                    end
                end
            error_state:
                begin
                    vproc_mem_err_i = 1'b1;
                end
            default:
                begin
                    // Nothing should happen in default state?
                end
        endcase
    end
end

endmodule : mmu
