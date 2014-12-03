module cpu(
inst_addr,
instr,
data_addr,
data_in,
mem_read,
mem_write,
data_out
clk
);

output [4*8:1] inst_addr;
input  [31:0]  instr;
output [4*8:1] data_addr;
output [31:0]  data_in;
output         mem_read;
output         mem_write;
input  [31:0]  data_out;
input          clk



reg clk;


wire RegDST, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Zero, BranchandZero;
wire [1:0] ALUOp;
wire [3:0] ALU_operation;
wire [4:0] RegDST_mux;
wire [31:0] ALUSrc_mux, Jumpmux, Branch_mux, MemtoReg_mux, Instruction, JumpAddress, PC, PCadd4, ReadData1, ReadData2, SignExtend, SignExtendShifted, PCoffset, ALUResult, MemData;


assign JumpAddress = (PCadd4 << 28) + (Instruction[25:0] << 2) //JumpAddress[31:28] is PCadd4 [31:28]. JumpAddress[27:0] is Instruction[25:0] shifted left 2
assign SignExtendShifted = SignExtend << 2; //acts as the shiftleft2 between Sign_Extend and Add
assign BranchandZero = Branch & Zero;
   
//Program Counter (MODULE NEEDS TO BE IMPLEMENTED******************************************************************************************)
PC PC(
.clk    (clk),
.pc_in  (Jump_mux),
.pc_out (PC)
);


//Adder to add 4 to the program calendar for next instruction
add PCadd4(
.in0 (PC), 
.in1 (4), 
.out (PCadd4) 
);


//control unit (generates the control signals)
controlunit controlunit(
.regdest  (RegDST),
.jump     (Jump),
.branch   (Branch),
.memread  (MemRead),
.memtoreg (MemtoReg),
.aluop    (ALUOp),
.memwrite (MemWrite),
.alusrc   (ALUSrc),
.regwrite (RegWrite),
.opcode   (Instruction[31:26])
);


//mux using RegDst as select line
mux_5bit RegDst_mux(
.in0    (Instruction[20:16]),
.in1    (Instruction[15:11]),
.select (RegDST),
.out    (RegDST_mux)
);


//Main 32x32 register file
reg_file RegFile(
.clk       (clk),
.readReg1  (Instr[25:21]),
.readReg2  (Instr[20:16]),
.writeReg  (RegDST_mux), 
.writeData (MemtoReg_mux),
.readData1 (ReadData1), 
.readData2 (ReadData2),
.RegWrite  (RegWrite)
);


//Sign-extend module
sign_extend Sign_Extend(
.in  (Instruction[15:0]), 
.out (SignExtend)
);


//Adder that adds shifted Sign-Extend with PC+4
add PC_Add_Offset(
.in0 (PCadd4),
.in1 (SignExtendShifted),
.out (PCoffset)
);


//mux using ALUSrc as select line
mux_32bit ALUSrc_mux(
.in0    (ReadData2),
.in1    (SignExtend),
.select (ALUSrc),
.out    (ALUSrc_mux)
);


//ALU control module
alu_control ALU_Control(
.aluop     (ALUOp),
.funct     (Instr[5:0]),   
.operation (ALU_operation)
);


//ALU module
alu ALU(
.operation (ALU_operation),
.data_a    (ReadData1),
.data_b    (ALUSrc_mux),
.zero      (Zero),
.aluresult (ALUResult)
);


//mux using BranchandZero as control line
mux_32bit Branch_mux(
.in0    (PCadd4),
.in1    (PCoffset),
.select (BranchandZero),
.out    (Branch_mux)
);


//mux using Jump as control line
mux_32bit Jump_mux(
.in0    (Branch_mux),
.in1    (JumpAddress),
.select (Jump),
.out    (Jump_mux)
);


//Need DMEM from AJ*****************************************************
Data_Memory Data_Memory(
    .clk        (clk),
    .address    (ALUResult),
    .write_data (ReadData2),
    .MemRead    (MemRead),
    .MemWrite   (MemWrite),
    .ReadData   (Dmem)
);


//mux using MemtoReg as control line
mux_32bit MemtoReg_mux(
.in0    (ALUResult),
.in1    (Dmem),//output of DMEM
.select (MemtoReg),
.out    (MemtoReg_mux)
);


endmodule