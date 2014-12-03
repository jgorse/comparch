module sign_extend(in, out);
input  [15:0] in;
output [31:0] out;

assign out = ( (in[15] == 1) ? (in + 32'hFFFF0000) : in + 32'h00000000 );
	
endmodule