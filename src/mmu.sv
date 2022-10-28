
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
    output logic               vproc_mem_err_i, // TODO: never set this to high, should we in some states?
    output logic [MEM_W  -1:0] vproc_mem_rdata_i,
    input  logic [31:0]        vproc_pend_vreg_wr_map_o,

    // To/from digital timer
    input  logic timer_is_high,
    output logic [31:0] timer_set_val,
    output logic set_timer,

    // To/from GPIO
    inout  logic [9:0] gpio_pins,

    // To/from external SPI
);

//                       MEMORY ADDRESSES
// | Address Range              | Device                |
// | -------------------------- | --------------------- |
// | 0x0000_0000 - 0x0000_0100  | Reserved              |
// | 0x0000_0101 - 0x0000_010A  | GPIO                  |
// | 0x0000_010B                | Digital Timer         |
// | 0x0000_010C - 0x0000_0FFF  | Reserved              |
// | 0x0000_1000 - 0xFFFF_FFFF  | SRAM/External Storage |



// STORAGE_CONTROLLER SIGNALS
logic storage_en;
logic [31:0] storage_controller_d_out;


storage_controller storage_controller (
    .clk(clk),
    .rst(rst),
    .storage_en(storage_en), // if high, address passed in needs to be fetched from storage
    .addr(vproc_mem_addr_o - 32'h0000_1000), // SRAM/storage is offset by 0x1000
    .d_in(vprc_mem_wdata_o),
    .mem_be(vproc_mem_be_o),
    .d_out(storage_controller_d_out),
);


enum logic [1:0] {
    default_state,
    storage_state,
    timer_state,
    gpio_state
} state, next_state;

always_ff @(posedge clk) begin
    if (rst) begin
        state <= default_state;
        next_state <= default_state;
    end else begin
        state <= next_state;
    end
end

// Determine next state
always_comb begin
    if (vproc_mem_req_o) begin
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
            next_state <= storage_state;
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
    
    if (vproc_mem_req_o) begin
        unique case (state)
            default_state:
                begin
                    // Nothing should happen in default state?
                end
            storage_state:
                begin
                    // vproc_mem_we_o high when writing, low when reading
                    if (vproc_mem_we_o) begin
                        
                    end else begin
                        vproc_mem_rdata_i <= storage_controller_d_out;
                        vproc_mem_rvalid_i <= 1'b1;
                    end
                end
            timer_state:
                begin
                    // If writing to timer, we should be setting its value
                    if (vproc_mem_we_o) begin
                        timer_set_val <= vproc_mem_wdata_o; 
                        set_timer <= 1'b1;
                    end else begin
                        vproc_mem_rdata_i <= {31'b0, timer_is_high};
                        vproc_mem_rvalid_i < 1'b1;
                    end
                end
            gpio_state:
                begin
                    // TODO: figure out how to determine if pin in input or output
                    if (vproc_mem_we_o) begin
                        
                    end else begin
                        
                    end
                end
            default:
                begin
                    // Nothing should happen in default state?
                end
        endcase
    end
end

endmodule : mmu
