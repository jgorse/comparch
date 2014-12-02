module alu_control(input[1:0] aluop, input[5:0] funct, output reg[3:0] operation );
  // These codes and outputs are taken from figure 4.13, P&H.
  always @ (aluop or funct) begin
    if (aluop == 2'b00)     
      operation = 4'b0010;      // lw, sw, addi, addiu -> add
    else if (aluop == 2'b01)    
      operation = 4'b0110;      // branch equal -> sub
    else if (aluop == 2'b10 && funct == 6'b100000)
      operation = 4'b0010;      // Rtype -> add
    else if (aluop[1] == 1 && funct == 6'b100010)
      operation = 4'b0110;       // Rtype -> sub
    else if (aluop == 2'b10 && funct == 6'b100100)
      operation = 4'b0000;      // Rtype -> AND
    else if (aluop == 2'b10 && funct== 6'b100101)
      operation = 4'b0001;      // Rtype -> OR
    else if (aluop == 2'b10 && funct == 6'b101010)
      operation = 4'b0111;      // Rtype -> set on less than
  end
endmodule