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
	input logic GateMARMUX, GatePC, GateMDR,
	input logic LD_MAR, LD_MDR, LD_IR, LD_PC, MIO_EN,
	input [15:0] MDR_In,
	output logic [15:0] MAR, MDR, IR, PC
);
	
	logic [15:0] bus_out, mdr_mux_out;
	
	MUX_2 MDR_MUX(
		.SELECT(MIO_EN),
		.in1(bus_out),
		.in2(MDR_In),
		.out(mdr_mux_out)
	);

	bus bus_line(
		.PC_data(PC), .MDR_data(MDR),
		.GatePC(GatePC), .GateMDR(GateMDR),
		.out(bus_out)
	);
	
	register pc_register (
		.*,
		.Clk(Clk),
		.Load(LD_PC),
		.in(PC + 4'h0001),
		.out(PC)
	);
	
	register mar_register (
		.*,
		.Clk(Clk),
		.Load(LD_MAR),
		.in(bus_out),
		.out(MAR)
	);

	register mdr_register (
		.*,
		.Clk(Clk),
		.Load(LD_MDR),
		.in(mdr_mux_out),
		.out(MDR)
	);

	register ir_register (
		.*,
		.Clk(Clk),
		.Load(LD_IR),
		.in(bus_out),
		.out(IR)
	);

endmodule
