module io_pad (
    inout   wire    io,
    output  logic   i,
    input   logic   o,
    input   logic   t
);

bufif0 tri_buf_ (io, o, t);
io_buf io_buf_ (.i(io), .o(i));

endmodule