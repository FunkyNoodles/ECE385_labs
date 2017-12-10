//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper (	input              	is_dark_square,            // Whether current pixel belongs to ball 
								input             	is_light_square,
								input						is_black_piece,
								input						is_white_piece,
								input	is_selected, 
								input	is_highlighted,
								input 					is_cursor,
								input 	black_wins, white_wins,
								input        [9:0] DrawX, DrawY,       // Current pixel coordinates
								output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
	parameter [6:0] nothing = 0;
	parameter [6:0] black_piece = 1;
	parameter [6:0] white_piece = 2;
	parameter [6:0] dark_square = 3;
	parameter [6:0] light_square = 4;
	parameter [6:0] cursor = 5;
	parameter [6:0] highlighted = 6;
	parameter [6:0] cursor_highlighted = 7;

	parameter [7:0] highlight_offset = 8'h00;
	
	 
	logic [7:0] Red, Green, Blue;
	logic [24:0] data_In;
	logic [5:0] color_decider;
	
	
	// Output colors to VGA
	assign VGA_R = Red;
	assign VGA_G = Green;
	assign VGA_B = Blue;
	 
//	 logic [24:0] dark_square [0:3600];
//	 logic [24:0] light_square [0:3600];
//
//	 initial
//	 begin
//		$readmemh("../../Users/davidnull/Desktop/ECE385_labs/lab8/final_project/dark_square.txt", dark_square);
//		$readmemh("../../Users/davidnull/Desktop/ECE385_labs/lab8/final_project/light_square.txt", light_square);
//	 end
	 
//	 frameRAM frame(.data_In,
//		input [18:0] write_address, read_address,
//		input we, Clk,
//
//		output logic [24:0] data_Out
//);
    
    // Assign color based on is_ball signal
	always_comb
	begin
		if (is_black_piece == 1'b1)
			color_decider = black_piece;
		else if (is_white_piece == 1'b1)
			color_decider = white_piece;
		else if (is_cursor == 1'b1 && is_selected == 1'b0)
			color_decider = cursor;
		else if(is_cursor == 1'b1 && is_selected == 1'b1) 
			color_decider = cursor_highlighted;
		else if (is_highlighted)
			color_decider = highlighted;
		else if (is_dark_square == 1'b1)
			color_decider = dark_square;
		else if (is_light_square == 1'b1)
			color_decider = light_square;
		else 
			color_decider = nothing;
			
		if (color_decider == dark_square)  
		begin
			// dark square
			if (black_wins == 1) begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;
			end else if (white_wins == 1) begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
			end else begin
				Red = 8'h6d;
				Green = 8'h38;
				Blue = 8'h06;
			end
		end
		else if (color_decider == light_square)
		begin 
			//light square
			Red = 8'hd3;
			Green = 8'h9e;
			Blue = 8'h65;
		end
		else if (color_decider == black_piece)
		begin 
			//light square
			Red = 8'h00;
			Green = 8'h00;
			Blue = 8'h00;
		end
		else if (color_decider == white_piece)
		begin 
			//light square
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		end
		else 
		begin
			// Background with nice color gradient
			Red = 8'h00;
			Green = 8'h00;
			Blue = 8'h00;
		end
		
		if (color_decider == cursor) begin
			Red = 8'h00;
			Green = 8'hff;
			Blue = 8'h00;
		end else if (color_decider == cursor_highlighted) begin 
			Red = 8'hff;
			Green = 8'h00;
			Blue = 8'h00;
		end

		if (color_decider == highlighted) begin
			Red = 8'h99;
			Green = 8'h00;
			Blue = 8'h00;
		end
    end 
    
endmodule
