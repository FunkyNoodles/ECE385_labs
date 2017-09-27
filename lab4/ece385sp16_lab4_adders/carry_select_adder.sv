module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  
	logic intera, interb, interc; //wires

	four_carry_adder fourA (.X(A[3 : 0]), .Y(B[3 : 0]), .CIN(     0), .SUM(Sum[3 : 0]), .COUT(intera)); //first block
	four_carry_adder fourB (.X(A[7 : 4]), .Y(B[7 : 4]), .CIN(intera), .SUM(Sum[7 : 4]), .COUT(interb)); //second block
	four_carry_adder fourC (.X(A[11: 8]), .Y(B[11: 8]), .CIN(interb), .SUM(Sum[11: 8]), .COUT(interc)); //third block
	four_carry_adder fourD (.X(A[15:12]), .Y(B[15:12]), .CIN(interc), .SUM(Sum[15:12]), .COUT(    CO)); //fourth block
   
     
endmodule


module four_carry_adder
(
	input logic[3:0] X,
	input logic[3:0] Y,
	input logic CIN,
	output logic[3:0] SUM,
	output logic COUT
);

	logic inter0, inter1, inter2;
	
	full_adder initial_adder (.x(X[0]), .y(Y[0]), .z(     CIN), .s(  SUM[0]), .c(   inter0));
	full_carry_adder four1   (.a(X[1]), .b(Y[1]), .cin(inter0), .sum(SUM[1]), .cout(inter1));
	full_carry_adder four2   (.a(X[2]), .b(Y[2]), .cin(inter1), .sum(SUM[2]), .cout(inter2));
	full_carry_adder four3   (.a(X[3]), .b(Y[3]), .cin(inter2), .sum(SUM[3]), .cout(  COUT));


endmodule



module full_carry_adder
(
	input logic a,
	input logic b,
	input logic cin,
	output logic sum,
	output logic cout
);

	logic zero_carry, one_carry;
	logic [1:0] ind_sum;

	full_adder fa_zero_0 (.x(a), .y(b), .z(1'b0), .s(ind_sum[0]), .c(zero_carry));
	full_adder fa_one_0  (.x(a), .y(b), .z(1'b1), .s(ind_sum[1]), .c( one_carry));
	
	assign cout = (one_carry&cin) | zero_carry;
	two_one_mux mux1 (.Din(ind_sum[1:0]), .sel(cin), .Dout(sum));

endmodule 

//module full_adder
//(
//	input logic x,
//	input logic y,
//	input logic z,
//	output logic s,
//	output logic c
//);
//
//assign s = x^y^z;
//assign c = (x&y)|(y&z)|(x&z);
//
//endmodule

module two_one_mux
(
	input [1:0] Din,
	input sel,
	output logic Dout
);
	always_comb
	begin
		case (sel)
		1'b0 : Dout = Din[0];
		1'b1 : Dout = Din[1];
		default : Dout = Din[0];
		endcase
	end
endmodule
