module demux1to2(o0, o1, i, s);
  output reg o0, o1;
  input i, s;

  always @(*) begin
    if (s == 1'b0) begin
      o0 = i;
      o1 = 0;
    end else begin
      o0 = 0;
      o1 = i;
    end
  end
endmodule

module demux1to2__(o0, o1, i, s);
  output o0, o1;
  input i, s;

  assign o0 = i & ~s; // Output 0 is active when `s` is 0
  assign o1 = i & s;  // Output 1 is active when `s` is 1
endmodule


module demux1to8(out, i, s);
  output [7:0] out;  // 8 output lines
  input i;           // Input signal
  input [2:0] s;     // 3-bit select signal

  wire w0, w1;       // Intermediate wires

  // First layer: Split input using 1-to-2 demultiplexer
  demux1to2 d0(w0, w1, i, s[2]);

  // Second layer: Further split the two intermediate signals
  wire w2, w3, w4, w5;
  demux1to2 d1(w2, w3, w0, s[1]);
  demux1to2 d2(w4, w5, w1, s[1]);

  // Final layer: Split each signal to reach the final 8 outputs
  demux1to2 d3(out[0], out[1], w2, s[0]);
  demux1to2 d4(out[2], out[3], w3, s[0]);
  demux1to2 d5(out[4], out[5], w4, s[0]);
  demux1to2 d6(out[6], out[7], w5, s[0]);
endmodule



module testbench;
  reg i;
  reg [2:0] s;
  wire [7:0] out;

  demux1to8 uut(out, i, s);

  initial begin
    $dumpfile("demux1to8.vcd");
    $dumpvars(0, testbench);
    i = 1; s = 3'b000; #10; // Input to out[0]
    i = 1; s = 3'b001; #10; // Input to out[1]
    i = 1; s = 3'b010; #10; // Input to out[2]
    i = 1; s = 3'b011; #10; // Input to out[3]
    i = 1; s = 3'b100; #10; // Input to out[4]
    i = 1; s = 3'b101; #10; // Input to out[5]
    i = 1; s = 3'b110; #10; // Input to out[6]
    i = 1; s = 3'b111; #10; // Input to out[7]
    $finish;
  end

  initial begin
    $monitor("i = %b, s = %b, out = %b", i, s, out);
  end
endmodule
