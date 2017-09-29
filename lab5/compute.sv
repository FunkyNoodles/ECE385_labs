module compute (input  logic Add, Sub,
                input  logic [7:0] A, S,
                output logic [7:0] A_out,
					 output logic X_out);

	 logic [8:0] Sext_A, Sext_S, Sum_A, twos;
	 logic cout;
	 
	 assign Sext_S = {S[7], S[7:0]};
	 assign Sext_A = {A[7], A[7:0]};
	 assign X_out = Sum_A[8];
	 assign A_out = Sum_A[7:0];
	 
	 ripple_adder A_S_adder (.A(Sext_A[8:0]), .B(Sext_S[8:0]), .Sub(Sub), .Sum(Sum_A[8:0]), .CO(cout));
	 //This is the 1-bit ALU
	 
endmodule
