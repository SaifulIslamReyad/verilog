// D Flip-Flop module
module DFF (
    input clk,      // Clock input
    input reset,    // Reset input
    input D,        // D input
    output reg Q    // Output
);
    always @(posedge clk or negedge reset) begin
        if (!reset)
            Q <= 1'b0; // Reset Q to 0
        else
            Q <= D;    // Assign D to Q on clock edge
    end
endmodule

// 3-bit Synchronous Up Counter using D Flip-Flops
module up_counter (
    input clk,       // Clock input
    input reset,     // Reset input
    output [2:0] Q   // 3-bit counter output
);
    wire D2, D1, D0; // D inputs for the flip-flops
    // Logic for D inputs
    assign D0 = ~Q[0];                           // Toggle Q[0] on every clock
    assign D1 = Q[1] ^ Q[0];                     // Toggle Q[1] when Q[0] is 1
    assign D2 = Q[2] ^ (Q[1] & Q[0]);            // Toggle Q[2] when Q[1] and Q[0] are 1
    // Instantiate 3 D Flip-Flops
    DFF dff0 (clk, reset, D0, Q[0]);
    DFF dff1 (clk, reset, D1, Q[1]);
    DFF dff2 (clk, reset, D2, Q[2]);
endmodule


module tb_up_counter;
    reg clk;
    reg reset;
    wire [2:0] Q; // 3-bit output for the up counter

    // Instantiate the up_counter
    up_counter x (clk, reset, Q);

    // Clock generation
    initial begin
        clk = 1'b0;
        repeat (33)  // Toggle clock for 33 cycles
            #5 clk = ~clk;
    end

    // Reset signal generation
    initial begin
        reset = 1'b0;      // Activate Reset
        #10 reset = 1'b1;   // Deactivate Reset after 4 time units
    end

    // VCD file generation
    initial begin
        $dumpfile("up_counter.vcd");  // Specify the VCD file name
        $dumpvars(0, tb_up_counter); // Dump all signals in this module and its hierarchy
    end

    // Monitor and display output
    always @(posedge clk) begin
        $monitor("Time = %0t | Reset = %b | Q[2:0] = %b", $time, reset, Q);
    end

    // End simulation after 170 time units (adjustable as needed)
    initial begin
        #170;
        $finish;
    end
endmodule


