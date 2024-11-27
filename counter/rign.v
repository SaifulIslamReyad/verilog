// D Flip-Flop with asynchronous reset
module DFF (output reg Q, input D, Clk, rst);
    always @(posedge Clk or negedge rst)
        if (!rst)
            Q <= 1'b0;  // Reset Q to 0 when rst is low
        else
            Q <= D;    // Store D in Q on the rising edge of Clk
endmodule

// 4-bit Ring Counter using D Flip-Flops (Structural Approach)
module RingCounter(output reg [3:0] Q, input Clk, rst);
    wire Q0, Q1, Q2, Q3;  // Intermediate flip-flop outputs

    // Instantiate the D flip-flops for the ring counter
    DFF DFF0 (.Q(Q0), .D(Q3), .Clk(Clk), .rst(rst));  // Q0 is fed by Q3 (forming the ring)
    DFF DFF1 (.Q(Q1), .D(Q0), .Clk(Clk), .rst(rst));  // Q1 is fed by Q0
    DFF DFF2 (.Q(Q2), .D(Q1), .Clk(Clk), .rst(rst));  // Q2 is fed by Q1
    DFF DFF3 (.Q(Q3), .D(Q2), .Clk(Clk), .rst(rst));  // Q3 is fed by Q2

    // Assign the outputs of the flip-flops to the counter output
    always @(posedge Clk or negedge rst) begin
        if (!rst)
            Q <= 4'b0001;  // Reset the counter to 0001 (only the LSB should be 1 initially)
        else
            Q <= {Q3, Q2, Q1, Q0}; // Concatenate the flip-flop outputs to form the 4-bit output
    end
endmodule

// Testbench for the Ring Counter
module t_RingCounter;
    reg Clk, rst;
    wire [3:0] Q;  // 4-bit output of the ring counter

    // Instantiate the Ring Counter
    RingCounter RC (.Q(Q), .Clk(Clk), .rst(rst));

    // Clock generation
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;  // Toggle clock every 5 time units
    end

    // Reset and observe the behavior
    initial begin
        rst = 1'b1;  // Activate reset
        #5 rst = 1'b0; // Deactivate reset after 5 time units
        #50 $finish;  // Run the simulation for 50 time units
    end

    // Monitor the output at every rising edge of the clock
    always @(posedge Clk) begin
        $monitor("Time = %0t | Ring Counter Output = %b", $time, Q);
    end
endmodule
