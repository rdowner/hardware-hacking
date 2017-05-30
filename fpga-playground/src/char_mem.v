`timescale 1ns / 1ps
module char_mem(
    input [7:0] X,
    input [7:0] Y,
    output [7:0] CHAR,
    output [7:0] ATTR
    );

//reg [7:0] text_mem[2400:0]; // 640 wide = 80 characters; 480 tall = 30 rows
//reg [7:0] attr_mem[2400:0];

assign CHAR = 64 + X + Y;
assign ATTR = { X[3:0], Y[3:0] };

endmodule
