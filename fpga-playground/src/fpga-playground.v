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

char_mem charmem(
	.X (x >> 3), .Y (y >> 4), .CHAR (char), .ATTR (attr)
);
char_generator chargen(
	._OE (blank), .CHAR (char), .ROW (y % 16), .DATA (char_data)
);
char_video_out charout(
	.PIXCLK (CLK), .DATA (char_data), .ATTR (attr), .PIXEL (x % 8), .BLANK (blank),
	.RED (RED), .GREEN (GREEN), .BLUE (BLUE)
);

endmodule
