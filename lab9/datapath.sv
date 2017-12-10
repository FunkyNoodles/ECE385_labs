module datapath(
	input logic clk,
	input logic Reset,
	input logic [127:0] initialMsg,
	input logic [127:0] initialKey,
	output logic [127:0] msg,
	input logic [2:0] msgControl,
	input logic [1:0] invMixColControl,
	input logic expandKey,
	input logic [3:0] correctKey
);

//	logic [127:0] msgReg;
//	logic [1407:0] keyScheduleIn;
//	logic [1407:0] keySchedule;
//	logic [127:0] keyToUse;
//	logic [127:0] invShiftRowsOut, isb, invMixColOut;
//	logic [31:0] invMixColTempIn, invMixColTempOut;
//	
//	assign msg = msgReg;
//	
//	KeyExpansion keyExpansion(.clk(clk), .Cipherkey(initialKey), .KeySchedule(keyScheduleIn));
//	InvShiftRows invShiftRows(.data_in(msgReg), .data_out(invShiftRowsOut));
//	InvMixColumns invMixColumns(.in(invMixColTempIn), .out(invMixColTempOut));
//	
//	InvSubBytes invSubBytes[15:0] (clk, 
//		{msg[7 : 0], msg[15: 8], msg[23:16], msg[31:24], msg[39 :32], msg[47 : 40], msg[55 : 48], msg[63 : 56],
//		 msg[71:64], msg[79:72], msg[87:80], msg[95:88], msg[103:96], msg[111:104], msg[119:112], msg[127:120]}, 
//		{isb[7 : 0], isb[15: 8], isb[23:16], isb[31:24], isb[39 :32], isb[47 : 40], isb[55 : 48], isb[63 : 56],
//		 isb[71:64], isb[79:72], isb[87:80], isb[95:88], isb[103:96], isb[111:104], isb[119:112], isb[127:120]});
//		
//	always_comb
//		begin 
//		unique case (correctKey)
//			4'b1010 : keyToUse = keySchedule[127:0];
//			4'b1001 : keyToUse = keySchedule[255:128];
//			4'b1000 : keyToUse = keySchedule[383:256];
//			4'b0111 : keyToUse = keySchedule[511:384];
//			4'b0110 : keyToUse = keySchedule[639:512];
//			4'b0101 : keyToUse = keySchedule[767:640];
//			4'b0100 : keyToUse = keySchedule[895:768];
//			4'b0011 : keyToUse = keySchedule[1023:896];
//			4'b0010 : keyToUse = keySchedule[1151:1024];
//			4'b0001 : keyToUse = keySchedule[1279:1152];
//			4'b0000 : keyToUse = keySchedule[1407:1280];
//		endcase
//		unique case (invMixColControl)
//			2'b00 : invMixColTempIn = msg[31:0];
//			2'b01 : invMixColTempIn = msg[63:32];
//			2'b10 : invMixColTempIn = msg[95:64];
//			2'b11 : invMixColTempIn = msg[127:96];
//		endcase
//		end
//	
//	always_ff @ (posedge clk) begin:REGISTER_FILE
//	if(Reset)
//		begin
//		msgReg <= 128'b0;
//		keySchedule <= 1408'b0;
//		end
//	else 
//		begin 
//			if(expandKey)
//				keySchedule <= keyScheduleIn;
//			unique case (invMixColControl)
//				2'b00 : invMixColOut[31:0] <= invMixColTempOut;
//				2'b01 : invMixColOut[63:32] <= invMixColTempOut;
//				2'b10 : invMixColOut[95:64] <= invMixColTempOut;
//				2'b11 : invMixColOut[127:96] <= invMixColTempOut;
//			endcase
//			unique case (msgControl)
//				3'b000 : msgReg <= msg ^ keyToUse;
//				3'b001 : msgReg <= invShiftRowsOut;
//				3'b010 : msgReg <= invMixColOut;
//				3'b011 : msgReg <= isb;
//				3'b100 : msgReg <= initialMsg;
//				default : ;
//			endcase
//		end
//	end

endmodule