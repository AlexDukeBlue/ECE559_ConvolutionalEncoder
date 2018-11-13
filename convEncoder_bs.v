 module convEncoder_bs(clk, reset, data_valid, tail_byte, code_block_length, blk_empty, blk_data, blk_data_rdreq, q0, q1, q2, rdreq_subblock, computation_done, length_out);
	input [0:7] blk_data
	input [7:0] tail_byte;
	input rdreq_subblock, code_block_length;
	input clk, reset, data_valid, blk_empty; 
	output [7:0] q0, q1, q2;
	output blk_data_rdreq, computation_done, length_out; 
	
	reg [2:0] ready_for_computation;
	reg c0, c1, c2, c3, c4, c5, c6, delay_one_cycle, compute_enable, instantiate_computation, output_length;
	
	wire [12:0] counter_out;
	wire [6:0] out_to_fifo0, out_to_fifo1, out_to_fifo2, encoder_vals;
	wire [2:0] counter_mod;
	wire d0, d1, d2, on_last_bit_of_input, small_computation_notdone, large_computation_notdone, wrreq_out, rdreqOutput, empty0, empty1, empty2, usedw0, usedw1, usedw2, setup_done;

	assign computation_done = (output_length) ? ~large_computation_notdone : ~small_computation_notdone;
	assign blk_data_rdreq = (delay_one_cycle && instantiate_computation && ~blk_empty) || (on_last_bit_of_input && ~blk_empty && compute_enable);
	assign d0 = c0 ^ c2 ^ c3 ^ c5 ^ c6;
	assign d1 = c0 ^ c1 ^ c2 ^ c3 ^ c6;
	assign d2 = c0 ^ c1 ^ c2 ^ c4 ^ c6;
	assign wrreq_out = ((counter_mod==3'b000) && (compute_enable && ~computation_done && ~instantiate_computation));
	assign rdreqOutput = rdreq_subblock;
	assign encoder_vals = (instantiate_computation) ? {blk_data[0], tail_byte[7], tail_byte[6], tail_byte[5], tail_byte[4], tail_byte[3], tail_byte[2]} : {blk_data[counter_mod], c0, c1, c2, c3, c4, c5}; 
	assign setup_done = ready_for_computation == 3'b100;
	assign length_out = output_length;
	
	counter_block cb((reset || (computation_done && ~compute_enable)), (compute_enable && ~computation_done && ~instantiate_computation), clk, counter_out);
	large_counter_compare lcc(counter_out, large_computation_notdone);
	small_counter_compare scc(counter_out[10:0], small_computation_notdone);
	mod_counter mc(compute_enable, clk, reset, counter_mod);
	mod_compare compare_mod(counter_mod, on_last_bit_of_input);
	
	always @(posedge clk) 
	begin
		if(reset)
		begin
			c0 <= 1'b0;
			c1 <= 1'b0;
			c2 <= 1'b0;
			c3 <= 1'b0;
			c4 <= 1'b0;
			c5 <= 1'b0;
			c6 <= 1'b0;
			ready_for_computation <= 3'b000;
			delay_one_cycle <= 1'b0;
			compute_enable <= 1'b0;
			instantiate_computation <= 1'b0;
			output_length <= 1'b0;
		end else
		begin
			if(compute_enable && ~computation_done)
			begin
				//Computation Logic
				c0 <= encoder_vals[6];
				c1 <= encoder_vals[5];
				c2 <= encoder_vals[4];
				c3 <= encoder_vals[3];
				c4 <= encoder_vals[2];
				c5 <= encoder_vals[1];
				c6 <= encoder_vals[0];
			end
		end
		if(ready_for_computation == 3'b000)
		begin
			if(data_valid && ~blk_empty)
			begin
				ready_for_computation <= 3'b001;
			end else if(~data_valid && blk_empty)
			begin
				ready_for_computation <= 3'b010;
			end else
			begin
				ready_for_computation <= 3'b000;
			end
		end else if(ready_for_computation == 3'b001)
		begin
			if(blk_empty)
			begin
				ready_for_computation <= 3'b100;
			end else
			begin
				ready_for_computation <= 3'b001;
			end
		end else if(ready_for_computation == 3'b010)
		begin
			if(data_valid)
			begin
				ready_for_computation <= 3'b100;
			end else
			begin
				ready_for_computation <= 3'b010;
			end
		end else if(ready_for_computation == 3'b100)
		begin
			ready_for_computation <= 3'b000;
		end
		if(~reset && ~delay_one_cycle && setup_done && ~compute_enable)
		begin
			delay_one_cycle <= 1'b1;
		end else
		begin
			delay_one_cycle <= 1'b0;
		end
		if(~reset && ~computation_done && (delay_one_cycle || compute_enable))
		begin
			compute_enable <= 1'b1;
		end else
		begin
			compute_enable <= 1'b0;
		end
		if(~reset && (delay_one_cycle || (~compute_enable && setup_done)))
		begin
			instantiate_computation <= 1'b1;
		end else
		begin
			instantiate_computation <= 1'b0;
		end
		if(instantiate_computation)
		begin
			output_length <= code_block_length;
		end
	end

	shiftreg outreg0(clk, (compute_enable && ~computation_done && ~instantiate_computation), reset, d0, out_to_fifo0);
	shiftreg outreg1(clk, (compute_enable && ~computation_done && ~instantiate_computation), reset, d1, out_to_fifo1);
	shiftreg outreg2(clk, (compute_enable && ~computation_done && ~instantiate_computation), reset, d2, out_to_fifo2);
	
	fifo test_outputdata_fifo0(clk,{d0, out_to_fifo0},rdreqOutput, reset, wrreq_out,empty0,q0,usedw0);
	fifo test_outputdata_fifo1(clk,{d1, out_to_fifo1},rdreqOutput, reset, wrreq_out,empty1,q1,usedw1);
	fifo test_outputdata_fifo2(clk,{d2, out_to_fifo2},rdreqOutput, reset, wrreq_out,empty2,q2,usedw2);

endmodule
