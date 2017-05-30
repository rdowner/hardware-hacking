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

videosync sync(
	.PIXCLK (CLK),
	.HV (10'd640), .HFP (8'd24), .HSP (8'd40), .HBP(8'd128),
	.VV (10'd480), .VFP (8'd9), .VSP (8'd3), .VBP(8'd28),
	.XPOS (x), .HS (HS), .YPOS (y), .VS (VS)
);

assign RED = ((x > 0) & (x < 300) & (y > 0) & (y < 300))?7:0;
assign GREEN = ((x > 200) & (x < 400) & (y > 150) & (y < 350)?7:0);
assign BLUE = ((x > 300) & (x < 600) & (y > 180) & (y < 480))?3:0;


endmodule
