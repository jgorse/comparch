module Imem(address, instruction);
input   [31:0]  address;
output  [31:0]  instruction;

parameter MEM_SIZE=32'h00004000;
reg     [31:0] memory  [0:MEM_SIZE-1];



endmodule







