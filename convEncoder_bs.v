module convEncoder_bs(clk, reset, blk_ready, blk_meta, blk_empty, blk_data, blk_meta_rdreq, blk_data_rdreq, dOut, cOut, computation_done, instantiate_computation, compute_enable, counter_out, counter_mod, out_to_fifo0, out_to_fifo1, out_to_fifo2);
	//If the input block is FIFO, not sure how we get the last six
	input [7:0] blk_data, blk_meta;
	input clk, reset, blk_ready, blk_empty;
	output [12:0] counter_out;
	output [7:0] out_to_fifo0, out_to_fifo1, out_to_fifo2;
	output [6:0] cOut; 
	output [2:0] dOut, counter_mod;
	output blk_meta_rdreq, blk_data_rdreq; 
	output computation_done, instantiate_computation, compute_enable;
	
	reg c0, c1, c2, c3, c4, c5, c6, compute_enable, instantiate_computation, delay_one_cycle;
	
	//wire [12:0] counter_out;
	//wire [2:0] counter_mod;
	wire [7:0] out_to_fifo0, out_to_fifo1, out_to_fifo2;
	wire d0, d1, d2, on_last_bit_of_input, small_computation_notdone, large_computation_notdone, computation_done;

	assign computation_done = (blk_meta[0]) ? !large_computation_notdone : !small_computation_notdone;
	assign blk_meta_rdreq = instantiate_computation && !blk_empty;
	assign blk_data_rdreq = (delay_one_cycle && instantiate_computation && !blk_empty) || (on_last_bit_of_input && !blk_empty && compute_enable);
	assign d0 = c0 ^ c2 ^ c3 ^ c5 ^ c6;
	assign d1 = c0 ^ c1 ^ c2 ^ c3 ^ c6;
	assign d2 = c0 ^ c1 ^ c2 ^ c4 ^ c6;
	assign cOut = {c0, c1, c2, c3, c4, c5, c6};
	assign dOut = {d0, d1, d2};

	counter_block cb((compute_enable && !computation_done), clk, (reset || instantiate_computation), counter_out);
	large_counter_compare lcc(counter_out, large_computation_notdone);
	small_counter_compare scc(counter_out[10:0], small_computation_notdone);
	mod_counter mc(compute_enable, clk, reset, counter_mod);
	mod_compare compare_mod(counter_mod, on_last_bit_of_input);
	
	always @(posedge clk) 
	begin
		if(reset)
		begin 
			compute_enable <= 1'b0;
			instantiate_computation <= 1'b0;
		end
		else if(delay_one_cycle)
		begin
			delay_one_cycle <= 1'b0;
			compute_enable <= 1'b1;
		end else if(computation_done)
		begin
			compute_enable <= 1'b0;
		end
		else if(blk_ready && !compute_enable)
		begin
			 instantiate_computation <= 1'b1;
			 delay_one_cycle <= 1'b1;
		end
		else
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
				//Tail_bits goes from [7 .. 2] => [last bit .. 6th to last bit] in the meta array. 
				//An arbitrary value separates the tail-bits from the size bit.
				//Block bits go from [7 .. 0] => [eigth bit .. first bit]
				c0 <= blk_data[0];
				c1 <= blk_meta[7];
				c2 <= blk_meta[6];
				c3 <= blk_meta[5];
				c4 <= blk_meta[4];
				c5 <= blk_meta[3];
				c6 <= blk_meta[2];
				instantiate_computation <= 1'b0;
				//compute_enable <= 1'b1;
			end
		end
	end

	shiftreg outreg0(clk, (compute_enable && !computation_done), reset, d0, out_to_fifo0);
	shiftreg outreg1(clk, (compute_enable && !computation_done), reset, d1, out_to_fifo1);
	shiftreg outreg2(clk, (compute_enable && !computation_done), reset, d2, out_to_fifo2);
	
endmodule
