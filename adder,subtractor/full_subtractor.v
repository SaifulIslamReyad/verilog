module full_subtractor(diff, bout, a, b, bin);
  input a, b, bin;
  output diff, bout;
  
  assign diff = a ^ b ^ bin;
  assign bout = (~a & b) | ((~a | b) & bin);
endmodule

module full_subtractor2(diff, borrow_out, a, b, borrow_in);
  input a, b, borrow_in;
  output diff, borrow_out;
  wire diff1, borrow1, borrow2;

  half_subtractor HS1(diff1, borrow1, a, b); // First half subtractor
  half_subtractor HS2(diff, borrow2, diff1, borrow_in); // Second half subtractor
  assign borrow_out = borrow1 | borrow2; // Combine borrows
endmodule




module testbench_full_subtractor;
  reg a, b, bin;
  wire diff, bout;
  full_subtractor FS(diff, bout, a, b, bin);
  
  initial begin
    $dumpfile("full_subtractor.vcd");
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
