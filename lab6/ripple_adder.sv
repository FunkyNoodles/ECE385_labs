module ripple_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

	logic intera, interb, interc; //wires

	four_adder fourA (.T(A[3 : 0]), .U(B[3 : 0]), .V(     0), .P(Sum[3 : 0]), .cout(intera)); //first block
	four_adder fourB (.T(A[7 : 4]), .U(B[7 : 4]), .V(intera), .P(Sum[7 : 4]), .cout(interb)); //second block
	four_adder fourC (.T(A[11: 8]), .U(B[11: 8]), .V(interb), .P(Sum[11: 8]), .cout(interc)); //third block
	four_adder fourD (.T(A[15:12]), .U(B[15:12]), .V(interc), .P(Sum[15:12]), .cout(    CO)); //fourth block
     
endmodule

module four_adder
(
	input logic [3:0] T, //corresponds to input A, x
	input logic [3:0] U, //corresponds to input B, y
	input logic V, //corresponds to input z (cin)
	output logic [3:0] P, //corresponds to Sum, s
	output logic cout //corresponds to c, CO
);
	logic inter1, inter2, inter3; //wires
	
	full_adder FA0 (.x(T[0]),.y(U[0]),.z(     V),.s(P[0]),.c(inter1)); //first block
	full_adder FA1 (.x(T[1]),.y(U[1]),.z(inter1),.s(P[1]),.c(inter2)); //second block
	full_adder FA2 (.x(T[2]),.y(U[2]),.z(inter2),.s(P[2]),.c(inter3)); //third block
	full_adder FA3 (.x(T[3]),.y(U[3]),.z(inter3),.s(P[3]),.c(  cout)); //fourth block
	
endmodule

module full_adder
(
	input logic x,
	input logic y,
	input logic z,
	output logic s,
	output logic c
);

assign s = x^y^z;
assign c = (x&y)|(y&z)|(x&z);

endmodule