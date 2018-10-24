module ff(clock,reset,rdreq,wrreq,fifo_in,fifo_out,empty,full);
  input clock,reset,rdreq,wrreq;
  input [7:0]fifo_in;
  output reg[7:0]fifo_out;
  output reg [7:0]rd_ptr,wr_ptr,counter;
  output wire empty,full;
  reg mem[0:7];

	always @(posedge clk)begin
		if(!reset)
			counter <= 0;
		else if((!full&&wrreq)&&(!empty&&rdreq)) 
			counter <= counter;
		else if(!full && rdreq)         
			counter <= counter + 1;
		else if(!empty && wrreq )        
			counter <= counter-1;
		else 
			counter <= counter;
	end
	
	always @(posedge clk) begin   
		if(!reset)
			fifo_out <= 0;
		if(wrreq && !empty)
			fifo_out <= mem[wr_ptr];
	end
	
	always @(posedge clk) begin
		if(rdreq && !full)
			mem[rd_ptr] <= fifo_in;
	end
	
	always @(posedge clk) begin
		if(!reset) begin
			rd_ptr <= 0;
			wr_ptr <= 0;
		end
		else begin
			if(!full && rdreq)
				rd_ptr <= rd_ptr + 1;
			if(!empty && wrreq)
				wr_ptr <= wr_ptr + 1;
		end
	end


   assign empty=(counter==0);    
   assign full=(counter==8);


   endmodule