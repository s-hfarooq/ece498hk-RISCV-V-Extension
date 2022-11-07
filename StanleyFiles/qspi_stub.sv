module qspi_stub(
    output  logic   [3:0]           qspi_io_i,
    input   logic   [3:0]           qspi_io_o,
    input   logic   [3:0]           qspi_io_t,
    input   logic                   qspi_ck_o,
    input   logic                   qspi_cs_o
);

            logic   [31:0]           mem [2**24];

    initial
    begin
        $readmemh("/home/hfaroo9/ece498hk-RISCV-V-Extension/src/tmp.vmem", mem);
        // $displayh("mem = %p", mem);
    end

    always begin
        automatic bit [7:0] cmd;
        automatic bit [23:0] addr;
        automatic bit [7:0] mode;
        @(negedge qspi_cs_o);
        // $display("negedge qspi_cs_o");
        for (int i = 7; i >= 0; i--) begin
            @(posedge qspi_ck_o);
            cmd[i] = ~qspi_io_t[0] ? qspi_io_o[0] : 1'bx;
            // $display("cmd[i] = %p, i = %p", cmd[i], i);
        end
        assert (cmd == 8'hEB) else begin
            $display("ERROR: qspi wrong cmd, expected: %h, detected: %h, time: %0t", 8'hEB, cmd, $time);
            #1
            $finish;
        end
        for (int i = 5; i >= 0; i--) begin
            @(posedge qspi_ck_o);
            for (int j = 0; j < 4; j++) begin
                addr[i*4+j] = ~qspi_io_t[j] ? qspi_io_o[j] : 1'bx;
            end
        end
        // $display("INFO: qspi read addr: %h, data: %h, time: %0t", addr, {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]} ,$time);
        $display("INFO: qspi read addr: %h, data: %h, time: %0t", addr, {mem[addr]} ,$time);

        for (int i = 1; i >= 0; i--) begin
            @(posedge qspi_ck_o);
            for (int j = 0; j < 4; j++) begin
                mode[i*4+j] = ~qspi_io_t[j] ? qspi_io_o[j] : 1'bx;
            end
        end
        assert (mode[7:4] == 4'hF) else begin
            $display("ERROR: qspi wrong mode, expected: %h, detected: %h, time: %0t", 8'b1111xxxx, mode, $time);
            #1
            $finish;
        end
        for (int i = 0; i < 4; i++) begin
            @(posedge qspi_ck_o);
        end
        for (int unsigned i = 0; i < 8; i++) begin
            @(negedge qspi_ck_o);
            // if (i % 2 == 0) begin
            //     qspi_io_i = mem[addr][7:4];
            // end else begin
            //     qspi_io_i = mem[addr][3:0];
            //     addr += 24'd1;
            // end
            case (i)
                0: qspi_io_i = mem[addr][7:4];
                1: qspi_io_i = mem[addr][3:0];
                2: qspi_io_i = mem[addr][15:12];
                3: qspi_io_i = mem[addr][11:8];
                4: qspi_io_i = mem[addr][23:20];
                5: qspi_io_i = mem[addr][19:16];
                6: qspi_io_i = mem[addr][31:28];
                7: qspi_io_i = mem[addr][27:24];
                default: qspi_io_i = 4'bx;
            endcase
        end
        @(posedge qspi_cs_o);
    end

endmodule
