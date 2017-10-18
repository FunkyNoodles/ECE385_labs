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
	input logic GateMARMUX, GatePC, GateMDR, GateALU, LD_BEN, LD_CC,
	input logic LD_MAR, LD_MDR, LD_IR, LD_PC, LD_REG, MIO_EN, SR1MUX, DRMUX, SR2MUX, ADDR1MUX,
	input logic	[1:0] PCMUX, ADDR2MUX, ALUK,
	input logic [15:0] MDR_In,
	output logic [15:0] MAR, MDR, IR, PC,
	output logic BEN
);
	
	logic [15:0] bus_out, mdr_mux_out, alu_out, pcmux_out;
	logic [15:0] addermux_out, addr2mux_out, addr1mux_out;
	logic [15:0] sr1_out, sr2_out, sr2mux_out;
	logic [2:0] sr1mux_out, drmux_out;
	logic cout, N, Z, P;
	
	mux_2 MDR_MUX(
		.select_bits(MIO_EN),
		.in1(bus_out[15:0]),
		.in2(MDR_In[15:0]),
		.out(mdr_mux_out[15:0])
	);

	bus bus_line(
		.PC_data(PC[15:0]), .MDR_data(MDR[15:0]), .ALU_data(alu_out[15:0]), .MARMUX_data(addermux_out[15:0]),
		.GatePC(GatePC), .GateMDR(GateMDR), .GateALU(GateALU), .GateMARMUX(GateMARMUX),
		.out(bus_out[15:0])
	);
	
	pc_mux pc_mux(
		.select_bits(PCMUX[1:0]), .pc_in(PC[15:0]), 
		.addermux_in(addermux_out[15:0]), .bus_in(bus_out[15:0]), .out(pcmux_out[15:0])
	);
	
//	ripple_adder adder(
//		.A(addr2mux_out[15:0]), .B(addr1mux_out[15:0]), .Sum(addermux_out[15:0]), .CO(cout)
//	);
	assign addermux_out[15:0] = addr1mux_out[15:0] + addr2mux_out[15:0];
	
	addr2mux addr2mux(
		.select_bits(ADDR2MUX[1:0]), .ir_in(IR[10:0]),
		.out(addr2mux_out[15:0])
	);
	
	mux_2 addr1mux(
		.select_bits(ADDR1MUX), .in1(PC[15:0]), .in2(sr1_out[15:0]),
		.out(addr1mux_out[15:0])
	);
	
	mux_2_3bits drmux(
		.select_bits(DRMUX), .in1(IR[11:9]), .in2(3'b111),
		.out(drmux_out[2:0])
	);
	
	mux_2_3bits sr1mux(
		.select_bits(SR1MUX), .in1(IR[8:6]), .in2(IR[11:9]),
		.out(sr1mux_out[2:0])
	);
	
	reg_file reg_file(
		.bus_in(bus_out[15:0]), .sr1mux_in(sr1mux_out[2:0]), .drmux_in(drmux_out[2:0]), .sr2_in(IR[2:0]),
		.ld_reg(LD_REG), .Reset(Reset), .Clk(Clk),
		.sr1_out(sr1_out[15:0]), .sr2_out(sr2_out[15:0])
	);
	
	mux_2 sr2mux(
		.select_bits(SR2MUX), .in1(sr2_out[15:0]), .in2({IR[4],IR[4],IR[4],IR[4],IR[4],IR[4],IR[4],IR[4],IR[4],IR[4],IR[4], IR[4:0]}),
		.out(sr2mux_out[15:0])
	);
	
	alu alu(
		.A(sr1_out[15:0]), .B(sr2mux_out[15:0]), .aluk(ALUK[1:0]), .out(alu_out[15:0])
	);
	
	control_codes control_codes(
		.LD_BEN(LD_BEN), .Clk(Clk), .Reset(Reset), .LD_CC(LD_CC),
		.bus_in(bus_out[15:0]), .ir_in(IR[11:9]),
		.N(N), .Z(Z), .P(P), .BEN(BEN)	
	);
	
	register pc_register (
		.*,
		.Clk(Clk),
		.Load(LD_PC),
		.in(pcmux_out),
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
