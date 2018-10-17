module convEncoder_bs(clk, reset, blk_ready, blk_size, tail_bits, blk_empty, blk_data, blk_rdreq, dOut, cOut);
	//If the input block is FIFO, not sure how we get the last six
	input [7:0] blk_data;
	input [5:0] tail_bits;
	input clk, reset, blk_ready, blk_size, blk_empty;
	output [6:0] cOut; 
	output [2:0] dOut;
	output reg blk_rdreq; 
	
	reg c0, c1, c2, c3, c4, c5, c6, compute_enable, instantiate_computation;
	
	wire [12:0] computation_counter, large_counter_out;
	wire [11:0] small_counter_out;
	wire [2:0] counter_mod;
	wire d0, d1, d2, on_last_bit_of_input, small_computation_notdone, large_computation_notdone, computation_done;

	assign computation_done = (blk_size) ? !large_computation_notdone : !small_computation_notdone;
	assign computation_counter = (blk_size) ? large_counter_out : {1'b0, 1'b0, small_counter_out};
	assign blk_rdreq = on_last_bit_of_input && !blk_empty && compute_enable;
	assign d0 = c0 ^ c2 ^ c3 ^ c5 ^ c6;
	assign d1 = c0 ^ c1 ^ c2 ^ c3 ^ c6;
	assign d2 = c0 ^ c1 ^ c2 ^ c4 ^ c6;
	assign cOut = {c0, c1, c2, c3, c4, c5, c6};
	assign dOut = {d0, d1, d2};

	counter_large_block clb(compute_enable, clk, reset, large_counter_out);
	counter_small_block csb(compute_enable, clk, reset, small_counter_out);
	large_counter_compare lcc(large_counter_out, large_computation_notdone);
	small_counter_compare scc(small_counter_out, small_computation_notdone);
	mod_counter mc(compute_enable, clk, reset, counter_mod);
	mod_compare compare_mod(counter_mod, on_last_bit_of_input);
	
	always @(posedge clk) 
	begin
		if(computation_done)
		begin
			compute_enable <= 1'b0;
		end
		if(blk_ready && !compute_enable)
		begin
			 instantiate_computation <= 1'b1;
			 compute_enable <= 1'b1;
		end
		if(!reset)
		begin
			if(compute_enable && !instantiate_computation)
			begin
				//Computation Logic
				c0 <= blk_data[counter_mod];
				c1 <= c0;
				c2 <= c1;
				c3 <= c2;
				c4 <= c3;
				c5 <= c4;
				c6 <= c5;
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
				instantiate_computation <= 1'b0;
			end
		end else if(reset)
		begin 
			instantiate_computation <= 1'b0;
		end
	end

	//Need to set up case for what to do if blk_empty is asserted when we need it to not be lmao.
	
endmodule
