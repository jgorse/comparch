`timescale 1ns/1ns

/***
 * In the test plan each case from the implementation is executed.
 * Verified that the outputs match the outputs expressed in the book.
 */

module problem4tb;
  // Test outputs
  wire regdest, jump, branch, memread, memtoreg, memwrite, alusrc, regwrite;
  wire[1:0] aluop;
  
  // Test input
  reg[5:0] opcode;
  
  // UUT
  
  controlunit uut( .regdest(regdest),
               .jump(jump),
               .branch(branch),
               .memread(memread),
               .memtoreg(memtoreg),
               .memwrite(memwrite),
               .alusrc(alusrc),
               .regwrite(regwrite),
               .aluop(aluop),
               .opcode(opcode)
              );
              
  //mux2_1_1b uut ( .x(aluop[0]), .a(opcode[0]), .b(opcode[1]), .s(opcode[2]));
  
  initial begin
    opcode = '0;
    
    #10 opcode = 6'b100011;
    #10 opcode = 6'b101011;
    #10 opcode = 6'b111111;
    #10 opcode = 6'b001001;
    #10 opcode = 6'b001000;
    #10 opcode = 6'b000100;
    #10 opcode = 6'b000010;
    #50 $stop;
  end
  
endmodule
