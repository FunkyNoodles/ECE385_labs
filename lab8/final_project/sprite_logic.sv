module board_sprite(
	input [9:0]   DrawX, DrawY,       // Current pixel coordinates
	output logic  is_dark_square,
	output logic  is_light_square
);

	parameter [9:0] size_pixels=60;
	parameter [9:0] board_size = 480;
	
	always_comb begin
		if ((((DrawX / size_pixels) % 2 ) == 1) && (((DrawY / 60) % 2 ) == 0) && DrawX <  board_size) begin
			is_dark_square = 1'b0;
			is_light_square = 1'b1;
		end
		else if ((((DrawX / size_pixels) % 2 ) == 1) && (((DrawY / 60) % 2 ) == 1) && DrawX <  board_size) begin
			is_dark_square = 1'b1;
			is_light_square = 1'b0;
		end
		else if ((((DrawX / size_pixels) % 2 ) == 0) && (((DrawY / 60) % 2 ) == 0) && DrawX <  board_size) begin
			is_dark_square = 1'b1;
			is_light_square = 1'b0;
		end
		else if ((((DrawX / size_pixels) % 2 ) == 0) && (((DrawY / 60) % 2 ) == 1) && DrawX <  board_size) begin
			is_dark_square = 1'b0;
			is_light_square = 1'b1;
		end
		else begin
			is_dark_square = 1'b0;
			is_light_square = 1'b0;
		end
	end
endmodule

module pieces_sprite(
	input [9:0]   DrawX, DrawY,       // Current pixel coordinates
	input [0:7] black_board_state [8],
	input [0:7] white_board_state [8],
	output logic is_black_piece,
	output logic is_white_piece
);

	parameter [9:0] radius = 20;
	parameter [9:0] piece_center = 30;
	parameter [9:0] square_size = 60;
	parameter [9:0] board_size = 480;
	parameter [9:0] number_of_squares = 8;
	
	int DistX, DistY, Size, SquareX, SquareY;
	assign DistX = (DrawX % square_size) - piece_center;
	assign DistY = (DrawY % square_size) - piece_center;
	assign Size = radius;
	assign SquareX = DrawX / 60;
	assign SquareY = DrawY / 60;

	always_comb begin
		
		if ((DrawX < board_size) && ((DistX*DistX + DistY*DistY) <= (Size * Size)) && (black_board_state[SquareY][SquareX] == 1'b1)) begin
			is_black_piece = 1'b1;
			is_white_piece = 1'b0;
		end
		else if ((DrawX < board_size) && ((DistX*DistX + DistY*DistY) <= (Size * Size)) && (white_board_state[SquareY][SquareX] == 1'b1)) begin
			is_black_piece = 1'b0;
			is_white_piece = 1'b1;
		end
		else begin
			is_black_piece = 1'b0;
			is_white_piece = 1'b0;
		end
	end

endmodule
