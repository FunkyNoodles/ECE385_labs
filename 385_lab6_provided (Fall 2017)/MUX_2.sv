module MUX_2 (
	input SELECT,
	input [15:0] in1, in2,
	output logic [15:0] out
);

always_comb
	begin
		if(~SELECT)
			out = in1;
		else
			out = in2;
	end

endmodule
