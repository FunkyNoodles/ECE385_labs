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

module datapath(
	input logic Clk, Reset, Run, Continue,
	input logic GateMARMUX, GatePC, GateALU, GateMDR,
	input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,
	input logic [15:0] MAR, MDR, IR, PC,
	output logic [15:0] mar_out, ir_out, pc_out, mdr_out
	
);
	
	logic [15:0] ALU_output_data, bus_out;
	logic [15:0] internal_adder_data;

		register pc_register (
			.Clk(Clk),
			.Load(LD_PC),
			.in(PC),
			.out(pc_out)
		);
		
		assign mar_out = pc_out;
		assign ir_out = MAR;

		bus bus(
			.PC_data(pc_out), .MDR_data(MDR), .ALU_data(ALU_output_data), .ADDER_data(internal_adder_data),
			.GatePC(GatePC), .GateMDR(GateMDR), .GateALU(GateALU), .GateMARMUX(GateMARMUX),
			.out(bus_out)
		);
		
		pc_increment pc_increment(
			.in(pc_out),
			.out(pc_out)
		);
		

endmodule
