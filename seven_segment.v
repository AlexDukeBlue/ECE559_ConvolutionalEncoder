module seven_segment(inPins, outPins);
input 	[3:0]	inPins;
output 	[6:0] outPins;

assign outPins =	(inPins==4'h0)?7'b1000000:
					(inPins==4'h1)?7'b1111001:
					(inPins==4'h2)?7'b0100100:
					(inPins==4'h3)?7'b0110000:
					(inPins==4'h4)?7'b0011001:
					(inPins==4'h5)?7'b0010010:
					(inPins==4'h6)?7'b0000010:
					(inPins==4'h7)?7'b1111000:
					(inPins==4'h8)?7'b0000000:
					(inPins==4'h9)?7'b0010000:
					(inPins==4'hA)?7'b0001000:
					(inPins==4'hB)?7'b0000011:
					(inPins==4'hC)?7'b1000110:
					(inPins==4'hD)?7'b0100001:
					(inPins==4'hE)?7'b0000110:
					(inPins==4'hF)?7'b0001110:7'b0;

endmodule