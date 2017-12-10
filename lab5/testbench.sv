module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;
// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic Clk = 0;
logic Reset, ClearA_LoadB, Run;
logic [7:0] S;
logic X;
logic [6:0] AhexL,
		 AhexU,
		 BhexL,
		 BhexU; 
logic [7:0] A;
logic [7:0] B;


// To store expected results
logic [7:0] ans_1a, ans_2b;
				
// A counter to count the instances where simulation results
// do no match with expected results
integer ErrorCnt = 0;
		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
Multiplier_toplevel mp(.*);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
Reset = 0;		// Toggle Rest
ClearA_LoadB = 1;
Run = 1;
S = 8'b11000101;	// Specify Din, F, and R

#2 Reset = 1;

#2 ClearA_LoadB = 0;	// Toggle LoadA
#2 ClearA_LoadB = 1;
	S = 8'b00000111;

#2 Run = 0;	// Toggle Execute

#30 Run = 1;
#2 ClearA_LoadB = 0;	// Toggle LoadA
#2 ClearA_LoadB = 1;
	S = 8'b11000101;
	
#2 Run = 0;

#30 Run = 1;
#2 ClearA_LoadB = 0;	// Toggle LoadA
#2 ClearA_LoadB = 1;
	S = 8'b11111001;
	
#2 Run = 0;

#30 Run = 1;
	S = 8'b00000111;
#2 ClearA_LoadB = 0;	// Toggle LoadA
#2 ClearA_LoadB = 1;
	S = 8'b00111011;
	
#2 Run = 0;


end
endmodule
