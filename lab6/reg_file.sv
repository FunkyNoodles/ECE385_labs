module reg_file(
	input logic [15:0] bus_in,
	input logic [2:0] sr1mux_in, drmux_in, sr2_in,
	input logic ld_reg, Reset, Clk,
	output logic [15:0] sr1_out, sr2_out
);

	logic [15:0] reg_array [8]; //four 16-bits registers
 
	//sr1_out and sr2_out are outputs
	assign sr1_out = reg_array[sr1mux_in];
	assign sr2_out = reg_array[sr2_in];
	 
	always_ff @ (posedge Clk)
	begin
		 if(Reset) begin
			 for(integer i = 0; i < 8; i = i + 1)
			 begin
				 reg_array[i] <= 16'b0;
			 end
		 end
	 
		 else if(ld_reg) begin
				reg_array[drmux_in] <= bus_in;
		 end
	end
	
	
endmodule
