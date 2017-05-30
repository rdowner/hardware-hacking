`timescale 1ns / 1ps
module fpga_playground(
    input CLK,
    output HS,
    output VS,
    output [2:0] RED,
    output [2:0] GREEN,
    output [1:0] BLUE
    );

wire [9:0] x;
wire [9:0] y;
wire blank;
wire [7:0] text_x;
wire [2:0] text_x_sub;
wire [7:0] text_y;
wire [3:0] text_y_sub;
//wire [9:0] text_n;
wire [7:0] char;
wire [7:0] attr;
wire [7:0] char_data;

videosync sync(
	.PIXCLK (CLK),
	.HV (10'd640), .HFP (8'd24), .HSP (8'd40), .HBP(8'd128),
	.VV (10'd480), .VFP (8'd9), .VSP (8'd3), .VBP(8'd28),
	.XPOS (x), .HS (HS), .YPOS (y), .VS (VS)
);

assign blank = (x == 10'b1111111111) || (y == 10'b1111111111);
assign text_x = blank ? 8'b11111111 : x >> 3;
assign text_x_sub = blank ? 3'b111 : x % 8;
assign text_y = blank ? 8'b11111111 : y >> 4;
assign text_y_sub = blank ? 4'b1111 : y % 16;
//assign text_n = text_y * 80 + text_x;
char_mem charmem(
	.X (text_x), .Y (text_y), .CHAR (char), .ATTR (attr)
);
char_generator chargen(
	._OE (blank), .CHAR (char), .ROW (text_y_sub), .DATA (char_data)
);
char_video_out charout(
	.PIXCLK (CLK), .DATA (char_data), .ATTR (attr), .PIXEL (text_x_sub), .BLANK (blank),
	.RED (RED), .GREEN (GREEN), .BLUE (BLUE)
);

endmodule
