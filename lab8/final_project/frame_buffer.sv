module frame_buffer(
	input logic Reset, Clk,
	input        [9:0] DrawX, DrawY,       // Current pixel coordinates
   output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
);

//	logic image_buffer_select;
//	
//	logic [7:0] Red, Green, Blue;
//	// Output colors to VGA
//	assign VGA_R = Red;
//	assign VGA_G = Green;
//	assign VGA_B = Blue;
//	
//	initial begin
//		$readmemh("tetris_I.txt", sprite_table);
//	end
//	
//	
//	always_ff @ (posedge Clk) begin:BUFFER_FILE
//		if(Reset) begin
//			for(int i = 0; i< 307200; i++) begin
//				image_buffer_select <= 1'b0;
//				buffer_zero[i] <= 24'b0;
//				buffer_one[i] <= 24'b0;
//			end
//		end
//		else begin
//			if (image_buffer_select == 1'b0) begin
//				image_buffer_select <= 1'b1;
//				for(int i = 0; i< 400; i++) begin
//					buffer_one[i] <= sprite_table[i];
//				end
//			end
//			else begin
//				image_buffer_select <= 1'b0;
//				for(int i = 0; i< 400; i++) begin
//					buffer_zero[i] <= sprite_table[i];
//				end
//			end
//		end
//	end
//	
//	
//	
//	always_comb
//	begin
//		if(image_buffer_select == 1'b0) begin
//			Red = buffer_zero[DrawY*640 + DrawX][24:17];
//			Green = buffer_zero[DrawY*640 + DrawX][16:9];
//			Blue = buffer_zero[DrawY*640 + DrawX][8:0];
//		end
//		else begin
//			Red = buffer_one[DrawY*640 + DrawX][24:17];
//			Green = buffer_one[DrawY*640 + DrawX][16:9];
//			Blue = buffer_one[DrawY*640 + DrawX][8:0];
//		end
//	end

endmodule
