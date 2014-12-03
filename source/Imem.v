module Imem(address, instruction);
input   [31:0]  address;
output  [31:0]  instruction;



endmodule




/////////////////////////////////////////////////////////////////////////////////////////
// Instruction memory is byte-addressable, instructions are word-aligned
// Instruction memory with 256 32-bit words
// Instruction address range: 0x3000
parameter MEM_SIZE=256;
reg     [31:0] memory  [0:MEM_SIZE-1];

assign  instr = memory[addr>>2];