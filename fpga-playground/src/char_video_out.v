`timescale 1ns / 1ps
module char_video_out(
    input PIXCLK,
    input [7:0] DATA,
    input [7:0] ATTR,
    input [2:0] PIXEL,
    input BLANK,
    output reg [2:0] RED,
    output reg [2:0] GREEN,
    output reg [1:0] BLUE
    );

reg [7:0] clut [15:0];
initial
begin
	clut[0] = 8'b000_000_00;
	clut[1] = 8'b000_000_10;
	clut[2] = 8'b101_000_00;
	clut[3] = 8'b101_000_10;
	clut[4] = 8'b000_101_00;
	clut[5] = 8'b000_101_10;
	clut[6] = 8'b101_101_00;
	clut[7] = 8'b101_101_10;
	clut[8] = 8'b010_010_01;
	clut[9] = 8'b000_000_11;
	clut[10] = 8'b111_000_00;
	clut[11] = 8'b111_000_11;
	clut[12] = 8'b000_111_00;
	clut[13] = 8'b000_111_11;
	clut[14] = 8'b111_111_00;
	clut[15] = 8'b111_111_11;
end

wire char_bit;
assign char_bit = DATA[7-PIXEL];
wire [3:0] clu;
assign clu = char_bit ? ATTR >> 4 : ATTR & 8'b1111;

always @(posedge PIXCLK)
begin

	if (BLANK)
		begin
			RED <= 0;
			GREEN <= 0;
			BLUE <= 0;
		end
	else
		begin
			RED   <= { clut[clu][7:5] };
			GREEN <= { clut[clu][4:2] };
			BLUE  <= { clut[clu][1:0] };
		end
end

endmodule
