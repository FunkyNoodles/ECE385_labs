module game_state_machine(
	input logic Reset, Clk, 
	input logic [0:7] white_board_state [8],
	input logic [0:7] black_board_state [8],
	input logic [4:0] black_num, white_num,
	input logic white_done, black_done,
	input logic [15:0]  keycode,
	output logic [1:0] player,
	output logic white_wins, black_wins
);

	parameter [7:0] reset_key = 8'h4c;
	enum logic [6:0] {	Start, w, b, wwin, bwin}   State, Next_state;   // Internal state logic

	always_ff @ (posedge Clk)
		begin
		if (Reset || keycode[7:0] == reset_key) 
			State <= Start;
		else 
			State <= Next_state;
		end
	 
	always_comb
	begin
		
		Next_state = State;
		
		unique case (State) 
			Start : 
				Next_state = w;
			w : begin
				if (white_board_state[7] != 0 || (black_num == 0 && white_num > 0))
					Next_state = wwin;
				else if (black_board_state[0] != 0 || (black_num > 0 && white_num == 0))
					Next_state = bwin;
				else if (white_done == 1'b1)
					Next_state = b;
			end
			b : begin
				if (white_board_state[7] != 0 || (black_num == 0 && white_num > 0))
					Next_state = wwin;
				else if (black_board_state[0] != 0 || (black_num > 0 && white_num == 0))
					Next_state = bwin;
				else if (black_done == 1'b1)
					Next_state = w;
			end
			wwin : begin
				Next_state = wwin;
			end
			bwin : begin
				Next_state = bwin;
			end
			default :  Next_state = Start;
		endcase
		
		player = 2'b00;
		black_wins = 1'b0;
		white_wins = 1'b0;
		
		case (State)
			Start : 
				player = 2'b11;
			w : ;
			b : begin
				player = 2'b01;
			end
			wwin : begin
				white_wins = 1'b1;
				player = 2'b11;
			end
			bwin : begin
				black_wins = 1'b1;
				player = 2'b11;
			end
			default : ;
		endcase
	end 

endmodule
