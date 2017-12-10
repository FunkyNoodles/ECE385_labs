module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;
logic Clk = 0;
// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

logic Reset, AES_START, AES_DONE;
logic [127:0] AES_KEY, AES_MSG_ENC, AES_MSG_DEC;

AES aes(.CLK(Clk), .RESET(Reset), .AES_START, .AES_DONE, .AES_KEY, .AES_MSG_ENC, .AES_MSG_DEC);

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
Reset = 1;		// Toggle Rest
AES_KEY     = 128'h000102030405060708090a0b0c0d0e0f;
AES_MSG_ENC = 128'hdaec3055df058e1c39e814ea76f6747e;

#4 Reset = 0;
#2 AES_START = 1;// Specify Din, F, and R

end
//#22 Execute = 1;
//    ans_1a = (8'h33 ^ 8'h55); // Expected result of 1st cycle
//    // Aval is expected to be 8’h33 XOR 8’h55
//    // Bval is expected to be the original 8’h55
//    if (Aval != ans_1a)
//	 ErrorCnt++;
//    if (Bval != 8'h55)
//	 ErrorCnt++;
//    F = 3'b110;	// Change F and R
//    R = 2'b01;
//
//#2 Execute = 0;	// Toggle Execute
//#2 Execute = 1;
//
//#22 Execute = 0;
//    // Aval is expected to stay the same
//    // Bval is expected to be the answer of 1st cycle XNOR 8’h55
//    if (Aval != ans_1a)	
//	 ErrorCnt++;
//    ans_2b = ~(ans_1a ^ 8'h55); // Expected result of 2nd  cycle
//    if (Bval != ans_2b)
//	 ErrorCnt++;
//    R = 2'b11;
//#2 Execute = 1;
//
//// Aval and Bval are expected to swap
//#22 if (Aval != ans_2b)
//	 ErrorCnt++;
//    if (Bval != ans_1a)
//	 ErrorCnt++;
//
//
//if (ErrorCnt == 0)
//	$display("Success!");  // Command line output in ModelSim
//else
//	$display("%d error(s) detected. Try again!", ErrorCnt);
//end
endmodule