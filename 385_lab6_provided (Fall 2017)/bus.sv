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

module bus(
	input logic [15:0] PC_data, MDR_data, ALU_data, ADDER_data,
	input logic GatePC, GateMDR, GateALU, GateMARMUX,
	output logic [15:0] out
);

always_ff @ (GatePC or GateMDR or GateALU or GateMARMUX)
	begin
		if(GatePC)
			out <= PC_data;
		else if(GateMDR)
			out <= MDR_data;
		else if(GateALU)
			out <= ALU_data;
		else if(GateMARMUX)
			out <= ADDER_data;
	end

endmodule
