module xab_reg_unit (input  logic Clk, Reset, Ld_A, Ld_B, 
                            Shift_En, x_bit,
							 input  logic [7:0]  DA, 
                      input  logic [7:0]  DB, 
                      output logic M, MA,
							 output logic X_out,
                      output logic [7:0]  A,
                      output logic [7:0]  B);
							 
	logic A_out;

	sync_r0 reg_X (.Clk(Clk), .Reset(Reset), .d(x_bit), .q(X_out));
							 
	reg_8_A   reg_A (.Clk(Clk), .Reset(Reset), .Shift_En(Shift_En), .D(DA), .Shift_In(X_out), .Load(Ld_A), .clear(Ld_B), .Shift_Out(A_out), .Data_Out(A));
	reg_8_B   reg_B (.Clk(Clk), .Reset(Reset), .Shift_En(Shift_En), .D(DB), .Shift_In(A_out), .Load(Ld_B), .Shift_Out(M), .m_ahead(MA), .Data_Out(B));

endmodule
