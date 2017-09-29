module ripple_adder
(
    input   logic[8:0]     A,
    input   logic[8:0]     B,
	 input	logic				Sub,
    output  logic[8:0]     Sum,
    output  logic          CO
);

	logic intera, interb, interc; //wires
	logic [3:0] sext_4_sub;
	assign sext_4_sub = {Sub, Sub, Sub, Sub};

	four_adder fourA (.T(A[3 : 0]), .U(B[3 : 0] ^ sext_4_sub[3:0]), .V(  Sub), .P(Sum[3 : 0]), .cout(intera)); //first block
	four_adder fourB (.T(A[7 : 4]), .U(B[7 : 4] ^ sext_4_sub[3:0]), .V(intera), .P(Sum[7 : 4]), .cout(interb)); //second block
	full_adder fourD (.x(A[    8]), .y(B[    8] ^ Sub), .z(interb), .s(Sum[    8]), .c(	      CO)); //fourth block
	
     
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

