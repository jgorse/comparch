`timescale 1ns/1ns

module testbench();

reg clk;
integer count;
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
count = 0;
end



//printing stuff
always@(posedge clk) begin
    
    // print PC
    $display("PC = %d", cpu.pc.pc_out);
    
    // print Registers
    $display("Registers");
    $display("R0(r0) =%d, R8 (t0) =%d, R16(s0) =%d, R24(t8) =%d", cpu.RegFile.regFile[0], cpu.RegFile.regFile[8] , cpu.RegFile.regFile[16], cpu.RegFile.regFile[24]);
    $display("R1(at) =%d, R9 (t1) =%d, R17(s1) =%d, R25(t9) =%d", cpu.RegFile.regFile[1], cpu.RegFile.regFile[9] , cpu.RegFile.regFile[17], cpu.RegFile.regFile[25]);
    $display("R2(v0) =%d, R10(t2) =%d, R18(s2) =%d, R26(k0) =%d", cpu.RegFile.regFile[2], cpu.RegFile.regFile[10], cpu.RegFile.regFile[18], cpu.RegFile.regFile[26]);
    $display("R3(v1) =%d, R11(t3) =%d, R19(s3) =%d, R27(k1) =%d", cpu.RegFile.regFile[3], cpu.RegFile.regFile[11], cpu.RegFile.regFile[19], cpu.RegFile.regFile[27]);
    $display("R4(a0) =%d, R12(t4) =%d, R20(s4) =%d, R28(gp) =%d", cpu.RegFile.regFile[4], cpu.RegFile.regFile[12], cpu.RegFile.regFile[20], cpu.RegFile.regFile[28]);
    $display("R5(a1) =%d, R13(t5) =%d, R21(s5) =%d, R29(sp) =%d", cpu.RegFile.regFile[5], cpu.RegFile.regFile[13], cpu.RegFile.regFile[21], cpu.RegFile.regFile[29]);
    $display("R6(a2) =%d, R14(t6) =%d, R22(s6) =%d, R30(s8) =%d", cpu.RegFile.regFile[6], cpu.RegFile.regFile[14], cpu.RegFile.regFile[22], cpu.RegFile.regFile[30]);
    $display("R7(a3) =%d, R15(t7) =%d, R23(s7) =%d, R31(ra) =%d", cpu.RegFile.regFile[7], cpu.RegFile.regFile[15], cpu.RegFile.regFile[23], cpu.RegFile.regFile[31]);

    // print Data Memory
    $display("Data Memory: 0x00 =%d", {memory.memory[3] , memory.memory[2] , memory.memory[1] , memory.memory[0] });
    $display("Data Memory: 0x04 =%d", {memory.memory[7] , memory.memory[6] , memory.memory[5] , memory.memory[4] });
    $display("Data Memory: 0x08 =%d", {memory.memory[11], memory.memory[10], memory.memory[9] , memory.memory[8] });
    $display("Data Memory: 0x0c =%d", {memory.memory[15], memory.memory[14], memory.memory[13], memory.memory[12]});
    $display("Data Memory: 0x10 =%d", {memory.memory[19], memory.memory[18], memory.memory[17], memory.memory[16]});
    $display("Data Memory: 0x14 =%d", {memory.memory[23], memory.memory[22], memory.memory[21], memory.memory[20]});
    $display("Data Memory: 0x18 =%d", {memory.memory[27], memory.memory[26], memory.memory[25], memory.memory[24]});
    $display("Data Memory: 0x1c =%d", {memory.memory[31], memory.memory[30], memory.memory[29], memory.memory[28]});
	
    $display("\n");
	$display("count: %d\n", count);
	
    
    count = count + 1;
end


  
endmodule




