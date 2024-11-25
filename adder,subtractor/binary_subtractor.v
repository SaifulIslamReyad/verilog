module full_subtractor(diff, bout, a, b, bin);
  input a, b, bin;
  output diff, bout;
  
  assign diff = a ^ b ^ bin;
  assign bout = (~a & b) | ((~a | b) & bin);
endmodule

module binary_subtractor;
reg [3:0]A;
reg [3:0]B;
wire [3:0]Br;
wire [3:0]diff;
reg Bin;

full_subtractor a(diff[0],Br[0],A[0],B[0],Bin);
full_subtractor b(diff[1],Br[1],A[1],B[1],Br[0]);
full_subtractor c(diff[2],Br[2],A[2],B[2],Br[1]);
full_subtractor d(diff[3],Br[3],A[3],B[3],Br[2]);

  initial begin
    $dumpfile("reyad.vcd");
    $dumpvars(0, binary_subtractor);

    A = 4'b1111;  // Binary 15
    B = 4'b0011;  // Binary 3
    Bin = 1'b0;

    #10;
    $display("A = %b, B = %b, diff = %b, borrow_out = %b", A, B, diff, Br[3]);
    $finish;
  end
endmodule