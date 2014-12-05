`define EOF 32'hFFFF_FFFF
`timescale 1ns/1ns
module cpu(
inst_addr,
instr,
data_addr,
data_in,
mem_read,
mem_write,
data_out,
clk
);

output reg [4*8:1] inst_addr;
input      [31:0]  instr;
output reg [4*8:1] data_addr;
output reg [31:0]  data_in;
output reg         mem_read;
output reg         mem_write;
input      [31:0]  data_out;
input              clk;

/***************Declare wires****************/
/*Control unit wires*/
wire RegDST, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, Regwrite_w;
wire [1:0] aluop_w;
reg[5:0] opcode;

/*Register wires*/
wire [31:0] ReadData1, ReadData2;
reg [31:0] WriteData;
reg [4:0] ReadRegister1, ReadRegister2, WriteRegister;
reg RegWrite_r;

/*ALU control wires*/
wire[3:0] operation;
reg[5:0] funct;
reg[1:0] aluop_r;

/*Branch wires*/
wire Zero;
reg [31:0] BranchandZero;

/*ALU wires*/
wire [31:0] aluresult;
reg [31:0] data_a, data_b;
reg[3:0] operation_r;

/*Non-module wires*/
reg [31:0] pcadd4, JumpAddress, Signextend, Branchoffset; 

/***************Declare modules***************/
//control unit (generates the control signals)
controlunit controlunit(
.regdest  (RegDST),
.jump     (Jump),
.branch   (Branch),
.memread  (MemRead),
.memtoreg (MemtoReg),
.aluop    (aluop_w),
.memwrite (MemWrite),
.alusrc   (ALUSrc),
.regwrite (Regwrite_w),
.opcode   (opcode)
);

//Main 32x32 register file
reg_file RegFile(
.clk       (clk),
.readReg1  (ReadRegister1),
.readReg2  (ReadRegister2),
.writeReg  (WriteRegister), 
.writeData (WriteData),
.readData1 (ReadData1), 
.readData2 (ReadData2),
.regWrite  (RegWrite_r)
);

//ALU control module
alu_control ALU_Control(
.aluop     (aluop_r),
.funct     (funct),   
.operation (operation)
);

//ALU module
alu ALU(
.operation (operation_r),
.data_a    (data_a),
.data_b    (data_b),
.zero      (Zero),
.aluresult (aluresult)
);

//Initialize
integer count;
initial begin
count = 0;
inst_addr = 32'h3000;
end

//Every clock cycle, move data to next stage
always @(posedge clk) begin
	//count number of clock cycles
	count = count+1;
	//Print clock cycle count
	$display("Cycle number: %d\n", count);
	
	//Move PC 4 bytes to next instruction
	pcadd4 <= inst_addr + 4; 
	JumpAddress = (pcadd4 & 32'hF0000000) + (instr[25:0] << 2);
	#5
	
	//set OPCode
	opcode = instr[31:26];
	#5
	
	//mux before registers
	WriteRegister = (RegDST) ? instr[15:11] : instr[20:16];
	#5
	
	//Set Registers
	ReadRegister1 = instr[25:21];
	ReadRegister2 = instr[20:16];
	#5
	
	//Sign extend
	Signextend = ( (instr[15] == 1) ? (instr[15:0] + 32'hFFFF0000) : instr[15:0] + 32'h00000000 );
	#5
	
	//save Control unit output
	RegWrite_r = Regwrite_w;
	#5
	
	//ALU control input
	funct = instr[5:0];
	aluop_r = aluop_w;
	#5
	
	//Set ALU inputs
	data_b = ALUSrc ? Signextend : ReadData2;
	data_a = ReadData1;
	operation_r = operation;
	#5
	
	//Set CPU outputs to Dmem
	mem_read = MemRead;
	mem_write = MemWrite;
	data_addr = aluresult;
	data_in = ReadData2;
	#5
	
	//mux after DMEM
	WriteData = MemtoReg ? data_out : aluresult;
	#5
	
	//second PC adder
	Branchoffset = pcadd4 + (Signextend<<2); 
	#5
	
	//mux controlled by branch&zero
	BranchandZero = (Branch & Zero) ? Branchoffset : pcadd4;
	#5
	
	//Mux controlled by Jump
	inst_addr = Jump ? JumpAddress : BranchandZero;
	#5
	
	if(opcode  == 6'b111111)
	begin
		$display("Cycle number: %d\n", count);
		inst_addr = `EOF;
	end
		
	//if(WriteRegister == 13)
	//begin
	//$display("Instruction: %b\n", instr);
	//$display("Regs 13, 12, 11: %h, %h, %h\n", RegFile.regFile[13], RegFile.regFile[12], RegFile.regFile[10]);
	
	//$display("Signextend: %h, pcadd4: %h, Branchoffset: %h\n", Signextend, pcadd4, Branchoffset);
	//$display("ALUSrc: %b, ReadData2: %h\n", ALUSrc, ReadData2);
	//$display("ReadRegister1: %h\n", ReadRegister1);
	//$display("data_a: %h, data_b: %h\n", data_a, data_b);
	//$display("Branch: %b, Zero: %b, BranchandZero: %h, Jump: %h, inst_addr: %h", Branch, Zero, BranchandZero, Jump, inst_addr);
	//end

end

endmodule