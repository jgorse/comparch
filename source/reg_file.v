module reg_file(
input [4:0] readReg1, readReg2, writeReg,
input [31:0] writeData,
input regWrite, clk,
output reg [31:0] readData1, readData2
);

reg signed[31:0] regFile [31:0];
integer i;

//initialize reg to all 0s
initial begin
	for(i=0; i<32; i = i+1)
	begin
		regFile[i] = 0;
	end
end
always@(readReg1 or readReg2) begin
	 readData1 <= regFile[readReg1];
	 readData2 <= regFile[readReg2];
end

always@(negedge clk) begin
	if(regWrite)
		regFile[writeReg] <= writeData;
end

endmodule
