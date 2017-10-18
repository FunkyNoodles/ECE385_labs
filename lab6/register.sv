//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 David Null
//
// Create Date:    
// Design Name:    ECE 385 Lab 6 Generated Code - The register module 
// Module Name:    register
//
// Comments:
//    Revised 02-13-2017
//    Spring 2017 Distribution
//
//------------------------------------------------------------------------------

module register(
	input Clk, Load, Reset,
	input [15:0] in,
	output logic [15:0] out
);

	logic [15:0] data;


	always_ff @ (posedge Clk)
	begin
			if(Reset)
				data <= 16'h0000;
			else if(Load)
				data <= in;
	end

	always_comb
	begin
		out = data;
	end

endmodule
