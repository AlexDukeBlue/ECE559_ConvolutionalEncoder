//`timescale 1 ns / 100 ps
module ConvEncTB();
	// inputs to skeleton function
	reg clk_20ns, reset1, blk_ready1, wrreq_data1, wrreq_meta1;
	reg [7:0] fifo_w_data1, fifo_w_meta1;

	// outputs to skeleton function
	wire [7:0] out_fifo01, out_fifo11, out_fifo21;
	wire [6:0] cout;
	wire [2:0] dout;
	wire [2:0] counter_mod1;
	wire [12:0] counter_out1;
	wire [7:0] blk_data1, blk_meta1;
	wire computation_done1, instantiate_computation1, compute_enable1;

	//instantiate device
	skeleton test1(.clk(clk_20ns), .reset(reset1), .blk_ready(blk_ready1), .fifo_w_data(fifo_w_data1), .fifo_w_meta(fifo_w_meta1), .blk_data(blk_data1), .blk_meta(blk_meta1), .wrreq_data(wrreq_data1), .wrreq_meta(wrreq_meta1), .cOut(cout), .dOut(dout), .computation_done(omputation_done1), .instantiate_computation(instantiate_computation1), .compute_enable(ompute_enable1), .counter_out(counter_out1), .counter_mod(counter_mod1), .out_to_fifo0(out_to_fifo01), .out_to_fifo1(out_to_fifo11), .out_to_fifo2(out_to_fifo21));

	always
		#10 clk_20ns = ~ clk_20ns; //make 50 MHZ clock

	//set up initial values in 
	initial
	begin
		$display(" << Starting the Simulation >>");
		clk_20ns = 1'b0;
		reset1 = 1'b1;
		#20; reset1 = 1'b0; wrreq_data1 = 1'b1; wrreq_meta1 = 1'b1; fifo_w_data1 = 8'hF3; fifo_w_meta1 = 8'h1E;   //turn reset off after 20 ns, turn on input to fifos and begin input
		#20; wrreq_meta1 = 1'b0; fifo_w_meta1 = 8'h00; fifo_w_data1 = 8'h05;
		#20; fifo_w_data1 = 8'h19; 
		#20; fifo_w_data1 = 8'hC7; 
		#20; fifo_w_data1 = 8'h00; wrreq_data1 = 1'b0; blk_ready1 = 1'b1;
	end
	
	//display output of cout and dout 
	always @(negedge clk_20ns)
	begin
		$display($time, "<< Cout = %h, Dout = %h >>",  cout, dout);
	end
	
endmodule



