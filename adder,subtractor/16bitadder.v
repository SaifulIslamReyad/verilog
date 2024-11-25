module full_adder(sum, carry_out, a, b, carry_in);
  input a, b, carry_in;
  output sum, carry_out;

  assign sum = a ^ b ^ carry_in;
  assign carry_out = (a & b) | (b & carry_in) | (carry_in & a);
endmodule

module binary_adder_4bit(Sum, Carry_out, A, B, Carry_in);
  input [3:0] A, B;
  input Carry_in;
  output [3:0] Sum;
  output Carry_out;
  wire [2:0] Carry;

  full_adder FA0(Sum[0], Carry[0], A[0], B[0], Carry_in);
  full_adder FA1(Sum[1], Carry[1], A[1], B[1], Carry[0]);
  full_adder FA2(Sum[2], Carry[2], A[2], B[2], Carry[1]);
  full_adder FA3(Sum[3], Carry_out, A[3], B[3], Carry[2]);
endmodule

module binary_adder_16bit;
  reg [15:0] A, B;
  reg Carry_in;
  wire [15:0] Sum;
  wire [3:0] Carry_out;

  binary_adder_4bit BA0(Sum[3:0], Carry_out[0], A[3:0], B[3:0], Carry_in);
  binary_adder_4bit BA1(Sum[7:4], Carry_out[1], A[7:4], B[7:4], Carry_out[0]);
  binary_adder_4bit BA2(Sum[11:8], Carry_out[2], A[11:8], B[11:8], Carry_out[1]);
  binary_adder_4bit BA3(Sum[15:12], Carry_out[3], A[15:12], B[15:12], Carry_out[2]);

  initial begin
    $dumpfile("binary_adder_16bit.vcd");
    $dumpvars(0, binary_adder_16bit);

    A = 16'b0001001000110100; // Example: 4660 in decimal
    B = 16'b0010001101000101; // Example: 9045 in decimal
    Carry_in = 1'b0;

    #10;
    $display("A = %b, B = %b, Sum = %b, Carry_out = %b", A, B, Sum, Carry_out[3]);
    $finish;
  end
endmodule
