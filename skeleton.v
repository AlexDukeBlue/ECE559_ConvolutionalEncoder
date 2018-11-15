module skeleton(clk, reset, data_valid, fifo_w_data, blk_data, wrreq_data, q0, q1, q2, rdreq_subblock, computation_done, encoder_vals);
input [7:0] fifo_w_data;
input rdreq_subblock;
input clk, reset, data_valid, wrreq_data;
output [7:0] q0, q1, q2;
output computation_done;

output [7:0] blk_data;
output [6:0] encoder_vals;
wire usedw_data, usedw_meta;
wire blk_empty, blk_data_rdreq, length_out;

fifo test_inputdata_fifo(clk, fifo_w_data, blk_data_rdreq, reset, wrreq_data, blk_empty, blk_data, usedw_data);

convEncoder_bs encoder(.clk(clk),
							  .reset(reset),
							  .data_valid(data_valid),
							  .tail_byte(8'b11000111),
							  .code_block_length(1'b0),
							  .blk_empty(blk_empty),
							  .blk_data(blk_data),
							  .blk_data_rdreq(blk_data_rdreq),
							  .q0(q0),
							  .q1(q1),
							  .q2(q2),
							  .rdreq_subblock(rdreq_subblock),
							  .computation_done(computation_done),
							  .length_out(length_out),
							  .encoder_vals(encoder_vals)
							  );

endmodule 