 module convEncoder_bs(clk, reset, blk_ready, tail_byte, code_block_length, blk_empty, blk_data, blk_data_rdreq, q0, q1, q2, rdreq_subblock, computation_done);
	input [7:0] blk_data, tail_byte;
	input rdreq_subblock, code_block_length;
	input clk, reset, blk_ready, blk_empty; 
	output [7:0] q0, q1, q2;
	
	output blk_data_rdreq, computation_done; 
	
	reg c0, c1, c2, c3, c4, c5, c6, delay_one_cycle, compute_enable, instantiate_computation;
	
	wire [12:0] counter_out;
	wire [6:0] out_to_fifo0, out_to_fifo1, out_to_fifo2, encoder_vals;
	wire [2:0] counter_mod;
	wire d0, d1, d2, on_last_bit_of_input, small_computation_notdone, large_computation_notdone, wrreq_out, rdreqOutput, empty0, empty1, empty2, usedw0, usedw1, usedw2;

	assign computation_done = (code_block_length[0]) ? ~large_computation_notdone : ~small_computation_notdone;
	assign blk_data_rdreq = (delay_one_cycle && instantiate_computation && ~blk_empty) || (on_last_bit_of_input && ~blk_empty && compute_enable);
	assign d0 = c0 ^ c2 ^ c3 ^ c5 ^ c6;
	assign d1 = c0 ^ c1 ^ c2 ^ c3 ^ c6;
	assign d2 = c0 ^ c1 ^ c2 ^ c4 ^ c6;
	assign wrreq_out = ((counter_mod==3'b000) && (compute_enable && ~computation_done && ~instantiate_computation));
	assign rdreqOutput = rdreq_subblock;
	assign encoder_vals = (instantiate_computation) ? {blk_data[0], tail_byte[7], tail_byte[6], tail_byte[5], tail_byte[4], tail_byte[3], tail_byte[2]} : {blk_data[counter_mod], c0, c1, c2, c3, c4, c5};

	
	counter_block cb((reset || (computation_done && ~compute_enable)), (compute_enable && ~computation_done && ~instantiate_computation), clk, counter_out);
	large_counter_compare lcc(counter_out, large_computation_notdone);
	small_counter_compare scc(counter_out[10:0], small_computation_notdone);
	mod_counter mc(compute_enable, clk, reset, counter_mod);
	mod_compare compare_mod(counter_mod, on_last_bit_of_input);
	
	function get_delay_one_cycle_state;
		input current_state, br, ce, rst;
		begin
			get_delay_one_cycle_state = ~rst && ~current_state && br && ~ce;
		end
	endfunction
	
	function get_compute_enable_state;
		input current_state, cd, doc, rst;
		begin
			get_compute_enable_state = ~rst && ~cd && (doc || current_state);
		end
	endfunction
	
	function get_instantiate_computation_state;
		input current_state, br, ce, doc, rst;
		begin
			get_instantiate_computation_state = ~rst && (doc || (!ce && br)); 
		end
	endfunction
	
	always @(posedge clk) 
	begin
		if(compute_enable && !computation_done)
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
		delay_one_cycle <= get_delay_one_cycle_state(delay_one_cycle, blk_ready, compute_enable, reset);
		compute_enable <= get_compute_enable_state(compute_enable, computation_done, delay_one_cycle, reset);
		instantiate_computation <= get_instantiate_computation_state(instantiate_computation, blk_ready, compute_enable, delay_one_cycle, reset);
	end

	shiftreg outreg0(clk, (compute_enable && ~computation_done && ~instantiate_computation), reset, d0, out_to_fifo0);
	shiftreg outreg1(clk, (compute_enable && ~computation_done && ~instantiate_computation), reset, d1, out_to_fifo1);
	shiftreg outreg2(clk, (compute_enable && ~computation_done && ~instantiate_computation), reset, d2, out_to_fifo2);
	
	fifo test_outputdata_fifo0(clk,{d0, out_to_fifo0},rdreqOutput, reset, wrreq_out,empty0,q0,usedw0);
	fifo test_outputdata_fifo1(clk,{d1, out_to_fifo1},rdreqOutput, reset, wrreq_out,empty1,q1,usedw1);
	fifo test_outputdata_fifo2(clk,{d2, out_to_fifo2},rdreqOutput, reset, wrreq_out,empty2,q2,usedw2);

endmodule
