module sign_extend(in, out);
input  [15:0] in;
output [31:0] out;

assign out = ( (in[15] == 1) ? (in + 0xFFFF0000) : in + 0x00000000 );
	
endmodule