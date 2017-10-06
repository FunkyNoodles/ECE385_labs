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
	input logic [15:0] PC_data, MDR_data,
	input logic GatePC, GateMDR,
	output logic [15:0] out
);

always_comb
	begin
		case ({GatePC, GateMDR})
			GatePC:
				out = PC_data;
			GateMDR:
				out = MDR_data;
			default:
				out = 4'h0000;
		endcase
	end

endmodule
