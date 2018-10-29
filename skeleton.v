module skeleton(clk, reset, blk_ready, fifo_w_data, fifo_w_meta, blk_data, blk_meta, wrreq_data, wrreq_meta, cOut, dOut, computation_done, instantiate_computation, compute_enable, counter_out, counter_mod, q0, q1, q2, wrreq_in, rdreq_subblock);
input [7:0] fifo_w_data, fifo_w_meta;
input [2:0] rdreq_subblock;
input clk, reset, blk_ready, wrreq_data, wrreq_meta;
output [12:0] counter_out;
output [7:0] q0, q1, q2;
output [2:0] counter_mod;
output [7:0] blk_data, blk_meta;
output [6:0] cOut;
output [2:0] dOut, wrreq_in;
output computation_done, instantiate_computation, compute_enable;

wire [7:0] blk_data, blk_meta;
wire usedw_data, usedw_meta;
wire blk_empty_data, blk_empty_meta, blk_data_rdreq, blk_meta_rdreq;

fifo test_inputdata_fifo(clk, fifo_w_data, blk_data_rdreq, reset, wrreq_data, blk_empty_data, blk_data, usedw_data);
fifo test_inputmeta_fifo(clk, fifo_w_meta, blk_meta_rdreq, reset, wrreq_meta, blk_empty_meta, blk_meta, usedw_meta);
convEncoder_bs encoder(clk, reset, blk_ready, blk_meta, blk_empty_data, blk_data, blk_meta_rdreq, blk_data_rdreq, dOut, cOut, computation_done, instantiate_computation, compute_enable, counter_out, counter_mod, q0, q1, q2, wrreq_in, rdreq_subblock);

endmodule 