module game_logic(
	input logic Clk, Reset,
	input logic [15:0]  keycode,
	input [9:0]   DrawX, DrawY,
	input [1:0] player, 
	output is_cursor,
	output is_selected,
	output is_highlighted,
	output [4:0] CursorX, CursorY,
	output [4:0] black_num, white_num,
	output black_done, white_done, 
	output logic [0:7] highlight_state [8],
	output logic [0:7] white_board_state [8],
	output logic [0:7] black_board_state[8]
);

	logic [0:7] white_board [8];
	logic [0:7] black_board [8];
	logic [4:0] white_player_num;
	logic [4:0] black_player_num;
	logic whd, bld;

	assign black_num = black_player_num;
	assign white_num = white_player_num;
	assign white_board_state = white_board;
	assign black_board_state = black_board;
	assign white_done = whd;
	assign black_done = bld;


	//**************
	//cursor logic
	//**************

	parameter [7:0] up = 8'h52;
	parameter [7:0] down = 8'h51;
	parameter [7:0] right = 8'h4f;
	parameter [7:0] left = 8'h50;
	parameter [7:0] reset_key = 8'h4c;
	parameter [9:0] square_size = 60;
	parameter [23:0] wait_time = 24'hdfffff;
	parameter [9:0] board_size = 480;

	logic [0:7] pmm [8];
	logic [0:7] bm	[8];


	logic [4:0] x, y;
	assign CursorX = x;
	assign CursorY = y;
	logic [23:0] delay;
	
	initial begin
		x <= 0;
		y <= 0;
		delay <= 0;
		selected <= 1'b0;
		selX <= default_sel;
		selY <= default_sel;
		whd <= 0;
		bld <= 0;
		pmm[0] <= 8'b11000000;
		pmm[1] <= 8'b11100000;
		pmm[2] <= 8'b01110000;
		pmm[3] <= 8'b00111000;
		pmm[4] <= 8'b00011100;
		pmm[5] <= 8'b00001110;
		pmm[6] <= 8'b00000111;
		pmm[7] <= 8'b00000011;
		bm[0] <=  8'b10000000;
		bm[1] <=  8'b01000000;
		bm[2] <=  8'b00100000;
		bm[3] <=  8'b00010000;
		bm[4] <=  8'b00001000;
		bm[5] <=  8'b00000100;
		bm[6] <=  8'b00000010;
		bm[7] <=  8'b00000001;
		white_board[0] <= 8'hff;
		white_board[1] <= 8'hff;
		for (int i = 2; i < 8; i++)
			white_board[i] <= 8'h00;
		for (int i = 0; i < 6; i++)
			black_board[i] <= 8'h00;
		black_board[6] <= 8'hff;
		black_board[7] <= 8'hff;
		black_player_num <= 5'd16;
		white_player_num <= 5'd16;
		for (int i = 0; i < 8; i++) 
			hs[i] <= 8'h00;
	end
	
	always_comb begin
		if(((DrawX / square_size) == x ) && ((DrawY / square_size) == y))
			is_cursor = 1'b1;
		else 
			is_cursor = 1'b0;
		if((hs[(DrawY / square_size)][(DrawX / square_size)] == 1) && (DrawX < board_size))
			highlighted = 1'b1;
		else 
			highlighted = 1'b0;
	end
	
	
	//**************
	//highlight logic
	//**************

	parameter [7:0] enter = 8'h28;
	parameter [4:0] default_sel = 5'b11111;
	parameter [7:0] esc = 8'h29;

	logic [0:7] hs [8];
	logic selected;
	logic [4:0] selX, selY;
	logic [2:0] pos_moves;
	logic highlighted;

	assign highlight_state = hs;
	assign is_selected = selected;
	assign is_highlighted = highlighted;
	
	always_ff @ (posedge Clk) begin
		pmm[0] <= 8'b11000000;
		pmm[1] <= 8'b11100000;
		pmm[2] <= 8'b01110000;
		pmm[3] <= 8'b00111000;
		pmm[4] <= 8'b00011100;
		pmm[5] <= 8'b00001110;
		pmm[6] <= 8'b00000111;
		pmm[7] <= 8'b00000011;
		bm[0] <=  8'b10000000;
		bm[1] <=  8'b01000000;
		bm[2] <=  8'b00100000;
		bm[3] <=  8'b00010000;
		bm[4] <=  8'b00001000;
		bm[5] <=  8'b00000100;
		bm[6] <=  8'b00000010;
		bm[7] <=  8'b00000001;
		//pressing reset
		if (Reset || keycode[7:0] == reset_key) begin 
			x <= 0;
			y <= 0;
			whd <= 0;
			bld <= 0;
			delay <= 0;
			selected <= 1'b0;
			selX <= default_sel;
			selY <= default_sel;
			black_player_num <= 5'd16;
			white_player_num <= 5'd16;
			white_board[0] <= 8'hff;
			white_board[1] <= 8'hff;
			for (int i = 2; i < 8; i++)
				white_board[i] <= 8'h00;
			for (int i = 0; i < 6; i++)
				black_board[i] <= 8'h00;
			black_board[6] <= 8'hff;
			black_board[7] <= 8'hff;
			for (int i = 0; i < 8; i++) 
				hs[i] <= 8'h00;
		end

		if (delay > 0)
			delay <= delay - 1;
		
		unique case(keycode[7:0])
			up : begin
				if (y > 0 && delay == 0) begin
					if (selected == 0) begin
						y <= y - 1; 
					end
					delay <= wait_time;
				end
			end
			down : begin
				if (y < 7 && delay == 0) begin
					if (selected == 0) begin
						y <= y + 1; 
					end
					delay <= wait_time;
				end
			end
			right : begin
				if (x < 7 && delay == 0) begin
					if (selected == 0) begin
						x <= x + 1; 
					end else begin
						if (selX < 7 && x < selX+1) begin
							if (x+1 <= selX+1 && hs[y][x+1] == 1)
								x <= x + 1;
							else if (x+2 == selX+1 && hs[y][x+2] == 1)
								x <= x + 2;
						end else if (selX == 7 && x == selX - 1) begin
							if (hs[y][selX] == 1)
								x <= x + 1;
						end
					end
					delay <= wait_time;
				end
			end
			left : begin
				if (x > 0 && delay == 0) begin
					if (selected == 0) begin
						x <= x - 1; 
					end else begin
						if (selX > 0 && x > selX-1) begin
							if (x-1 >= selX-1 && hs[y][x-1] == 1)
								x <= x - 1;
							else if (x-2 == selX-1 && hs[y][x-2] == 1)
								x <= x - 2;
						end else if (selX == 0 && x == selX + 1) begin
							if (hs[y][selX] == 1)
								x <= x - 1;
						end
					end
					delay <= wait_time;
				end
			end
			enter : begin
				if ((delay ==0) && (selected == 1'b0) && 
				((player == 0 && white_board[y][x] == 1) ||
			 	(player == 1 && black_board[y][x] == 1))) begin
					if (player == 0 && y < 7 && y >= 0) begin
						if ((x == 7) && (((white_board[y+1] & pmm[7]) | (black_board[y+1] & bm[7]))  != pmm[7])) begin
							selected <= 1'b1;
							selX <= x;
							selY <= y;
							y <= y+1;
						end else if ((x == 0) && (((white_board[y+1] & pmm[0]) | (black_board[y+1] & bm[0]))  != pmm[0])) begin
							selected <= 1'b1;
							selX <= x;
							selY <= y;
							y <= y+1;
						end else if (((white_board[y+1] & pmm[x]) | (black_board[y+1] & bm[x])) != pmm[x]) begin
							selected <= 1'b1;
							selX <= x;
							selY <= y;
							y <= y+1;
						end
					end
					else if (player == 1 && y > 0 && y <= 7) begin
						if ((x == 7) && (((black_board[y-1] & pmm[7]) | (white_board[y-1] & bm[7]))  != pmm[7])) begin
							selected <= 1'b1;
							selX <= x;
							selY <= y;
							y <= y-1;
						end else if ((x == 0) && (((black_board[y-1] & pmm[0]) | (white_board[y-1] & bm[0]))  != pmm[0])) begin
							selected <= 1'b1;
							selX <= x;
							selY <= y;
							y <= y-1;
						end else if (((black_board[y-1] & pmm[x]) | (white_board[y-1] & bm[x])) != pmm[x]) begin
							selected <= 1'b1;
							selX <= x;
							selY <= y;
							y <= y-1;
						end
					end
			 	end 
			 	else if ((delay == 0) && (selected == 1'b1)) begin
			 		if (player == 0) begin //white move
						white_board[y][x] <= 1'b1;
						white_board[selY][selX] <= 1'b0;
						whd <= 1;
						bld <= 0;
						if (black_board[y][x] == 1'b1) begin
							black_player_num <= black_player_num - 1;
							black_board[y][x] <= 1'b0;
						end
					end else if (player == 1) begin //black move
						black_board[y][x] <= 1'b1;
						black_board[selY][selX] <= 1'b0;
						whd <= 0;
						bld <= 1;
						if (white_board[y][x] == 1'b1) begin
							white_player_num <= white_player_num - 1;
							white_board[y][x] <= 1'b0;
						end
					end
					selected <= 1'b0;
					x <= selX;
					y <= selY;
					selX <= default_sel;
					selY <= default_sel;
					for (int i = 0; i < 8; i++) 
						hs[i] <= 8'h00;
			 	end
			 	delay <= wait_time;
			end
			esc : 
				if (delay == 0 && selected == 1'b1) begin
					selected <= 1'b0;
					x <= selX;
					y <= selY;
					selX <= default_sel;
					selY <= default_sel;
					for (int i = 0; i < 8; i++) 
						hs[i] <= 8'h00;
					delay <= wait_time;
				end
			default : ;
		endcase
		
		

		//determine highlighted squares
		if (selected == 1'b1) begin
			if (player == 0) begin //white team
				if (selY < 7 && selY >= 0) begin
					if (selX == 7) begin
						hs[selY+1] <= (pmm[7] ^ (white_board[selY+1] & pmm[7]) ^ (black_board[selY+1] & bm[7]));
					end
					else if (selX == 0) begin
						hs[selY+1] <= (pmm[0] ^ (white_board[selY+1] & pmm[0]) ^ (black_board[selY+1] & bm[0]));
					end
					else begin
						hs[selY+1] <= (pmm[selX] ^ (white_board[selY+1] & pmm[selX]) ^ (black_board[selY+1] & bm[selX]));
					end
				end
			end
			else if (player == 1) begin	//black team
				if (selY <= 7 && selY > 0) begin
					if (selX == 7) begin
						hs[selY-1] <= (pmm[7] ^ (black_board[selY-1] & pmm[7]) ^ (white_board[selY-1] & bm[7]));
					end
					else if (selX == 0) begin
						hs[selY-1] <= (pmm[0] ^ (black_board[selY-1] & pmm[0]) ^ (white_board[selY-1] & bm[0]));
					end
					else begin
						hs[selY-1] <= (pmm[selX] ^ (black_board[selY-1] & pmm[selX]) ^ (white_board[selY-1] & bm[selX]));						
					end
				end
			end
			if (hs[y][x] != 1) begin
				if (x == 7 && hs[y][x-1] == 1)
					x <= x - 1;
				else if (x == 0 && hs[y][x+1] == 1)
					x <= x + 1;
				else if (hs[y][x-1] == 1)
					x <= x - 1;
				else if (hs[y][x+1] == 1)
					x <= x + 1;
			end
			hs[selY][selX] = 1'b1;
		end  else begin 
			for (int i = 0; i < 8; i++) 
				hs[i] <= 8'h00;
		end
		
	end
endmodule
