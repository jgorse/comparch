module reg_file(
input [4:0] readReg1, readReg2, writeReg,
input [31:0] writeData,
input regWrite, clk,
output reg [31:0] readData1, readData2
);

reg [31:0] regFile [31:0];

always@(readReg1 or readReg2) begin
	 readData1 <= regFile[readReg1];
	 readData2 <= regFile[readReg2];
end

always@(posedge clk) begin
	if(regWrite)
		regFile[writeReg] <= writeData;
end

endmodule
