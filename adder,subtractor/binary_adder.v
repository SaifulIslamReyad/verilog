module full_adder(sum, carry_out, a, b, carry_in);
  input a, b, carry_in;
  output sum, carry_out;

  assign sum = a ^ b ^ carry_in;
  assign carry_out = (a & b) | (b & carry_in) | (carry_in & a);
endmodule

module binary_adder;
  reg [3:0] A;
  reg [3:0] B;
  reg carry_in;
  wire [3:0] Sum;
  wire [3:0] Carry; // Includes final carry out
  full_adder FA0(Sum[0], Carry[0], A[0], B[0], carry_in);
  full_adder FA1(Sum[1], Carry[1], A[1], B[1], Carry[0]);
  full_adder FA2(Sum[2], Carry[2], A[2], B[2], Carry[1]);
  full_adder FA3(Sum[3], Carry[3], A[3], B[3], Carry[2]);
  initial begin
    $dumpfile("binary_adder.vcd");
    $dumpvars(0, binary_adder);

    A = 4'b1000;  // Binary 8
    B = 4'b1111;  // Binary 15
    carry_in = 1'b0;

    #10;
    $display("A = %b, B = %b, Sum = %b, Carry_out = %b", A, B, Sum, Carry[3]);
    $finish;
  end
endmodule
