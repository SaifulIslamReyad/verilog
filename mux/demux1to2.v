module demux1to2__(o0, o1, i, s);
  output o0, o1;
  input i, s;

  assign o0 = i & ~s; // Output 0 is active when `s` is 0
  assign o1 = i & s;  // Output 1 is active when `s` is 1
endmodule


module testbench;
  reg i, s;          // Inputs
  wire o0, o1;       // Outputs

  // Instantiate the 1-to-2 Demux module
  demux1to2__ x(o0, o1, i, s);

  // Generate test cases
  initial begin
    $dumpfile("demux1to2.vcd");    // Output waveform file
    $dumpvars(0, testbench);       // Capture all signals in the testbench

    // Test case 1: i=0, s=0
    i = 0; s = 0; #10;
    // Test case 2: i=0, s=1
    i = 0; s = 1; #10;
    // Test case 3: i=1, s=0
    i = 1; s = 0; #10;

    // Test case 4: i=1, s=1
    i = 1; s = 1; #10;

    $finish;  // End simulation
  end

  // Monitor output signals
  initial begin
    $monitor("Time=%0t | i=%b | s=%b || o0=%b | o1=%b", $time, i, s, o0, o1);
  end
endmodule
