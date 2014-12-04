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
wire RegDST, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, Regwrite;
wire [1:0] aluop;
//reg[5:0] opcode;

/*Register wires*/
wire [31:0] ReadData1, ReadData2;
reg [31:0] WriteData;
reg [4:0] ReadRegister1, ReadRegister2, WriteRegister;
  //RegWrite already defined

/*ALU control wires*/
wire[3:0] operation;
reg[5:0] funct;
  //aluop already defined

/*Branch wires*/
wire Zero ;
reg [31:0] BranchandZero;

/*ALU wires*/
wire [31:0] aluresult;
reg [31:0] ALUSrc_mux;
  //operation already defined
  //ReadData1 already defined

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
.aluop    (aluop),
.memwrite (MemWrite),
.alusrc   (ALUSrc),
.regwrite (RegWrite),
.opcode   (instr[31:26])
);

//Main 32x32 register file
reg_file RegFile(
.clk       (clk),
.readReg1  (instr[25:21]),
.readReg2  (instr[20:16]),
.writeReg  (WriteRegister), 
.writeData (WriteData),
.readData1 (ReadData1), 
.readData2 (ReadData2),
.regWrite  (Regwrite)
);

//ALU control module
alu_control ALU_Control(
.aluop     (aluop),
.funct     (funct),   
.operation (operation)
);

//ALU module
alu ALU(
.operation (operation),
.data_a    (ReadData1),
.data_b    (ALUSrc_mux),
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
	
	pcadd4 <= inst_addr + 4; 
	JumpAddress = (pcadd4 & 32'hF0000000) + (instr[25:0] << 2);
	
	
	//mux before registers
	WriteRegister = (RegDST) ? instr[15:11] : instr[20:16];
	
	//Sign extend
	Signextend = ( (instr[15] == 1) ? (instr[15:0] + 32'hFFFF0000) : instr[15:0] + 32'h00000000 );
	
	//ALU control input
	funct = instr[5:0];
	
	//mux between registers and ALU
	ALUSrc_mux = ALUSrc ? Signextend : ReadData2;
	
	//second PC adder
	Branchoffset = pcadd4 + (Signextend<<2); 
	
	//mux controlled by branch&zero
	BranchandZero = (Branch & Zero) ? Branchoffset : pcadd4;
	
	//Mux controlled by Jump
	inst_addr = Jump ? JumpAddress : BranchandZero;
	
	//set CPU outputs
	mem_read = MemRead;
	mem_write = MemWrite;
	data_addr = aluresult;
	data_in = ReadData2;
	
	//mux after DMEM
	WriteData = MemtoReg ? data_out : aluresult;
	
	if(instr[5:0] == 6'b111111)
		inst_addr = `EOF;
		
	

end

endmodule