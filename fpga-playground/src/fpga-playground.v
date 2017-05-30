`timescale 1ns / 1ps
module fpga_playground(
    input CLK,
    output HS,
    output VS,
    output [2:0] RED,
    output [2:0] GREEN,
    output [1:0] BLUE
    );

reg [7:0] char_rom[4095:0]; // 256 characters with 16 rows
initial begin
  $readmemh("CP437.F16.hex", char_rom);
end

//reg [7:0] text_mem[2400:0]; // 640 wide = 80 characters; 480 tall = 30 rows
//reg [7:0] attr_mem[2400:0];

wire [9:0] x;
wire [9:0] y;

videosync sync(
	.PIXCLK (CLK),
	.HV (10'd640), .HFP (8'd24), .HSP (8'd40), .HBP(8'd128),
	.VV (10'd480), .VFP (8'd9), .VSP (8'd3), .VBP(8'd28),
	.XPOS (x), .HS (HS), .YPOS (y), .VS (VS)
);

wire blank;
wire [7:0] text_x;
wire [2:0] text_x_sub;
wire [7:0] text_y;
wire [3:0] text_y_sub;
//wire [9:0] text_n;
wire [7:0] char;
wire [11:0] char_mem_index;
wire [7:0] char_data;
wire char_bit;

assign blank = (x == 10'b1111111111) || (y == 10'b1111111111);
assign text_x = blank ? 8'b11111111 : x >> 3;
assign text_x_sub = blank ? 3'b111 : x % 8;
assign text_y = blank ? 8'b11111111 : y >> 4;
assign text_y_sub = blank ? 4'b1111 : y % 16;
//assign text_n = text_y * 80 + text_x;
assign char = blank ? 8'b11111111 : 64 + text_x + text_y;
assign char_mem_index = blank ? 12'b111111111111 : (char * 16) + text_y_sub;
assign char_data = blank ? 8'b11111111 : char_rom[char_mem_index];
assign char_bit = blank ? 0 : char_data[7-text_x_sub];
assign RED = char_bit ? 3'd7 : 0;
assign GREEN = char_bit ? 3'd7 : 0;
assign BLUE = char_bit ? 2'd3 : 0;

endmodule
