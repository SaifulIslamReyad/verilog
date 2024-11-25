module half_subtractor(diff, borrow, a, b);
  input a, b;
  output diff, borrow;
  
  assign diff = a ^ b;
  assign borrow = ~a & b;
endmodule

module testbench_half_subtractor;
  reg a, b;
  wire diff, borrow;
  
  half_subtractor HS(diff, borrow, a, b);
  
  initial begin
    $dumpfile("reyad.vcd");
    $dumpvars(0, testbench_half_subtractor);
    
    a = 0; b = 0;
    #10;
    a = 0; b = 1;
    #10;
    a = 1; b = 0;
    #10;
    a = 1; b = 1;
    #10;
    
    $finish;
  end
  
  initial begin
    $monitor("a = %b, b = %b, diff = %b, borrow = %b", a, b, diff, borrow);
  end
endmodule
