/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);

	logic [2:0] msgControl;
	logic [1:0] invMixColControl;
	logic expandKey;
	logic [3:0] correctKey;
	logic doneBit;
	
	assign AES_DONE = doneBit;
	
	datapath dp(.clk(CLK), .Reset(RESET), .initialMsg(AES_MSG_ENC), .initialKey(AES_KEY), .msg(AES_MSG_DEC),
	.msgControl,.invMixColControl, .expandKey, .correctKey);

	enum logic [6:0] {	Halted,
		ke0, ke1, ke2, ke3, ke4, ke5, ke6, ke7, ke8, ke9, ke10, ke11, ke12, ke13, ke14,
		initMsg,
		ark10,
		isr0, isb0, ark9, imc0_0, imc0_1, imc0_2, imc0_3, simc0, 
		isr1, isb1, ark8, imc1_0, imc1_1, imc1_2, imc1_3, simc1, 
		isr2, isb2, ark7, imc2_0, imc2_1, imc2_2, imc2_3, simc2,
		isr3, isb3, ark6, imc3_0, imc3_1, imc3_2, imc3_3, simc3, 
		isr4, isb4, ark5, imc4_0, imc4_1, imc4_2, imc4_3, simc4, 
		isr5, isb5, ark4, imc5_0, imc5_1, imc5_2, imc5_3, simc5, 
		isr6, isb6, ark3, imc6_0, imc6_1, imc6_2, imc6_3, simc6, 
		isr7, isb7, ark2, imc7_0, imc7_1, imc7_2, imc7_3, simc7, 
		isr8, isb8, ark1, imc8_0, imc8_1, imc8_2, imc8_3, simc8, 
		isr9, isb9, ark0,
		Done
								}   State, Next_state;   // Internal state logic

	always_ff @ (posedge CLK)
		begin
		if (RESET) 
			State <= Halted;
		else 
			State <= Next_state;
		end
	 
	always_comb
	begin
		
		Next_state = State;
		
		unique case (State) 
			Halted : begin
				if (AES_START)
					Next_state = ke0; 
			end
			ke0  : Next_state = ke1; 
			ke1  : Next_state = ke2;
			ke2  : Next_state = ke3; 
			ke3  : Next_state = ke4;
			ke4  : Next_state = ke5; 
			ke5  : Next_state = ke6;
			ke6  : Next_state = ke7; 
			ke7  : Next_state = ke8;
			ke8  : Next_state = ke9; 
			ke9  : Next_state = ke10;
			ke10 : Next_state = ke11; 
			ke11 : Next_state = ke12;
			ke12 : Next_state = ke13; 
			ke13 : Next_state = ke14;
			ke14 : Next_state = initMsg;
			
			initMsg : Next_state = ark10;
			
			ark10 : Next_state = isr0;
			
			isr0 : Next_state = isb0;
			isb0 : Next_state = ark9;
			ark9 : Next_state = imc0_0;
			imc0_0 : Next_state = imc0_1;
			imc0_1 : Next_state = imc0_2;
			imc0_2 : Next_state = imc0_3;
			imc0_3 : Next_state = simc0;
			simc0 : Next_state = isr1;
			
			isr1 : Next_state = isb1;
			isb1 : Next_state = ark8;
			ark8 : Next_state = imc1_0;
			imc1_0 : Next_state = imc1_1;
			imc1_1 : Next_state = imc1_2;
			imc1_2 : Next_state = imc1_3;
			imc1_3 : Next_state = simc1;
			simc1 : Next_state = isr2;
			
			isr2 : Next_state = isb2;
			isb2 : Next_state = ark7;
			ark7 : Next_state = imc2_0;
			imc2_0 : Next_state = imc2_1;
			imc2_1 : Next_state = imc2_2;
			imc2_2 : Next_state = imc2_3;
			imc2_3 : Next_state = simc2;
			simc2 : Next_state = isr3;
			
			isr3 : Next_state = isb3;
			isb3 : Next_state = ark6;
			ark6 : Next_state = imc3_0;
			imc3_0 : Next_state = imc3_1;
			imc3_1 : Next_state = imc3_2;
			imc3_2 : Next_state = imc3_3;
			imc3_3 : Next_state = simc3;
			simc3 : Next_state = isr4;
			
			isr4 : Next_state = isb4;
			isb4 : Next_state = ark5;
			ark5 : Next_state = imc4_0;
			imc4_0 : Next_state = imc4_1;
			imc4_1 : Next_state = imc4_2;
			imc4_2 : Next_state = imc4_3;
			imc4_3 : Next_state = simc4;
			simc4 : Next_state = isr5;
			
			isr5 : Next_state = isb5;
			isb5 : Next_state = ark4;
			ark4 : Next_state = imc5_0;
			imc5_0 : Next_state = imc5_1;
			imc5_1 : Next_state = imc5_2;
			imc5_2 : Next_state = imc5_3;
			imc5_3 : Next_state = simc5;
			simc5 : Next_state = isr6;
			
			isr6 : Next_state = isb6;
			isb6 : Next_state = ark3;
			ark3 : Next_state = imc6_0;
			imc6_0 : Next_state = imc6_1;
			imc6_1 : Next_state = imc6_2;
			imc6_2 : Next_state = imc6_3;
			imc6_3 : Next_state = simc6;
			simc6 : Next_state = isr7;
			
			isr7 : Next_state = isb7;
			isb7 : Next_state = ark2;
			ark2 : Next_state = imc7_0;
			imc7_0 : Next_state = imc7_1;
			imc7_1 : Next_state = imc7_2;
			imc7_2 : Next_state = imc7_3;
			imc7_3 : Next_state = simc7;
			simc7 : Next_state = isr8;
			
			isr8 : Next_state = isb8;
			isb8 : Next_state = ark1;
			ark1 : Next_state = imc8_0;
			imc8_0 : Next_state = imc8_1;
			imc8_1 : Next_state = imc8_2;
			imc8_2 : Next_state = imc8_3;
			imc8_3 : Next_state = simc8;
			simc8 : Next_state = isr9;
			
			isr9 : Next_state = isb9;
			isb9 : Next_state = ark0;
			ark0 : Next_state = Done;
			Done :
				if (AES_START == 0)
					Next_state = Halted; 
			default :  Next_state = Halted;
		endcase
		
		doneBit = 1'b0;
		msgControl = 3'b111;
		invMixColControl = 2'b00;
		expandKey = 1'b0;
		correctKey = 4'b0000;
		
		case (State)
			Halted : ;
			
			Done : doneBit = 1'b1;
			
			ke0  : expandKey = 1'b1; 
			ke1  : expandKey = 1'b1;
			ke2  : expandKey = 1'b1; 
			ke3  : expandKey = 1'b1;
			ke4  : expandKey = 1'b1; 
			ke5  : expandKey = 1'b1;
			ke6  : expandKey = 1'b1;
			ke7  : expandKey = 1'b1;
			ke8  : expandKey = 1'b1;
			ke9  : expandKey = 1'b1;
			ke10 : expandKey = 1'b1;
			ke11 : expandKey = 1'b1;
			ke12 : expandKey = 1'b1;
			ke13 : expandKey = 1'b1;
			ke14 : expandKey = 1'b1;
			
			initMsg : msgControl = 3'b100;
			
			ark10 : 
			begin 
				correctKey = 4'b1010;
				msgControl = 3'b000;
			end
			ark9  : 
			begin 
				correctKey = 4'b1001;
				msgControl = 3'b000;
			end
			ark8  : 
			begin 
				correctKey = 4'b1000;
				msgControl = 3'b000;
			end
			ark7  : 
			begin 
				correctKey = 4'b0111;
				msgControl = 3'b000;
			end
			ark6  : 
			begin 
				correctKey = 4'b0110;
				msgControl = 3'b000;
			end
			ark5  : 
			begin 
				correctKey = 4'b0101;
				msgControl = 3'b000;
			end
			ark4  : 
			begin 
				correctKey = 4'b0100;
				msgControl = 3'b000;
			end
			ark3  : 
			begin 
				correctKey = 4'b0011;
				msgControl = 3'b000;
			end
			ark2  : 
			begin 
				correctKey = 4'b0010;
				msgControl = 3'b000;
			end
			ark1  : 
			begin 
				correctKey = 4'b0001;
				msgControl = 3'b000;
			end
			ark0  : 
			begin 
				correctKey = 4'b0000;
				msgControl = 3'b000;
			end
			
			isr0 : msgControl = 3'b001;
			isr1 : msgControl = 3'b001;
			isr2 : msgControl = 3'b001;
			isr3 : msgControl = 3'b001;
			isr4 : msgControl = 3'b001;
			isr5 : msgControl = 3'b001;
			isr6 : msgControl = 3'b001;
			isr7 : msgControl = 3'b001;
			isr8 : msgControl = 3'b001;
			isr9 : msgControl = 3'b001;
			
			isb0 : msgControl = 3'b011;
			isb1 : msgControl = 3'b011;
			isb2 : msgControl = 3'b011;
			isb3 : msgControl = 3'b011;
			isb4 : msgControl = 3'b011;
			isb5 : msgControl = 3'b011;
			isb6 : msgControl = 3'b011;
			isb7 : msgControl = 3'b011;
			isb8 : msgControl = 3'b011;
			isb9 : msgControl = 3'b011;
			
			imc0_0 : invMixColControl = 2'b00;
			imc1_0 : invMixColControl = 2'b00;
			imc2_0 : invMixColControl = 2'b00;
			imc3_0 : invMixColControl = 2'b00;
			imc4_0 : invMixColControl = 2'b00;
			imc5_0 : invMixColControl = 2'b00;
			imc6_0 : invMixColControl = 2'b00;
			imc7_0 : invMixColControl = 2'b00;
			imc8_0 : invMixColControl = 2'b00;

			imc0_1 : invMixColControl = 2'b01;
			imc1_1 : invMixColControl = 2'b01;
			imc2_1 : invMixColControl = 2'b01;
			imc3_1 : invMixColControl = 2'b01;
			imc4_1 : invMixColControl = 2'b01;
			imc5_1 : invMixColControl = 2'b01;
			imc6_1 : invMixColControl = 2'b01;
			imc7_1 : invMixColControl = 2'b01;
			imc8_1 : invMixColControl = 2'b01;
			
			imc0_2 : invMixColControl = 2'b10;
			imc1_2 : invMixColControl = 2'b10;
			imc2_2 : invMixColControl = 2'b10;
			imc3_2 : invMixColControl = 2'b10;
			imc4_2 : invMixColControl = 2'b10;
			imc5_2 : invMixColControl = 2'b10;
			imc6_2 : invMixColControl = 2'b10;
			imc7_2 : invMixColControl = 2'b10;
			imc8_2 : invMixColControl = 2'b10;
			
			imc0_3 : invMixColControl = 2'b11;
			imc1_3 : invMixColControl = 2'b11;
			imc2_3 : invMixColControl = 2'b11;
			imc3_3 : invMixColControl = 2'b11;
			imc4_3 : invMixColControl = 2'b11;
			imc5_3 : invMixColControl = 2'b11;
			imc6_3 : invMixColControl = 2'b11;
			imc7_3 : invMixColControl = 2'b11;
			imc8_3 : invMixColControl = 2'b11;
			
			simc0 : msgControl = 3'b010;
			simc1 : msgControl = 3'b010;
			simc2 : msgControl = 3'b010;
			simc3 : msgControl = 3'b010;
			simc4 : msgControl = 3'b010;
			simc5 : msgControl = 3'b010;
			simc6 : msgControl = 3'b010;
			simc7 : msgControl = 3'b010;
			simc8 : msgControl = 3'b010;
			
			default : ;
		endcase
	end 

endmodule
