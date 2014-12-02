module reg_32(
input [31:0] in,
input clk,rst,en,
output reg [31:0] out
);

always@(posedge clk, posedge rst)
begin
	if(rst)
		out <= 0;
	else if(en)
		out <= in;
end

endmodule
		