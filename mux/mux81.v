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

module mux8to1(out, i, s);
  output out;
  input [7:0] i; // 8 input lines
  input [2:0] s; // 3-bit select signal

  wire m0, m1, m2, m3; // Intermediate wires for 4-to-1 multiplexers
  
  // First layer: Combine pairs of inputs using 2:1 muxes
  mux21_if a(m0, i[0], i[1], s[0]); // Select between i[0] and i[1]
  mux21_if b(m1, i[2], i[3], s[0]); // Select between i[2] and i[3]
  mux21_if c(m2, i[4], i[5], s[0]); // Select between i[4] and i[5]
  mux21_if d(m3, i[6], i[7], s[0]); // Select between i[6] and i[7]

  wire m4, m5; // Intermediate wires for 2nd layer
  
  // Second layer: Combine results of first layer using 2:1 muxes
  mux21_if e(m4, m0, m1, s[1]); // Select between m0 and m1
  mux21_if f(m5, m2, m3, s[1]); // Select between m2 and m3

  // Final layer: Combine results of second layer to get the output
  mux21_if g(out, m4, m5, s[2]); // Select between m4 and m5
endmodule
