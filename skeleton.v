module skeleton(clk, reset, blk_data, q0, q1, q2, rdreq_subblock, computation_done);
input clk, reset, rdreq_subblock;
output [7:0] q0, q1, q2;
output [7:0] blk_data;
output computation_done;

//blk_data is the output of the cod-block segmentation output FIFO.
//tail_byte is the tail byte from the CRC.
wire [7:0] blk_data, tail_byte;
//Currently usedw_data and usedw_meta aren't being used but they are part of the FIFO interface.
wire usedw_data, usedw_meta;
//blk_empty is the empty signal for the data FIFO from the code-segmentation block.
wire blk_empty, blk_data_rdreq, data_valid, code_block_length, length_out;

convEncoder_bs encoder(.clk(clk),
							  .reset(reset),
							  .blk_ready(data_valid),
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
							  .size_out(length_out)
							  );

endmodule 