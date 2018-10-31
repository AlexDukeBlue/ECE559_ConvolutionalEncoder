module skeleton(clk, iclk, reset, blk_ready, blk_ready_out, fifo_w_data, fifo_w_meta, blk_data, blk_meta, wrreq_data, wrreq_meta, cOut, dOut, q0, q1, q2, rdreq_subblock);
input [7:0] fifo_w_data, fifo_w_meta;
//input [2:0] rdreq_subblock;
input clk, reset, blk_ready, wrreq_data, wrreq_meta, rdreq_subblock;
output [7:0] q0, q1, q2;
output [7:0] blk_data, blk_meta;
output [6:0] cOut;
output [2:0] dOut;
output iclk, blk_ready_out;

wire [7:0] blk_data, blk_meta;
wire usedw_data, usedw_meta;
wire blk_empty_data, blk_empty_meta, blk_data_rdreq, blk_meta_rdreq;
wire ireset, iwrreq_data, iwrreq_meta; 

assign iclk = clk;
assign ireset = !reset;
assign iwrreq_data = wrreq_data;
assign iwrreq_meta = wrreq_meta;
assign blk_ready_out = blk_ready;

fifo test_inputdata_fifo(iclk, fifo_w_data, blk_data_rdreq, ireset, iwrreq_data, blk_empty_data, blk_data, usedw_data);
fifo test_inputmeta_fifo(iclk, fifo_w_meta, blk_meta_rdreq, ireset, iwrreq_meta, blk_empty_meta, blk_meta, usedw_meta);
convEncoder_bs encoder(iclk, ireset, blk_ready, blk_meta, blk_empty_data, blk_data, blk_meta_rdreq, blk_data_rdreq, dOut, cOut, q0, q1, q2, {rdreq_subblock, rdreq_subblock, rdreq_subblock});

endmodule 