module convEncoder_bs(clk, blk_size, blk_ready, blk, out_rdy, fifo0_out, fifo1_out, fifo2_out);
	//If the input block is FIFO, not sure how we get the last six
	input [7:0] blk;
	input clk, blk_ready, blk_size;
	output [7:0] fifo0_out, fifo1_out, fifo2_out; 
	output out_rdy; 
	
	wire compute_enable, instantiate_computation, d0, d1, d2;

	reg [13:0]  computation_counter;
	reg c0, c1, c2, c3, c4, c5, c6;
	
	localparam small_size = 11'd1056;
	localparam large_size = 13'd6144;
	
	//We need to figure out how when to decide to start/continue computation.
	//assign compute_enable = ;
	
	//I think it is necessary for us to use a doubly-clocked FIFO (one for read and one for write).
	//This also allows us to input the compute output as bit-serial, but output 8-bits at a time.
//	dc_fifo fifo0();
//	dc_fifo fifo1();
//	dc_fifo fifo2();
	
	wire [12:0] size;
	assign size = (blk_size) ? large_size : small_size;

	always @(posedge clk) 
	begin
		if(clk) begin
			if(compute_enable && !instantiate_computation)begin
				//Computation Logic
				c0 <= blk[computation_counter];
				c1 <= c0;
				c2 <= c1;
				c3 <= c2;
				c4 <= c3;
				c5 <= c4;
				c6 <= c5;
			end else if(instantiate_computation) begin
				//Instantiation Logic
				c0 <= blk[computation_counter];
				c1 <= blk[size - 1];
				c2 <= blk[size - 2];
				c3 <= blk[size - 3];
				c4 <= blk[size - 4];
				c5 <= blk[size - 5];
				c6 <= blk[size - 6];
			end
			computation_counter <= computation_counter + 1;
		end
	end

endmodule
