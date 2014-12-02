module mux2_1(
input s,
input [1:0] in,
output reg out
);

always@(s or in)
	out = in[s];

endmodule