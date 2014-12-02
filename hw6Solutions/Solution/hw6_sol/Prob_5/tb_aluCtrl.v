`timescale 1ns/1ns

/***
 * The test plan simply demonstrates that outputs for each input
 * in the case statement match what the implementation suggests.
 * Please refer to the implementation to check correctness.
 * The outputs are drawn from the book.
 */

module problem5tb;
  // Outputs
  wire[3:0] operation;
  
  // Inputs
  reg[1:0] aluop;
  reg[5:0] funct;
  
  // UUT
  alu_control test( .aluop(aluop),
                    .funct(funct),
                    .operation(operation)
                  );
  
  initial begin
    // Run right down the chart.
    
    funct = 6'b111111;
    #20
    
    aluop = 2'b00;
    #20
    
    aluop = 2'b01;
    #20
    
    aluop = 2'b10;
    funct = 6'b100000;
    #20
    
    funct = 6'b100010;
    #20
    
    funct = 6'b100100;
    #20
    
    funct = 6'b100101;
    #20
    
    funct = 6'b101010;
    #20
    
    #50 $stop;  
  end
endmodule
