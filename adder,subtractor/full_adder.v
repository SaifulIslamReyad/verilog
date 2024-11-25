module full_adder(s,c,a,b,ci);
    input a,b,ci;
    wire m,n,p;
    output s,c;
    xor (s,a,b,ci);
    and (m,a,b);
    xor (n,a,b);
    and (p,ci, n);
    or (c,m,p);
endmodule

module full_adder2(s,c,a,b,ci);
    input a,b,ci;
    output s,c;
    assign s= a^b^ci;
    assign c= (a & b) | (b & ci) | (ci & a);
endmodule

module full_adder3(s,c,a,b,ci);
    input a,b,ci;
    output reg s,c;
    always @(*)
        begin
            s= a^b^ci;
            c= (a & b) | (b & ci) | (ci & a);
        end
endmodule

module testbench;
  reg a, b, ci;
  wire s, c;
  full_adder3 FA(s, c, a, b, ci);

  initial begin
    $dumpfile("reyad.vcd");
    $dumpvars(0, testbench);
    a = 0; b = 0; ci = 0;
    #10;
    a = 0; b = 1; ci = 0;
    #10;
    a = 1; b = 0; ci = 0;
    #10;
    a = 1; b = 1; ci = 0;
    #10;
    a = 0; b = 0; ci = 1;
    #10;
    a = 0; b = 1; ci = 1;
    #10;
    a = 1; b = 0; ci = 1;
    #10;
    a = 1; b = 1; ci = 1;
    #10;
    $finish;
  end

  initial begin
    $monitor("a = %b, b = %b, ci = %b, sum = %b, carry = %b", a, b, ci, s, c);
  end
endmodule