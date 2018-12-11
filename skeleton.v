module skeleton(clk, clk50, out_clk, reset, blk_ready, blk_ready_out, fifo_w_data, blk_data, wrreq_data, q0, q1, q2, computation_done, rdreq_subblock, disp0, disp1, disp2, disp3, disp4, disp5, empty, should_empty);
input [7:0] fifo_w_data;
input clk, clk50, reset, blk_ready, wrreq_data, rdreq_subblock, should_empty;
output [7:0] q0, q1, q2;
output [7:0] blk_data;
output [6:0] disp0, disp1, disp2, disp3, disp4, disp5;
output computation_done, out_clk, empty;
output reg blk_ready_out;

reg [10:0] counter;
reg computation_ended, switch_clocks, was_ready, count_to_empty;

wire usedw_data;
wire blk_data_rdreq, blk_empty_data;
wire ireset, iwrreq_data, length_out, actual_clock; 

assign actual_clock = (switch_clocks) ? clk50 : ~clk;
assign out_clk = actual_clock;
assign ireset = ~reset;
assign iwrreq_data = ~wrreq_data;

initial begin
	switch_clocks <= 1'b0;
	computation_ended <= 1'b0;
	blk_ready_out <= 1'b0;
	was_ready <= 1'b0;
	counter <= 11'b0;
end

always @(posedge actual_clock) begin
	if(blk_ready_out)
	begin
		blk_ready_out <= 1'b0;
	end
	if(blk_ready && ~was_ready)
	begin
		blk_ready_out <= 1'b1;
		switch_clocks <= 1'b1;
		was_ready <= 1'b1;
	end
	if(computation_done)
	begin
		computation_ended <= 1'b1;
	end
	if(counter >= 11'd64)
	begin
		switch_clocks <= 1'b0;
		computation_ended <= 1'b0;
		blk_ready_out <= 1'b0;
		was_ready <= 1'b0;
	end
	if(computation_ended)
	begin
		counter <= counter + 1'b1;
	end
end

seven_segment s0(q2[7:4], disp0);
seven_segment s1(q2[3:0], disp1);
seven_segment s2(q1[7:4], disp2);
seven_segment s3(q1[3:0], disp3);
seven_segment s4(q0[7:4], disp4);
seven_segment s5(q0[3:0], disp5);

fifo test_inputdata_fifo(actual_clock, fifo_w_data, blk_data_rdreq, ireset, iwrreq_data, blk_empty_data, blk_data, usedw_data);
convEncoder_bs encoder(.clk(actual_clock),
							  .reset(ireset),
							  .data_valid(blk_ready_out),
							  .tail_byte(8'd0),
							  .code_block_length(1'b0),
							  .blk_empty(blk_empty_data),
							  .blk_data(blk_data),
							  .blk_data_rdreq(blk_data_rdreq),
							  .q0(q0),
							  .q1(q1),
							  .q2(q2),
							  .rdreq_subblock(rdreq_subblock),
							  .computation_done(computation_done),
							  .length_out(length_out),
							  .empty(empty)
							  );

endmodule 