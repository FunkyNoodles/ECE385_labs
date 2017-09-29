

//4-bit logic processor top level module
//for use with ECE 385 Fall 2016
//last modified by Zuofu Cheng


//Always use input/output logic types when possible, prevents issues with tools that have strict type enforcement

module Multiplier_toplevel (input logic   Clk,     // Internal
                                Reset,   // Push button 0
                                ClearA_LoadB,   // Push button 2
                                Run, // Push button 3
                  input  logic [7:0]  S,     // input data
						output logic X,
                  output logic [6:0]  AhexL,
                                AhexU,
                                BhexL,
                                BhexU,
						output logic [7:0] A, B);

	 //local logic variables go here
	 logic Reset_SH, ClearA_LoadB_SH, Run_SH;
	 logic Ld_A, Ld_B, Add, Sub, Shift_En;
	 logic [7:0] A_in;
	 logic M, MA, x_in, x_out;
	 
	 assign Ld_A = Add | Sub;
	 assign Ld_B = ~ClearA_LoadB;
	 
	 always_comb
	 begin
		if (Ld_A)
			x_in = x_out;
		else 
			x_in = X;
	 end
	
	 //Instantiation of modules here
	 xab_reg_unit    reg_unit (
                        .Clk(Clk),
                        .Reset(Reset_SH),
                        .Ld_A(Ld_A), //note these are inferred assignments, because of the existence a logic variable of the same name
                        .Ld_B(Ld_B),
                        .Shift_En,
								.x_bit(x_in),
								.DA(A_in[7:0]),
                        .DB(S[7:0]),
								.M(M),
								.MA(MA),
								.X_out(X),
                        .A(A),
                        .B(B));
    compute          compute_unit (
								.Add,
								.Sub,
                        .A(A[7:0]),
                        .S(S[7:0]),
                        .A_out(A_in[7:0]),
                        .X_out(x_out));
	 control          control_unit (
                        .Clk(Clk),
                        .Reset(Reset_SH),
                        .ClearA_LoadB(ClearA_LoadB_SH),
                        .Run(Run_SH),
								.M(M),
								.MA(MA),
                        .Shift_En,
                        .Add,
                        .Sub);
	 HexDriver        HexAL (
                        .In0(A[3:0]),
                        .Out0(AhexL) );
	 HexDriver        HexBL (
                        .In0(B[3:0]),
                        .Out0(BhexL) );
								
	 //When you extend to 8-bits, you will need more HEX drivers to view upper nibble of registers, for now set to 0
	 HexDriver        HexAU (
                        .In0(A[7:4]),
                        .Out0(AhexU) );	
	 HexDriver        HexBU (
                       .In0(B[7:4]),
                        .Out0(BhexU) );
								
	  //Input synchronizers required for asynchronous inputs (in this case, from the switches)
	  //These are array module instantiations
	  //Note: S stands for SYNCHRONIZED, H stands for active HIGH
	  //Note: We can invert the levels inside the port assignments
	  sync button_sync[2:0] (Clk, {~Reset, ~ClearA_LoadB, ~Run}, {Reset_SH, ClearA_LoadB_SH, Run_SH});
	  
endmodule

