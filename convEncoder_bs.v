 module convEncoder_bs(clk, reset, data_valid, tail_byte, code_block_length, blk_empty, blk_data, blk_data_rdreq, q0, q1, q2, rdreq_subblock, computation_done, length_out, empty);
	input [0:7] blk_data;
	input [0:7] tail_byte;
	input rdreq_subblock, code_block_length;
	input clk, reset, data_valid, blk_empty; 
	output [7:0] q0, q1, q2;
	output blk_data_rdreq, computation_done, length_out, empty;
	
	reg [2:0] ready_for_computation, computeFSM_val;
	reg [1:0] counter_reset;
	reg c0, c1, c2, c3, c4, c5, c6, output_length;
	
	wire [12:0] counter_out;
	wire [9:0] usedw0, usedw1, usedw2;
	wire [6:0] out_to_fifo0, out_to_fifo1, out_to_fifo2, encoder_vals;
	wire [2:0] counter_mod;
	wire d0, d1, d2, on_last_bit_of_input, small_computation_notdone, large_computation_notdone, wrreq_out, rdreqOutput, empty0, empty1, empty2, setup_done, counter_done;
	wire delay_one_cycle, compute_enable, instantiate_computation;
	
	assign empty = empty0 && empty1 && empty2;
	assign counter_done = (output_length == 1'b1) ? ~large_computation_notdone : ~small_computation_notdone;
	assign blk_data_rdreq = (delay_one_cycle && instantiate_computation && ~blk_empty) || (on_last_bit_of_input && ~blk_empty && compute_enable);
	assign d0 = c0 ^ c2 ^ c3 ^ c5 ^ c6;
	assign d1 = c0 ^ c1 ^ c2 ^ c3 ^ c6;
	assign d2 = c0 ^ c1 ^ c2 ^ c4 ^ c6;
	assign wrreq_out = ((counter_mod==3'b000) && (compute_enable && ~counter_done && ~instantiate_computation));
	assign rdreqOutput = rdreq_subblock;
	assign encoder_vals = (instantiate_computation) ? {blk_data[0], tail_byte[7], tail_byte[6], tail_byte[5], tail_byte[4], tail_byte[3], tail_byte[2]} : {blk_data[counter_mod], c0, c1, c2, c3, c4, c5}; 
	assign setup_done = ready_for_computation == 3'b100;
	assign length_out = output_length == 1'b1;
	assign computation_done = counter_reset == 2'b10;
	assign instantiate_computation = (computeFSM_val == 3'b110) || (computeFSM_val == 3'b101);
	assign delay_one_cycle = computeFSM_val == 3'b110;
	assign compute_enable = (computeFSM_val == 3'b101) || (computeFSM_val == 3'b001);
	
	counter_block cb((compute_enable && ~counter_done && ~instantiate_computation || (counter_reset == 2'b10 || counter_reset == 2'b01)), clk, (reset || (counter_reset == 2'b10)), counter_out);
	large_counter_compare lcc(counter_out, large_computation_notdone);
	small_counter_compare scc(counter_out[10:0], small_computation_notdone);
	mod_counter mc((compute_enable || (counter_reset == 2'b10 || counter_reset == 2'b01)), clk, (reset || (counter_reset == 2'b10)), counter_mod);
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
			computeFSM_val <= 3'b000;
			output_length <= 1'b0;
			counter_reset <= 2'b00;
		end else
		begin
			if(compute_enable && ~counter_done)
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
		if(counter_reset == 2'b00)
		begin
			if(counter_done)
			begin
				counter_reset <= 2'b01;
			end
		end else if(counter_reset == 2'b01)
		begin
			counter_reset <= 2'b10;
		end else if(counter_reset == 2'b10)
		begin
			counter_reset <= 2'b00;
		end
		
		if(ready_for_computation == 3'b000)
		begin
			if(data_valid && ~(empty0 && empty1 && empty2))
			begin
				ready_for_computation <= 3'b001;
			end else if(~data_valid && (empty0 && empty1 && empty2))
			begin
				ready_for_computation <= 3'b010;
			end else
			begin
				ready_for_computation <= 3'b000;
			end
		end else if(ready_for_computation == 3'b001)
		begin
			if(empty0 && empty1 && empty2)
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
		end else if((ready_for_computation == 3'b100) && counter_done)
		begin
			ready_for_computation <= 3'b000;
		end
		
		if(computeFSM_val == 3'b000)
		begin
			if(setup_done)
			begin
				computeFSM_val <= 3'b110;
			end else
			begin
				computeFSM_val <= 3'b000;
			end
		end else if(computeFSM_val == 3'b110)
		begin
			computeFSM_val <= 3'b101;
		end else if(computeFSM_val == 3'b101)
		begin
			computeFSM_val <= 3'b001;
		end else if(computeFSM_val == 3'b001)
		begin
			if(counter_done)
			begin
				computeFSM_val <= 3'b000;
			end else
			begin
				computeFSM_val <= 3'b001;
			end
		end
		
		if(output_length == 1'b0)
		begin
			if(instantiate_computation && code_block_length)
			begin
				output_length <= 1'b1;
			end
		end else if(output_length == 1'b1)
		begin
			if(instantiate_computation && ~code_block_length)
			begin
				output_length <= 1'b0;
			end
		end
		end
	end

	shiftreg outreg0(clk, (compute_enable && ~counter_done && ~instantiate_computation), reset, d0, out_to_fifo0);
	shiftreg outreg1(clk, (compute_enable && ~counter_done && ~instantiate_computation), reset, d1, out_to_fifo1);
	shiftreg outreg2(clk, (compute_enable && ~counter_done && ~instantiate_computation), reset, d2, out_to_fifo2);
	
	fifo test_outputdata_fifo0(clk,{d0, out_to_fifo0},rdreqOutput, reset, wrreq_out,empty0,q0,usedw0);
	fifo test_outputdata_fifo1(clk,{d1, out_to_fifo1},rdreqOutput, reset, wrreq_out,empty1,q1,usedw1);
	fifo test_outputdata_fifo2(clk,{d2, out_to_fifo2},rdreqOutput, reset, wrreq_out,empty2,q2,usedw2);

endmodule
