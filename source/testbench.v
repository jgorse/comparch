`timescale 1ns/1ns
`define EOF 32'hFFFF_FFFF

module testbench();

reg clk;
always #100 clk = ~clk;

wire [4*8:1] inst_addr;
wire [31:0]  instr;
wire [4*8:1] data_addr;
wire [31:0]  data_in;
wire         mem_read;
wire         mem_write;
wire [31:0]  data_out;

//declare memory
Memory memory(
.inst_addr(inst_addr),
.instr(instr),
.data_addr(data_addr),
.data_in(data_in),
.mem_read(mem_read),
.mem_write(mem_write),
.data_out(data_out)
);

//declare cpu
cpu cpu(
.inst_addr(inst_addr),
.instr(instr),
.data_addr(data_addr),
.data_in(data_in),
.mem_read(mem_read),
.mem_write(mem_write),
.data_out(data_out),
.clk(clk)
);


//Initialize stuff
initial begin
clk = 0;
//inst_addr = 32'h00003000;
#2000;
end



//at the end of every clock cycle
always@(negedge clk) begin
	//always print last PC
	$display("PC = %h", inst_addr);
	$display("instr = %h", instr);
	
	//If hlt instruction is reached
    if (inst_addr == `EOF) begin
    
		// print Registers
		$display("R0: 0x%h R1: 0x%h \n", cpu.RegFile.regFile[0], cpu.RegFile.regFile[1]);
		$display("R2: 0x%h R3: 0x%h \n", cpu.RegFile.regFile[2], cpu.RegFile.regFile[3]);
		$display("R4: 0x%h R5: 0x%h \n", cpu.RegFile.regFile[4], cpu.RegFile.regFile[5]);
		$display("R6: 0x%h R7: 0x%h \n", cpu.RegFile.regFile[6], cpu.RegFile.regFile[7]);
		$display("R8: 0x%h R9: 0x%h \n", cpu.RegFile.regFile[8], cpu.RegFile.regFile[9]);
		$display("R10: 0x%h R11: 0x%h \n", cpu.RegFile.regFile[10], cpu.RegFile.regFile[11]);
		$display("R12: 0x%h R13: 0x%h \n", cpu.RegFile.regFile[12], cpu.RegFile.regFile[13]);
		$display("R14: 0x%h R15: 0x%h \n", cpu.RegFile.regFile[14], cpu.RegFile.regFile[15]);
		$display("R16: 0x%h R17: 0x%h \n", cpu.RegFile.regFile[16], cpu.RegFile.regFile[17]);
		$display("R18: 0x%h R19: 0x%h \n", cpu.RegFile.regFile[18], cpu.RegFile.regFile[19]);
		$display("R20: 0x%h R21: 0x%h \n", cpu.RegFile.regFile[20], cpu.RegFile.regFile[21]);
		$display("R22: 0x%h R23: 0x%h \n", cpu.RegFile.regFile[22], cpu.RegFile.regFile[23]);
		$display("R24: 0x%h R25: 0x%h \n", cpu.RegFile.regFile[24], cpu.RegFile.regFile[25]);
		$display("R26: 0x%h R27: 0x%h \n", cpu.RegFile.regFile[26], cpu.RegFile.regFile[27]);
		$display("R28: 0x%h R29: 0x%h \n", cpu.RegFile.regFile[28], cpu.RegFile.regFile[29]);
		$display("R30: 0x%h R31: 0x%h \n", cpu.RegFile.regFile[30], cpu.RegFile.regFile[31]);
		$display("\n");
		
		
		//Stop execution
		$stop;

	end
end

endmodule
