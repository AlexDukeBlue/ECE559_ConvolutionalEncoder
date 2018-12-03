module skeleton(clk, reset, data_valid, fifo_w_data, tail_byte, wrreq_data, q0, q1, q2, rdreq_subblock, code_block_length, computation_done, encoder_vals, probe, usedwOut);
input [7:0] fifo_w_data, tail_byte;
input rdreq_subblock, code_block_length;
input clk, reset, data_valid, wrreq_data;
output [9:0] usedwOut;
output [7:0] q0, q1, q2;
output [5:0] encoder_vals;
output [2:0] probe;
output computation_done;

wire [7:0] blk_data;
wire usedw_data;
wire blk_empty, blk_data_rdreq, length_out;

fifo test_inputdata_fifo(clk, fifo_w_data, blk_data_rdreq, reset, wrreq_data, blk_empty, blk_data, usedw_data);

convEncoder_par encoder(.clk(clk),
							  .reset(reset),
							  .data_valid(data_valid),
							  .tail_byte(tail_byte),
							  .code_block_length(code_block_length),
							  .blk_empty(blk_empty),
							  .blk_data(blk_data),
							  .blk_data_rdreq(blk_data_rdreq),
							  .q0(q0),
							  .q1(q1),
							  .q2(q2),
							  .rdreq_subblock(rdreq_subblock),
							  .computation_done(computation_done),
							  .length_out(length_out),
							  .encoder_vals(encoder_vals),
							  .probe(probe),
							  .usedwOut(usedwOut)
							  );

endmodule 