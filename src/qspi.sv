// From Stanley

module qspi_controller (
    input   logic                   s_pclk,
    input   logic                   s_presetn,
    input   logic   [31:0]          s_paddr,
    input   logic                   s_psel,
//    input   logic                   s_penable,
    input   logic                   s_pwrite,
//    input   logic   [31:0]          s_pwdata,
//    input   logic   [3:0]           s_pstrb,
    output  logic                   s_pready,
    output  logic   [31:0]          s_prdata,

    input   logic   [3:0]           qspi_io_i,
    output  logic   [3:0]           qspi_io_o,
    output  logic   [3:0]           qspi_io_t,
    output  logic                   qspi_ck_o,
    output  logic                   qspi_cs_o
);

    enum {
        QSPI_CTRL_IDLE,
        QSPI_CTRL_CMD,
        QSPI_CTRL_ADDR,
        QSPI_CTRL_DUMMY,
        QSPI_CTRL_DATA,
        QSPI_CTRL_ACK
    } state, state_next;

            logic   [2:0]   nibble_counter_d;
            logic   [2:0]   nibble_counter_q;
            logic           nibble_counter_d_mux_sel;
            logic   [1:0]   io_o_mux_sel;

    always_ff @( posedge s_pclk ) begin : state_ff
        if (~s_presetn) begin
            state <= QSPI_CTRL_IDLE;
        end else begin
            state <= state_next;
        end
    end

    always_comb begin : state_comb
        // qspi_io_o = 'b0;
        qspi_io_t = 'b0;
        // qspi_ck_o = 'b0;
        qspi_cs_o = 'b0;
        case(state)
        QSPI_CTRL_IDLE : begin
            if (~s_psel) begin
                state_next = QSPI_CTRL_IDLE;
                nibble_counter_d_mux_sel = 1'b0;
                io_o_mux_sel = 2'b00;
                qspi_io_t = 4'hf;
                qspi_cs_o = 1'b1;
                s_pready = 1'b0;
            end else begin
                if (~s_pwrite) begin
                    state_next = QSPI_CTRL_CMD;
                    nibble_counter_d_mux_sel = 1'b0;
                    io_o_mux_sel = 2'b00;
                    qspi_io_t = 4'hf;
                    qspi_cs_o = 1'b0;
                    s_pready = 1'b0;
                end else begin
                    state_next = QSPI_CTRL_ACK;
                    nibble_counter_d_mux_sel = 1'b0;
                    io_o_mux_sel = 2'b00;
                    qspi_io_t = 4'hf;
                    qspi_cs_o = 1'b1;
                    s_pready = 1'b0;
                end
            end
        end
        QSPI_CTRL_CMD : begin
            if (nibble_counter_q != 3'd7) begin
                state_next = QSPI_CTRL_CMD;
                nibble_counter_d_mux_sel = 1'b1;
                io_o_mux_sel = 2'b10;
                qspi_io_t = 4'h0;
                qspi_cs_o = 1'b0;
                s_pready = 1'b0;
            end else begin
                state_next = QSPI_CTRL_ADDR;
                nibble_counter_d_mux_sel = 1'b0;
                io_o_mux_sel = 2'b10;
                qspi_io_t = 4'h0;
                qspi_cs_o = 1'b0;
                s_pready = 1'b0;
            end
        end
        QSPI_CTRL_ADDR : begin
            if (nibble_counter_q != 3'd7) begin
                state_next = QSPI_CTRL_ADDR;
                nibble_counter_d_mux_sel = 1'b1;
                io_o_mux_sel = 2'b11;
                qspi_io_t = 4'h0;
                qspi_cs_o = 1'b0;
                s_pready = 1'b0;
            end else begin
                state_next = QSPI_CTRL_DUMMY;
                nibble_counter_d_mux_sel = 1'b0;
                io_o_mux_sel = 2'b11;
                qspi_io_t = 4'h0;
                qspi_cs_o = 1'b0;
                s_pready = 1'b0;
            end
        end
        QSPI_CTRL_DUMMY : begin
            if (nibble_counter_q != 3'd3) begin
                state_next = QSPI_CTRL_DUMMY;
                nibble_counter_d_mux_sel = 1'b1;
                io_o_mux_sel = 2'b00;
                qspi_io_t = 4'hf;
                qspi_cs_o = 1'b0;
                s_pready = 1'b0;
            end else begin
                state_next = QSPI_CTRL_DATA;
                nibble_counter_d_mux_sel = 1'b0;
                io_o_mux_sel = 2'b00;
                qspi_io_t = 4'hf;
                qspi_cs_o = 1'b0;
                s_pready = 1'b0;
            end
        end
        QSPI_CTRL_DATA : begin
            if (nibble_counter_q != 3'd7) begin
                state_next = QSPI_CTRL_DATA;
                nibble_counter_d_mux_sel = 1'b1;
                io_o_mux_sel = 2'b00;
                qspi_io_t = 4'hf;
                qspi_cs_o = 1'b0;
                s_pready = 1'b0;
            end else begin
                state_next = QSPI_CTRL_ACK;
                nibble_counter_d_mux_sel = 1'b0;
                io_o_mux_sel = 2'b00;
                qspi_io_t = 4'hf;
                qspi_cs_o = 1'b0;
                s_pready = 1'b0;
            end
        end
        QSPI_CTRL_ACK : begin
            state_next = QSPI_CTRL_IDLE;
            nibble_counter_d_mux_sel = 1'b0;
            io_o_mux_sel = 2'b00;
            qspi_io_t = 4'hf;
            qspi_cs_o = 1'b1;
            s_pready = 1'b1;
        end
        endcase
    end

    always_comb begin : qspi_clk_comb
        qspi_ck_o = state != QSPI_CTRL_IDLE ? ~s_pclk : 1'b0;
    end

    always_comb begin : nibble_mux
        case (nibble_counter_d_mux_sel)
            1'b0 : nibble_counter_d = '0;
            1'b1 : nibble_counter_d = nibble_counter_q + 3'd1;
        endcase
    end

    always_comb begin : io_o_mux        
        automatic logic [3:0]   addr_mux_out;
        automatic logic         cmd_mux_out;
                qspi_io_o = 'b0;

        case (nibble_counter_q)
            3'b000: addr_mux_out = s_paddr[23:20];
            3'b001: addr_mux_out = s_paddr[19:16];
            3'b010: addr_mux_out = s_paddr[15:12]; 
            3'b011: addr_mux_out = s_paddr[11:8];
            3'b100: addr_mux_out = s_paddr[7:4];
            3'b101: addr_mux_out = s_paddr[3:0];
            3'b110: addr_mux_out = 4'hf;
            3'b111: addr_mux_out = 4'hf;
        endcase
        case (nibble_counter_q)
            3'b000: cmd_mux_out = 1'b1;
            3'b001: cmd_mux_out = 1'b1;
            3'b010: cmd_mux_out = 1'b1; 
            3'b011: cmd_mux_out = 1'b0;
            3'b100: cmd_mux_out = 1'b1;
            3'b101: cmd_mux_out = 1'b0;
            3'b110: cmd_mux_out = 1'b1;
            3'b111: cmd_mux_out = 1'b1;
        endcase
        casez (io_o_mux_sel)
            2'b0z: qspi_io_o = 4'b0000;
            2'b10: qspi_io_o = {3'b000, cmd_mux_out};
            2'b11: qspi_io_o = addr_mux_out;
        endcase
    end
    
    logic   [31:0]  rdata_d;
    logic   [31:0]  rdata_q;
    logic   [31:0]  rdata_l;

    always_comb begin : rdata_reg_comb
        rdata_l = 'd0;
        for (int i = 0; i < 8; i++) begin
            if ({nibble_counter_q[2:1], ~nibble_counter_q[0]} == i[2:0] && state == QSPI_CTRL_DATA) begin
                rdata_l[i*4+:4] = 4'hf;
            end
            rdata_d[i*4+:4] = qspi_io_i;
        end
        s_prdata = rdata_q;
    end    

    always_ff @( posedge s_pclk ) begin : reg_stub
        if (~s_presetn) begin
            nibble_counter_q <= '0;
            rdata_q <= '0;
        end else begin
            nibble_counter_q <= nibble_counter_d;
            for (int i = 0; i < 32; i++) begin
                if (rdata_l[i]) begin
                    rdata_q[i] <= rdata_d[i];
                end
            end
        end
    end

endmodule
