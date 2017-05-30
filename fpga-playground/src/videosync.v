`timescale 1ns / 1ps
module videosync(
    input PIXCLK,
    input [9:0] HV,
    input [7:0] HFP,
    input [7:0] HSP,
    input [7:0] HBP,
    input [9:0] VV,
    input [7:0] VFP,
    input [7:0] VSP,
    input [7:0] VBP,
    output [9:0] XPOS,
	 output HS,
    output [9:0] YPOS,
	 output VS
    );

reg [9:0] xc;
reg [9:0] yc;

wire [9:0] xbs, xss, xse, xbe;
wire [9:0] ybs, yss, yse, ybe;

assign xbs = HV;
assign xss = HV + HFP;
assign xse = HV + HFP + HSP;
assign xbe = HV + HFP + HSP + HBP;

assign ybs = VV;
assign yss = VV + VFP;
assign yse = VV + VFP + VSP;
assign ybe = VV + VFP + VSP + VBP;

assign XPOS = (xc < xbs) ? xc : -1;
assign HS = (xc >= xss) & (xc < xse);

assign YPOS = (yc < ybs) ? yc : -1;
assign VS = (yc >= yss) & (yc < yse);

always @(posedge PIXCLK)
begin
		if (xc+1 == xbe && yc+1 == ybe)
		begin
			xc <= 0;
			yc <= 0;
		end
		else if (xc+1 == xbe)
		begin
			xc <= 0;
			yc <= yc + 1;
		end
		else
		begin
			xc <= xc + 1;
		end
end

endmodule
