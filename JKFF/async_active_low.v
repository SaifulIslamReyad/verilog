module jk_flipflop_async_clear(
  output reg q,       // Output of the flip-flop
  input j,            // J input
  input k,            // K input
  input clk,          // Clock signal
  input clear_n       // Active-low asynchronous clear
);
  always @(posedge clk or negedge clear_n) begin
    if (!clear_n)     // Clear when clear_n is 0
      q <= 1'b0;
    else begin
      case ({j, k})
        2'b00: q <= q;        // No change
        2'b01: q <= 1'b0;     // Reset
        2'b10: q <= 1'b1;     // Set
        2'b11: q <= ~q;       // Toggle
      endcase
    end
  end
endmodule



module jk_flipflop_async_clear2(
  output reg q,       // Output of the flip-flop
  input j,            // J input
  input k,            // K input
  input clk,          // Clock signal
  input clear_n       // Active-low asynchronous clear
);
  always @(posedge clk or negedge clear_n) begin
    if (!clear_n)     // Asynchronous clear
      q <= 1'b0;
    else
      q <= (j & ~q) | (~k & q); // Formula for JK flip-flop
  end
endmodule


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

// JK flip-flop module using D flip-flop
module jk_flipflop_async_clear2(
  output q,           // Output of the JK flip-flop
  input j,            // J input
  input k,            // K input
  input clk,          // Clock signal
  input clear_n       // Active-low asynchronous clear
);
  wire d;             // Internal wire for D input to the D flip-flop
  
  // Logic to derive D input from J, K, and Q
  assign d = (j & ~q) | (~k & q);
  
  // Instantiate the D flip-flop
  dff dff_instance(
    .q(q),
    .d(d),
    .clk(clk),
    .clear_n(clear_n)
  );
endmodule







module testbench;
  reg j, k, clk, clear_n;
  wire q;

  // Instantiate the JK Flip-Flop module
  jk_flipflop_async_clear uut (
    .q(q),
    .j(j),
    .k(k),
    .clk(clk),
    .clear_n(clear_n)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // Clock period = 10 units
  end

  // Test cases
  initial begin
    $dumpfile("jk_flipflop_async_clear.vcd");  // For waveform visualization
    $dumpvars(0, testbench);

    // Initialize inputs
    j = 0; k = 0; clear_n = 1;  // Active-low clear deasserted

    // Apply asynchronous clear
    #3 clear_n = 0;  // Assert clear
    #5 clear_n = 1;  // Deassert clear

    // Test normal JK flip-flop behavior
    #10 j = 1; k = 0;  // Set
    #10 j = 0; k = 1;  // Reset
    #10 j = 1; k = 1;  // Toggle
    #10 j = 0; k = 0;  // Hold state

    // Assert clear during operation
    #10 clear_n = 0;  // Assert clear
    #5 clear_n = 1;   // Deassert clear

    // Test again
    #10 j = 1; k = 0;
    #10 j = 1; k = 1;

    $finish;  // End simulation
  end

  // Monitor signals
  initial begin
    $monitor("Time=%0t | clk=%b | j=%b | k=%b | q=%b | clear_n=%b", 
              $time, clk, j, k, q, clear_n);
  end
endmodule
