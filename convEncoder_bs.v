module convEncoder_bs(clk, reset, blk_size, tail_bits, blk_empty, blk_data, blk_rdreq, dOut, cOut);
	//If the input block is FIFO, not sure how we get the last six
	input [7:0] blk_data;
	input [5:0] tail_bits;
	input clk, reset, blk_size, blk_empty;
	output [6:0] cOut; 
	output [2:0] dOut;
	output blk_rdreq; 
	
	localparam small_size = 13'd1056;
	localparam large_size = 13'd6144;
	
	reg [12:0]  computation_counter;
	reg c0, c1, c2, c3, c4, c5, c6, instantiate_computation;
	
	wire [12:0] size;
	wire compute_enable, d0, d1, d2;
	
	assign size = (blk_size) ? large_size : small_size;
   assign compute_enable = (computation_counter < size) ? 1'b1 : 1'b0;
	assign d0 = c0 ^ c2 ^ c3 ^ c5 ^ c6;
	assign d1 = c0 ^ c1 ^ c2 ^ c3 ^ c6;
	assign d2 = c0 ^ c1 ^ c2 ^ c4 ^ c6;
	assign blk_rdreq = computation_counter % 8;
	assign cOut = {c0, c1, c2, c3, c4, c5, c6};
	assign dOut = {d0, d1, d2};
	
	//We need to figure out how when to decide to start/continue computation other than what it is above.
	
	//I think it is necessary for us to use a singly-clocked FIFO (one for read and one for write).
	//This also allows us to input the compute output as bit-serial, but output 8-bits at a time.
	//	dc_fifo fifo0();
	//	dc_fifo fifo1();
	//	dc_fifo fifo2();

	always @(posedge clk) 
	begin
		blk_rdreq <= 1'b0;
		if(!reset)
		begin
			if(compute_enable && !instantiate_computation)
			begin
				//Computation Logic
				c0 <= blk_data[computation_counter % 8];
				c1 <= c0;
				c2 <= c1;
				c3 <= c2;
				c4 <= c3;
				c5 <= c4;
				c6 <= c5;
				computation_counter <= computation_counter + 13'd1;
				if((computation_counter % 8) && (!blk_empty))
				begin
					blk_rdreq <= 1'b1;
				end
			end else if(instantiate_computation)
			begin
				//Instantiation Logic
				//Tail_bits goes from [5 .. 0] => [last bit .. 6th to last bit]
				//Block bits go from [7 .. 0] => [eigth bit .. first bit]
				c0 <= blk_data[0];
				c1 <= tail_bits[5];
				c2 <= tail_bits[4];
				c3 <= tail_bits[3];
				c4 <= tail_bits[2];
				c5 <= tail_bits[1];
				c6 <= tail_bits[0];
				computation_counter <= computation_counter + 13'd1;
				instantiate_computation <= 1'b0;
			end
		end else if(reset)
		begin 
			computation_counter <= 13'd0;
			instantiate_computation <= 1'b1;
			if(!blk_empty)
			begin
				blk_rdreq <= 1'b1;
			end
		end
	end

	//Need to set up case for what to do if blk_empty is asserted when we need it to not be lmao.
	
endmodule
