module encoder4to2(output reg [1:0] y, input [3:0] x);
  always @(*) begin
    case (x)
      4'b0001: y = 2'b00; // Input 0 active
      4'b0010: y = 2'b01; // Input 1 active
      4'b0100: y = 2'b10; // Input 2 active
      4'b1000: y = 2'b11; // Input 3 active
      default: y = 2'bxx; // Undefined for multiple or no inputs
    endcase
  end
endmodule



module testbench;
  reg [3:0] x;        // 4 inputs
  wire [1:0] y;       // 2-bit encoded output

  // Instantiate the encoder module
  encoder4to2 uut (
    .y(y),
    .x(x)
  );

  // Test cases
  initial begin
    $dumpfile("encoder4to2.vcd");  // Waveform file
    $dumpvars(0, testbench);       // Capture all signals

    // Apply test inputs
    x = 4'b0001; #10;  // Test case: Input 0 active
    x = 4'b0010; #10;  // Test case: Input 1 active
    x = 4'b0100; #10;  // Test case: Input 2 active
    x = 4'b1000; #10;  // Test case: Input 3 active
    x = 4'b0000; #10;  // Undefined case: No inputs active
    x = 4'b1010; #10;  // Undefined case: Multiple inputs active

    $finish;  // End simulation
  end

  // Monitor outputs
  initial begin
    $monitor("Time=%0t | x=%b | y=%b", $time, x, y);
  end
endmodule
