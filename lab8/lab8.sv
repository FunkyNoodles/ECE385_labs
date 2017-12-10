//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
    logic Reset_h, Clk;
    logic [15:0] keycode;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs;
    logic is_selected, is_highlighted;
    logic [1:0] player;
    
    logic is_ball;
    logic [9:0] DrawX, DrawY;
    logic is_dark_square, is_light_square;
    logic is_white_piece, is_black_piece;
    logic [0:7] black_board_state [8];
    logic [0:7] white_board_state [8];
    logic [0:7] highlight_state [8];
    logic [4:0] CursorX, CursorY;
    logic is_cursor;
    logic black_done, white_done;
    logic [4:0] black_num, white_num;
    logic white_wins, black_wins;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),    
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8ish_soc nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w)
    );
  
    //Use PLL to generate the 25MHZ VGA_CLK. Do not modify it.
//     vga_clk vga_clk_instance(
//         .clk_clk(Clk),
//         .reset_reset_n(1'b1),
//         .altpll_0_c0_clk(VGA_CLK),
//         .altpll_0_areset_conduit_export(),    
//         .altpll_0_locked_conduit_export(),
//         .altpll_0_phasedone_conduit_export()
//     );
    always_ff @ (posedge Clk) begin
        if(Reset_h)
            VGA_CLK <= 1'b0;
        else
            VGA_CLK <= ~VGA_CLK;
    end
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance( .Clk(Clk),         // 50 MHz clock
                                                            .Reset(Reset_h),       // Active-high reset signal
                                                            .VGA_HS,      // Horizontal sync pulse.  Active low
                                                            .VGA_VS,      // Vertical sync pulse.  Active low
                                                            .VGA_CLK,     // 25 MHz VGA clock input
                                                            .VGA_BLANK_N, // Blanking interval indicator.  Active low.
                                                            .VGA_SYNC_N,  // Composite Sync signal.  Active low.  We don't use it in this lab,
                                                        // but the video DAC on the DE2 board requires an input for it.
                                                            .DrawX(DrawX[9:0]),       // horizontal coordinate
                                                            .DrawY(DrawY[9:0])
                                                        );
    
    // Which signal should be frame_clk?
//    ball ball_instance( .Clk(Clk), 
//                              .Reset(Reset_h), 
//                        .frame_clk(VGA_VS),          // The clock indicating a new frame (~60Hz)
//                              .DrawX(DrawX[9:0]), .DrawY(DrawY[9:0]),       // Current pixel coordinates
//                              .keycode,
//                              .is_ball(is_ball) 
//                          );

    game_logic gl(
                                .Clk, .Reset(Reset_h), .keycode,
                                .DrawX, .DrawY,
                                .is_cursor(is_cursor),
                                .black_num, .white_num,
                                .white_done, .black_done,
                                .is_selected, .is_highlighted,
                                .highlight_state, .white_board_state, .black_board_state,
                                .player,
                                .CursorX, .CursorY);

    game_state_machine gsm(
                                .Clk, .Reset(Reset_h),
                                .white_board_state, .black_board_state,  
                                .black_num, .white_num, .white_done, .black_done,
                                .player, .white_wins, .black_wins
    );
    
     
    board_sprite bs(
                                .DrawX, .DrawY,       // Current pixel coordinates
                                .is_dark_square,
                                .is_light_square);
                                
    pieces_sprite ps(
                                .DrawX, .DrawY,       // Current pixel coordinates
                                .black_board_state,
                                .white_board_state,
                                .is_black_piece,
                                .is_white_piece);
                                
     
    color_mapper color_instance(.is_dark_square, .is_light_square, 
                                .is_black_piece, .is_white_piece,
                                .is_cursor,
                                .is_selected, .is_highlighted,
                                .white_wins, .black_wins,
                       .DrawX(DrawX[9:0]), .DrawY(DrawY[9:0]),       // Current pixel coordinates
                       .VGA_R, .VGA_G, .VGA_B);

//frame_buffer frame_buf(.Reset(Reset_h), .Clk,
//                            .DrawX(DrawX[9:0]), .DrawY(DrawY[9:0]),       // Current pixel coordinates
//                            .VGA_R, .VGA_G, .VGA_B // VGA RGB output
//                            );
    
    // Display keycode on hex display
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);
    
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
