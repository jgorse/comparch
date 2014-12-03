module add(in0, in1, out);
input  [31:0] in0;
input  [31:0] in1;
output [31:0] out;

reg [31:0] out;

always @(in0 or in1) 
begin
	out = in0 + in1;
end
  
endmodule