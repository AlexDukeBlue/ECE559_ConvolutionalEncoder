module skeleton(clk, reset, data_valid, fifo_w_data, blk_data, wrreq_data, q0, q1, q2, rdreq_subblock, computation_done, rfc, emptybus, usedw0, usedw1, usedw2, probewires, ev, count, countmod, cr);
input [7:0] fifo_w_data;
input rdreq_subblock;
input clk, reset, data_valid, wrreq_data;
output [7:0] q0, q1, q2;
output computation_done;

output [1:0] cr;
output [2:0] rfc, emptybus, probewires, countmod;
output [6:0] ev;
output [9:0] usedw0, usedw1, usedw2;
output [12:0] count;

output [7:0] blk_data;
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
							  .rfc(rfc),
							  .emptybus(emptybus),
							  .usedw0(usedw0), 
							  .usedw1(usedw1), 
							  .usedw2(usedw2),
							  .probewires(probewires),
							  .ev(ev),
							  .count(count),
							  .countmod(countmod),
							  .cr(cr)
							  );

endmodule 