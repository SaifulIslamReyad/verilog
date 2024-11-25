// D flip-flop module with asynchronous clear
module dff(
  output reg q,       // Output of the D flip-flop
  input d,            // Data input
  input clk,          // Clock signal
  input clear_n       // Active-low asynchronous clear
);
  always @(posedge clk or negedge clear_n) begin
    if (!clear_n)     // Asynchronous clear
      q <= 1'b0;
    else
      q <= d;         // Store the data input
  end
endmodule

// T flip-flop module using D flip-flop
module t_flipflop_async_clear(
  output q,           // Output of the T flip-flop
  input t,            // T input (toggle)
  input clk,          // Clock signal
  input clear_n       // Active-low asynchronous clear
);
  wire d;             // Internal wire for D input to the D flip-flop

  // Logic to derive D input from T and Q
  assign d = t ^ q;   // XOR: toggles state when T = 1
  
  // Instantiate the D flip-flop
  dff dff_instance(
    .q(q),
    .d(d),
    .clk(clk),
    .clear_n(clear_n)
  );
endmodule
