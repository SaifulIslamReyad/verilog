// 2:1 Multiplexer
module mux21_if(o, a, b, s);
  output reg o;
  input a, b, s;
  always @(*) begin
    if (s == 1'b0)
      o = a;
    else
      o = b;
  end
endmodule

// 4:1 Multiplexer using 2:1 Multiplexer
module mux41(out, i, s);
  output out;
  input [3:0] i; // 4 input lines
  input [1:0] s; // 2-bit select signal

  wire m0, m1; // Intermediate wires for 2:1 muxes

  // First layer: Combine pairs of inputs
  mux21_if mux0(m0, i[0], i[1], s[0]); // Select between i[0] and i[1]
  mux21_if mux1(m1, i[2], i[3], s[0]); // Select between i[2] and i[3]

  // Final layer: Combine results of first layer
  mux21_if mux2(out, m0, m1, s[1]); // Select between m0 and m1
endmodule
