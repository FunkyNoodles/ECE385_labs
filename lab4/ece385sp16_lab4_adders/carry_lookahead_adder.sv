module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  
	  logic inter1, inter2, inter3;
	  
	  four_lookahead_adder four0 (.x(A[3 : 0]), .y(B[3 : 0]), .CIN(     0), .S(Sum[3 : 0]), .COUT(inter1));
     four_lookahead_adder four1 (.x(A[7 : 4]), .y(B[7 : 4]), .CIN(inter1), .S(Sum[7 : 4]), .COUT(inter2));
	  four_lookahead_adder four2 (.x(A[11: 8]), .y(B[11: 8]), .CIN(inter2), .S(Sum[11: 8]), .COUT(inter3));
	  four_lookahead_adder four3 (.x(A[15:12]), .y(B[15:12]), .CIN(inter3), .S(Sum[15:12]), .COUT(    CO));
endmodule


module four_lookahead_adder(
	input logic [3:0] x,
	input logic [3:0] y,
	input logic CIN,
	output logic [3:0] S,
	output logic COUT
);
	logic g0, g1, g2, g3;
	logic p0, p1, p2, p3;
	logic c1, c2, c3;

	full_lookahead_adder FLA0 (.a(x[0]), .b(y[0]), .cin(CIN), .s(S[0]), .g(g0), .p(p0));
	assign c1 = g0 | (CIN & p0);
	full_lookahead_adder FLA1 (.a(x[1]), .b(y[1]), .cin(c1), .s(S[1]), .g(g1), .p(p1));
	assign c2 = g1 | (c1 & p1);
	full_lookahead_adder FLA2 (.a(x[2]), .b(y[2]), .cin(c2), .s(S[2]), .g(g2), .p(p2));
	assign c3 = g2 | (c2 & p2);
	full_lookahead_adder FLA3 (.a(x[3]), .b(y[3]), .cin(c3), .s(S[3]), .g(g3), .p(p3));
	assign COUT = g3 | (c3 & p3);

endmodule

module full_lookahead_adder
(
	input logic a,
	input logic b,
	input logic cin, 
	output logic s,
	output logic g,
	output logic p
);

assign s = a^b^cin;
assign g = a&b;
assign p = a^b;


endmodule
