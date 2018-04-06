module FlappyBird(
    // Global clock (50MHz)
	 input CLOCK_50,
	 // Button control(clr, up and down)
    input [1:0] KEY,
	 // VGA display
    output VGA_HS,
    output VGA_VS,
    output [7:0] VGA_R, VGA_G, VGA_B,
	 output [6:0] HEX2, HEX1, HEX0,
	 output VGA_BLANK_N,
	 output VGA_SYNC_N,
	 output VGA_CLK
    );
	
	wire [9:0] x;
	wire [9:0] y;
	wire clk10;
	wire [9:0] bird_y_pos;
	wire [9:0] tube1_x_pos;
	wire [9:0] tube1_y_pos;
	wire [9:0] tube2_x_pos;
	wire [9:0] tube2_y_pos;
	wire [9:0] tube3_x_pos;
	wire [9:0] tube3_y_pos;
	wire game_end;
	wire [7:0] score;
	wire bright;
	wire vgaclk;
	
	// graphics
	assign VGA_CLK=vgaclk;
	assign VGA_BLANK_N=1'b1;
	assign VGA_SYNC_N=1'b1;
	wire isdisplay;
	wire [9:0] drawX,drawY;
	
	VGA_Controller synchGen(
		.clk(vgaclk),
		.clr(KEY[1]),
		.vga_HS(VGA_HS),
		.vga_VS(VGA_VS),
		.X(drawX),
		.Y(drawY),
		.display(isdisplay)
		);
	
	VGA_Bitgen vga_bitgen(
		.clk(vgaclk),
		.bright(isdisplay),
		.x(drawX),
		.y(drawY),
		.bird_y_pos(bird_y_pos),
	   .tube1_x_pos(tube1_x_pos),
		.tube1_y_pos(tube1_y_pos),
		.tube2_x_pos(tube2_x_pos),
		.tube2_y_pos(tube2_y_pos),
		.tube3_x_pos(tube3_x_pos),
		.tube3_y_pos(tube3_y_pos),
		.game_end(game_end),
		.score(score),
		.red(VGA_R),
		.green(VGA_G),
		.blue(VGA_B)
		);
		
	VGAFrequency vga_clk(
		.clk(CLOCK_50),
		.VGAclk(vgaclk)
		);
	
	SevenSegScoreDisplay seven_seg_score_display(
		.clk(vgaclk),
		.score(score),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2)
		);
	
	SignalFrequency signalfrequency(
		.clk(CLOCK_50),
		.clk10(clk10)
		);
		
	Draw_Bird draw_bird(
		.clk10(clk10),
		.clr(KEY[1]),
		.game_end(game_end),
		.up(~KEY[0]),
		.down(KEY[0]),
		.bird_y_pos(bird_y_pos)
		);
	
	Draw_Tubes draw_tubes(
		.clk10(clk10),
		.clr(KEY[1]),
		.game_end(game_end),
	   .tube1_x_pos(tube1_x_pos),
		.tube1_y_pos(tube1_y_pos),
		.tube2_x_pos(tube2_x_pos),
		.tube2_y_pos(tube2_y_pos),
		.tube3_x_pos(tube3_x_pos),
		.tube3_y_pos(tube3_y_pos),
		.score(score)
		);
	
	Crash_Detect crash_detect(
		.clr(KEY[1]),
		.bird_y_pos(bird_y_pos),
		.tube1_x_pos(tube1_x_pos),
		.tube1_y_pos(tube1_y_pos),
		.tube2_x_pos(tube2_x_pos),
		.tube2_y_pos(tube2_y_pos),
		.tube3_x_pos(tube3_x_pos),
		.tube3_y_pos(tube3_y_pos),
		.game_end(game_end)
		);
	
endmodule