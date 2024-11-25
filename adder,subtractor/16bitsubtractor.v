module full_subtractor(diff, bout, a, b, bin);
  input a, b, bin;
  output diff, bout;

  assign diff = a ^ b ^ bin;
  assign bout = (~a & b) | ((~a | b) & bin);
endmodule

module binary_subtractor_4bit(Diff, Borrow_out, A, B, Borrow_in);
  input [3:0] A, B;
  input Borrow_in;
  output [3:0] Diff;
  output Borrow_out;
  wire [2:0] Borrow;

  full_subtractor FS0(Diff[0], Borrow[0], A[0], B[0], Borrow_in);
  full_subtractor FS1(Diff[1], Borrow[1], A[1], B[1], Borrow[0]);
  full_subtractor FS2(Diff[2], Borrow[2], A[2], B[2], Borrow[1]);
  full_subtractor FS3(Diff[3], Borrow_out, A[3], B[3], Borrow[2]);
endmodule


module binary_subtractor_16bit;
  reg [15:0] A, B;
  reg Borrow_in;
  wire [15:0] Diff;
  wire [3:0] Borrow_out;

  binary_subtractor_4bit BS0(Diff[3:0], Borrow_out[0], A[3:0], B[3:0], Borrow_in);
  binary_subtractor_4bit BS1(Diff[7:4], Borrow_out[1], A[7:4], B[7:4], Borrow_out[0]);
  binary_subtractor_4bit BS2(Diff[11:8], Borrow_out[2], A[11:8], B[11:8], Borrow_out[1]);
  binary_subtractor_4bit BS3(Diff[15:12], Borrow_out[3], A[15:12], B[15:12], Borrow_out[2]);

  initial begin
    $dumpfile("binary_subtractor_16bit.vcd");
    $dumpvars(0, binary_subtractor_16bit);

    A = 16'b1010101010101010; // Example: 43690 in decimal
    B = 16'b0101010101010101; // Example: 21845 in decimal
    Borrow_in = 1'b0;

    #10;
    $display("A = %b, B = %b, Diff = %b, Borrow_out = %b", A, B, Diff, Borrow_out[3]);
    $finish;
  end
endmodule
