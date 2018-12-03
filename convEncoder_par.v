 module convEncoder_par(clk, reset, data_valid, tail_byte, code_block_length, blk_empty, blk_data, blk_data_rdreq, q0, q1, q2, rdreq_subblock, computation_done, length_out);
	input [0:7] blk_data;
	input [0:7] tail_byte;
	input rdreq_subblock, code_block_length;
	input clk, reset, data_valid, blk_empty; 
	output [7:0] q0, q1, q2;
	output blk_data_rdreq, computation_done, length_out;
	
	reg [2:0] ready_for_computation;
	reg [1:0] counter_reset;
	reg c1, c2, c3, c4, c5, c6, delay_one_cycle, compute_enable, instantiate_computation, output_length;
	
	wire [12:0] counter_out;
	wire [9:0] usedw0, usedw1, usedw2;
	wire [7:0] d0, d1, d2;
	wire [6:0] out_to_fifo0, out_to_fifo1, out_to_fifo2;
	wire [5:0] encoder_vals;
	wire [2:0] counter_mod;
	wire d00, d01, d02, d10, d11, d12, d20, d21, d22, d30, d31, d32, d40, d41, d42, d50, d51, d52, d60, d61, d62, d70, d71, d72;
	wire c0, w0, w1, w2, w3, w4, w5, w6;
	wire on_last_bit_of_input, small_computation_notdone, large_computation_notdone, wrreq_out, rdreqOutput, empty0, empty1, empty2, setup_done, counter_done;
	
	assign counter_done = (output_length) ? ~large_computation_notdone : ~small_computation_notdone;
	assign blk_data_rdreq = (delay_one_cycle && instantiate_computation && ~blk_empty) || (~blk_empty && compute_enable);
	assign c0 = blk_data[0];
	assign w0 = blk_data[1];
	assign w1 = blk_data[2];
	assign w2 = blk_data[3];
	assign w3 = blk_data[4];
	assign w4 = blk_data[5];
	assign w5 = blk_data[6];
	assign w6 = blk_data[7];
	assign d00 = c0 ^ c2 ^ c3 ^ c5 ^ c6;
	assign d01 = c0 ^ c1 ^ c2 ^ c3 ^ c6;
	assign d02 = c0 ^ c1 ^ c2 ^ c4 ^ c6;
	assign d10 = w0 ^ c1 ^ c2 ^ c4 ^ c5;
	assign d11 = w0 ^ c0 ^ c1 ^ c2 ^ c5;
	assign d12 = w0 ^ c0 ^ c1 ^ c3 ^ c5;
	assign d20 = w1 ^ c0 ^ c1 ^ c3 ^ c4;
	assign d21 = w1 ^ w0 ^ c0 ^ c1 ^ c4;
	assign d22 = w1 ^ w0 ^ c0 ^ c2 ^ c4;
	assign d30 = w2 ^ w0 ^ c0 ^ c2 ^ c3;
	assign d31 = w2 ^ w1 ^ w0 ^ c0 ^ c3;
	assign d32 = w2 ^ w1 ^ w0 ^ c1 ^ c3;
	assign d40 = w3 ^ w1 ^ w0 ^ c1 ^ c2;
	assign d41 = w3 ^ w2 ^ w1 ^ w0 ^ c2;
	assign d42 = w3 ^ w2 ^ w1 ^ c0 ^ c2;
	assign d50 = w4 ^ w2 ^ w1 ^ c0 ^ c1;
	assign d51 = w4 ^ w3 ^ w2 ^ w1 ^ c1;
	assign d52 = w4 ^ w3 ^ w2 ^ w0 ^ c1;
	assign d60 = w5 ^ w3 ^ w2 ^ w0 ^ c0;
	assign d61 = w5 ^ w4 ^ w3 ^ w2 ^ c0;
	assign d62 = w5 ^ w4 ^ w3 ^ w1 ^ c0;
	assign d70 = w6 ^ w4 ^ w3 ^ w1 ^ w0;
	assign d71 = w6 ^ w5 ^ w4 ^ w3 ^ w0;
	assign d72 = w6 ^ w5 ^ w4 ^ w2 ^ w0;
	assign wrreq_out = (compute_enable && ~counter_done);
	assign rdreqOutput = rdreq_subblock;
	assign encoder_vals = (delay_one_cycle) ? {tail_byte[7], tail_byte[6], tail_byte[5], tail_byte[4], tail_byte[3], tail_byte[2]} : {blk_data[7], blk_data[6], blk_data[5], blk_data[4], blk_data[3], blk_data[2]}; 
	assign setup_done = ready_for_computation == 3'b100;
	assign length_out = output_length;
	assign computation_done = counter_reset == 2'b10;
	assign d0 = {d70, d60, d50, d40, d30, d20, d10, d00};
	assign d1 = {d71, d61, d51, d41, d31, d21, d11, d01};
	assign d2 = {d72, d62, d52, d42, d32, d22, d12, d02};
	
	counter_block_par cb((compute_enable && ~counter_done && ~instantiate_computation || (counter_reset[0] || counter_reset[1])), clk, (reset || (counter_reset == 2'b10)), counter_out);
	large_counter_compare_par lcc(counter_out, large_computation_notdone);//768-10bits
	small_counter_compare_par scc(counter_out[7:0], small_computation_notdone);//132-8bits
	
	always @(posedge clk) 
	begin
		if(reset)
		begin
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
			counter_reset <= 2'b00;
		end else
		begin
			if((compute_enable || delay_one_cycle) && ~counter_done)
			begin
				//Computation Logic
				c1 <= encoder_vals[5];
				c2 <= encoder_vals[4];
				c3 <= encoder_vals[3];
				c4 <= encoder_vals[2];
				c5 <= encoder_vals[1];
				c6 <= encoder_vals[0];
			end
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
		if(~reset && ~delay_one_cycle && setup_done && ~compute_enable)
		begin
			delay_one_cycle <= 1'b1;
		end else
		begin
			delay_one_cycle <= 1'b0;
		end
		if(~reset && ~counter_done && (delay_one_cycle || compute_enable))
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
	
	fifo test_outputdata_fifo0(~clk, d0,rdreqOutput, reset, wrreq_out,empty0,q0,usedw0);
	fifo test_outputdata_fifo1(~clk, d1,rdreqOutput, reset, wrreq_out,empty1,q1,usedw1);
	fifo test_outputdata_fifo2(~clk, d2,rdreqOutput, reset, wrreq_out,empty2,q2,usedw2);

endmodule
