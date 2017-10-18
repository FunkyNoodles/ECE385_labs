module alu(
	input logic [15:0] A, B,
	input logic [1:0] aluk,
	output logic [15:0] out
);

always_comb
	begin
		unique case (aluk)
		//add
		2'b00 : out = A[15:0] + B[15:0];
		//and
		2'b01 : out = A[15:0] & B[15:0];
		//not
		2'b10 : out = ~A[15:0];
		//ld str
		2'b11 : out = A[15:0];
		endcase
	end

endmodule
