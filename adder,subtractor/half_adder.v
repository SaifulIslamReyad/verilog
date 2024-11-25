module half_adder(s, c, a, b);
    input a, b;
    output s, c;
    xor (s, a, b);
    and (c, a, b);
endmodule

module half_adder2(s,c,a,b);
    input a,b;
    output s,c;
    assign s= a^b;
    assign c= a&b;
endmodule

module half_adder3(s,c,a,b);
input a,b;
output reg s,c;
always @(*)
    begin
    s= a^b;
    c= a&b;
    end
endmodule

module full_adder(s, c, a, b, cin);
  input a, b, cin;
  output s, c;
  wire sum1, carry1, carry2;

  half_adder3 HA1(sum1, carry1, a, b); // First half adder
  half_adder3 HA2(s, carry2, sum1, cin); // Second half adder
  assign c = carry1 | carry2; // Combine carries
endmodule

module testbench;
  reg a, b;
  wire s, c;
  half_adder3 HA(s, c, a, b);

  initial begin
    $dumpfile("reyad.vcd");
    $dumpvars(0, testbench);
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
    $monitor("a = %b, b = %b, sum = %b, carry = %b", a, b, s, c);
  end
endmodule
