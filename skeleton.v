module skeleton(clk, reset, fifo_w_data, wrreq, usedw, cOut, dOut);
input [7:0] fifo_w_data;
input clk, reset, wrreq;
output [6:0] cOut;
output [2:0] dOut;
output usedw;

localparam blk_size = 1'b0;
localparam tail_bits = 6'b101010;

wire [7:0] blk_data;
wire [2:0] usedw;
wire blk_empty, blk_rdreq;

fifo test_fifo(clk, fifo_w_data, blk_rdreq, reset, wrreq, blk_empty, blk_data, usedw);
convEncoder_bs encoder(clk, reset, blk_size, tail_bits, blk_empty, blk_data, blk_rdreq, dOut, cOut);
endmodule 