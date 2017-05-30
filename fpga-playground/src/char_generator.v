`timescale 1ns / 1ps
module char_generator(
	input _OE,
   input [7:0] CHAR,
   input [3:0] ROW,
   output [7:0] DATA
   );

reg [7:0] char_rom[4095:0]; // 256 characters with 16 rows
initial begin
	$readmemh("CP437.F16.hex", char_rom);
end

assign DATA = _OE ? 8'b11111111 : char_rom[(CHAR * 16) + ROW];

endmodule
