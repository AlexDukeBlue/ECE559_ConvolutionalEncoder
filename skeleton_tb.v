`timescale 1 ns / 100 ps
module skeleton_tb();
reg [7:0] fifo_w_data, tail_byte;
reg clk, reset, data_valid, wrreq_data, rdreq_subblock, code_block_length;
wire [12:0] probe;
wire [7:0] q0, q1, q2;
wire computation_done;

skeleton skel(clk, reset, data_valid, fifo_w_data, tail_byte, wrreq_data, q0, q1, q2, rdreq_subblock, code_block_length, computation_done, probe);

initial begin
	clk = 1'b0;
	reset = 1'b1;
	data_valid = 1'b0;
	wrreq_data = 1'b0;
	rdreq_subblock = 1'b0;
	code_block_length = 1'b1;
	fifo_w_data = 8'h00;
	tail_byte = 8'h5A;
	#20;
	reset = 1'b0;
	wrreq_data = 1'b1;
	fifo_w_data = 8'hA6;
	#20
	fifo_w_data = 8'hB7;
	#20
	fifo_w_data = 8'hf3;
	#20
	fifo_w_data = 8'haf;
	#20
	fifo_w_data = 8'hB2;
	#20
	fifo_w_data = 8'h0d;
	#20
	fifo_w_data = 8'h9c;
	#20
	fifo_w_data = 8'hff;
	#20
	fifo_w_data = 8'ha7;
	#20
	fifo_w_data = 8'h88;
	#20
	fifo_w_data = 8'h69;
	#20
	fifo_w_data = 8'h5a;
	#20
	wrreq_data = 1'b0;
	data_valid = 1'b1;
	#20;
	data_valid = 1'b0;
	#122880;
	rdreq_subblock = 1'b1;
	#15360;
	rdreq_subblock = 1'b0;
	wrreq_data = 1'b1;
	code_block_length = 1'b0;
	fifo_w_data = 8'hA6;
	#20
	fifo_w_data = 8'hB7;
	#20
	fifo_w_data = 8'hf3;
	#20
	fifo_w_data = 8'haf;
	#20
	fifo_w_data = 8'hB2;
	#20
	fifo_w_data = 8'h0d;
	#20
	fifo_w_data = 8'h9c;
	#20
	fifo_w_data = 8'hff;
	#20
	fifo_w_data = 8'ha7;
	#20
	fifo_w_data = 8'h88;
	#20
	fifo_w_data = 8'h69;
	#20
	fifo_w_data = 8'h5a;
	#20
	wrreq_data = 1'b0;
	data_valid = 1'b1;
	#20;
	data_valid = 1'b0;
	#21120;
	rdreq_subblock = 1'b1;
	#2640;
	rdreq_subblock = 1'b0;
	$stop;
end

always
 #10 clk = !clk;

endmodule 
