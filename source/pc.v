module PC(clk, pc_in, pc_out);
input           clk;
input   [31:0]  pc_in;
output  [31:0]  pc_out;

reg     [31:0]  pc_out;

always @(posedge clk)
begin
    pc_out = pc_in;
end

endmodule