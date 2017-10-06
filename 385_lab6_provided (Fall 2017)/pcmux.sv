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


module pc_mux(
	input [1:0] select_bits,
	input [15:0] pc_in,
	input [15:0] adder_mux,
	input [15:0] bus,
	output logic [15:0] out
);

	logic [15:0] pc_out;

	pc_increment pc_increment(
		.in(pc_in),
		.out(pc_out)
	);

	always_comb
	begin
		unique case (select_bits)
		2'b00 : out = pc_out;
		2'b01 : out = adder_mux;
		2'b10 : out = bus;
		2'b11 : out = bus;
		endcase
	end

endmodule
