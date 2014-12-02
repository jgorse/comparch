`timescale 1ns/1ns

/***
 * The test plan is to execute each operation on some inputs.
 * Expected results are reported inline.
 */

module problem6tb;
  // Inputs
  reg[3:0] operation;
  reg[31:0] data_a;
  reg[31:0] data_b;
  
  // Outputs
  wire[31:0] result;
  wire zero;
  
  // UUT
  alu uut( .aluresult(result),
           .zero(zero),
           .operation(operation),
           .data_a(data_a),
           .data_b(data_b)
          );
          
  initial begin
    operation = '0;
    data_a = '0;
    data_b = '0;
    #20 // Expect ZERO high here!
    
    data_a = 32'hA5A5;
    data_b = 32'h00FF;
    #20 // Expect ZERO to go low and output = 32'h000000A5.
    
    operation = 4'b0001;
    #20 // Expect output = 32'h0000A5FF;
    
    operation = 4'b0010;
    data_a = 7;
    data_b = 35;
    #20 // Expect output = 42;
    
    operation = 4'b0110;
    #20 // Expect output = -21;
    
    operation = 4'b0111;
    #20 // Expect output = 1;
    
    data_a = 42;
    #20 // Expect output = 0 and ZERO = 1.
    
    operation = 4'b1100;
    data_a = 32'hA5A5;
    data_b = 32'h00FF;
    #20 // Expect output = 32'hFFFF5A00
    
    #50 $stop;
  end 
endmodule
