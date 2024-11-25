module d_flipflop_async_clear(output reg q, input d,clk,clear_n);
  always @(posedge clk or negedge clear_n) begin
    if (clear_n==1'b0)   // Clear when clear_n is 0
      q <= 1'b0;
    else            // Normal operation on clock edge
      q <= d;
  end
endmodule


module testbench;
  reg d, clk, clear_n;
  wire q;

  // Instantiate the D Flip-Flop module
  d_flipflop_async_clear uut (
    .q(q),
    .d(d),
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
    $dumpfile("d_flipflop_async_clear.vcd");  // For waveform visualization
    $dumpvars(0, testbench);

    // Initialize inputs
    d = 1;
    clear_n = 1;  // Active-low clear deasserted

    // Apply asynchronous clear
    #3 clear_n = 0;  // Assert clear
    #5 clear_n = 1;  // Deassert clear

    // Test normal D flip-flop behavior
    #10 d = 1;  // Set D to 1
    #10 d = 0;  // Set D to 0
    #10 d = 1;  // Set D to 1

    // Assert clear during operation
    #10 clear_n = 0;  // Assert clear
    #5 clear_n = 1;   // Deassert clear

    // Test normal operation again
    #10 d = 0;
    #10 d = 1;

    $finish;  // End simulation
  end

  // Monitor signals
  initial begin
    $monitor("Time=%0t | clk=%b | d=%b | q=%b | clear_n=%b", 
              $time, clk, d, q, clear_n);
  end
endmodule
