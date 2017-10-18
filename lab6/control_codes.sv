module control_codes(
	input logic LD_BEN, Clk, Reset, LD_CC,
	input logic [15:0] bus_in,
	input logic [2:0] ir_in,
	output logic N, Z, P, BEN
);

	always_ff @ (posedge Clk)
		begin
				if(Reset) begin
					BEN <= 1'b0;
					N <= 1'b0;
					Z <= 1'b0;
					P <= 1'b0;
				end
				
				if(LD_BEN) begin
					BEN <= (N&ir_in[2])|(Z&ir_in[1])|(P&ir_in[0]);
				end
					
				if(LD_CC) begin
					N <= bus_in[15];
					Z <= ~(|bus_in[15:0]);
					P <= (|bus_in[15:0])&(~bus_in[15]);	
				end	
		end

endmodule

