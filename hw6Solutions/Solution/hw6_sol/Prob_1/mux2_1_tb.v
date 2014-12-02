`timescale 1ns/100ps

module test_mux2_1;

wire out;
reg [1:0] in;
reg s;
	
mux2_1 uut(s,in,out);

initial begin
	in = 2'b01; s = 0;
	#10 s = 1;
	#20 s =0;
end

endmodule
