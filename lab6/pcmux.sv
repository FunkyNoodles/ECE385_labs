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
	input [15:0] addermux_in,
	input [15:0] bus_in,
	output logic [15:0] out
);

	always_comb
	begin
		unique case (select_bits)
		2'b00 : out = pc_in + 16'h0001;
		2'b01 : out = addermux_in;
		2'b10 : out = bus_in;
		2'b11 : out = bus_in;
		endcase
	end

endmodule

module addr2mux (
	input [1:0] select_bits,
	input [10:0] ir_in,
	output logic [15:0] out
);

	always_comb
	begin
		unique case (select_bits)
		2'b00 : out = 16'h0000;
		2'b01 : out = {ir_in[5], ir_in[5], ir_in[5], ir_in[5], ir_in[5], ir_in[5], ir_in[5], ir_in[5], ir_in[5], ir_in[5], ir_in[5:0]};
		2'b10 : out = {ir_in[8], ir_in[8], ir_in[8], ir_in[8], ir_in[8], ir_in[8], ir_in[8], ir_in[8:0]};
		2'b11 : out = {ir_in[10], ir_in[10], ir_in[10], ir_in[10], ir_in[10], ir_in[10:0]};
		endcase
	end

endmodule

module mux_2 (
	input select_bits,
	input [15:0] in1, in2,
	output logic [15:0] out
);

always_comb
	begin
		if(~select_bits)
			out = in1;
		else
			out = in2;
	end

endmodule

module mux_2_3bits (
	input select_bits,
	input [2:0] in1, in2,
	output logic [2:0] out
);

always_comb
	begin
		if(~select_bits)
			out = in1;
		else
			out = in2;
	end

endmodule
