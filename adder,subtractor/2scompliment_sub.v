module full_adder(sum, carry_out, a, b, carry_in);
  input a, b, carry_in;
  output sum, carry_out;
  
  assign sum = a ^ b ^ carry_in;
  assign carry_out = (a & b) | (b & carry_in) | (carry_in & a);
endmodule

module full_subtractor(diff, bout, a, b, bin);
  input a, b, bin;
  output diff, bout;
  
  wire b_comp, sum1, c1, c2;
  
  assign b_comp = ~b;  // 1's complement of b
  
  full_adder FA1(sum1, c1, a, b_comp, 1'b0); // Add a and 1's complement of b
  full_adder FA2(diff, c2, sum1, bin, c1);  // Add bin to the result
  
  assign bout = ~a & (b | bin) | (b & bin);  // Calculate borrow-out
endmodule

module testbench_full_subtractor;
  reg a, b, bin;
  wire diff, bout;
  
  full_subtractor FS(diff, bout, a, b, bin);
  
  initial begin
    $dumpfile("full_subtractor_2s_complement.vcd");
    $dumpvars(0, testbench_full_subtractor);
    
    a = 0; b = 0; bin = 0;
    #10;
    a = 0; b = 1; bin = 0;
    #10;
    a = 1; b = 0; bin = 0;
    #10;
    a = 1; b = 1; bin = 0;
    #10;
    a = 0; b = 0; bin = 1;
    #10;
    a = 0; b = 1; bin = 1;
    #10;
    a = 1; b = 0; bin = 1;
    #10;
    a = 1; b = 1; bin = 1;
    #10;
    
    $finish;
  end
  
  initial begin
    $monitor("a = %b, b = %b, bin = %b, diff = %b, bout = %b", a, b, bin, diff, bout);
  end
endmodule
