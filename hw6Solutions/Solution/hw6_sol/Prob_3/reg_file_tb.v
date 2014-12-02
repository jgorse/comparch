`timescale 1ns/100ps

module test_reg_file;

reg [4:0] readReg1, readReg2, writeReg;
reg [31:0] writeData;
reg regWrite, clk;
wire [31:0] readData1, readData2;
	
reg_file uut(readReg1, readReg2, writeReg, writeData, regWrite, clk, readData1, readData2);

initial begin
regWrite = 0; clk = 0;
#20 writeReg = 5'b00000; regWrite = 1; writeData = 4;
#20 writeReg = 5'b10000; regWrite = 1; writeData = 6;
#10 regWrite = 0;
#20 readReg1 = 5'b00000; readReg2 = 5'b10000;  
end

always #5 clk = ~clk;

endmodule
