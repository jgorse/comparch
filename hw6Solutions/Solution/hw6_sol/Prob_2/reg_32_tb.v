`timescale 1ns/100ps

module reg_32_tb;

reg en,clk,rst;
reg [31:0] in;
wire [31:0] out;
	
reg_32 uut(in,clk,rst,en,out);

initial begin
	clk = 0; en = 0; rst = 1; in = 32'b00000000000000000000000000001010;
	#25 rst = 0;
	#20 en = 1;
end

always #10 clk = ~clk;

endmodule
