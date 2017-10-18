//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 David Null
//
// Create Date:    
// Design Name:    ECE 385 Lab 6 Generated Code - The ZEXT module 
// Module Name:    register
//
// Comments:
//    Revised 02-13-2017
//    Spring 2017 Distribution
//
//------------------------------------------------------------------------------

module ZEXT(
	input [15:0] in,
	output logic [19:0] out
);

	always_comb
		begin
			out <= 20'b0000000000000000 | in;
		end
		
endmodule


module sext5(
	input [4:0] in,
	output logic [15:0] out
);

	always_comb
		begin
			// Check for negative
			if(in[4])
				out <= {11'b11111111111, in};
			else
				out <= {11'b00000000000, in};
		end

endmodule


module sext6(
	input [5:0] in,
	output [15:0] out
);

	always_comb
	begin
		// Check for negative
		if(in[5] == 1'b1)
			assign out = {10'b1111111111, in};
		else
			assign out = {10'b0000000000, in};			
	end

endmodule


module sext9(
	input [8:0] in,
	output [15:0] out
);

	always_comb
	begin
		// Check for negative
		if(in[8] == 1'b1)
			assign out = {7'b1111111, in};
		else
			assign out = {7'b0000000, in};
	end

endmodule


module sext11(
	input [10:0] in,
	output [15:0] out
);

	always_comb
	begin
		// Check for negative
		if(in[10] == 1'b1)
			assign out = {5'b11111, in};
		else
			assign out = {5'b00000, in};			
	end

endmodule

