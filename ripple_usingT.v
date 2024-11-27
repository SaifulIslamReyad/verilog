// 3-bit Up Counter using T Flip-Flops
module Lab_Test6_Up(output A3, A2, A1, A0, input CLK, Reset);
    T_flip_flop F0 (A0, 1'b1, CLK, Reset);  // LSB flip-flop, toggle on every clock edge
    T_flip_flop F1 (A1, A0, CLK, Reset);    // Triggered by A0
    T_flip_flop F2 (A2, A1, CLK, Reset);    // Triggered by A1
    T_flip_flop F3 (A3, A2, CLK, Reset);    // Triggered by A2
endmodule

// 3-bit Down Counter using T Flip-Flops
module Lab_Test6_Down(output A3, A2, A1, A0, input CLK, Reset);
    T_flip_flop F0 (A0, 1'b1, ~CLK, Reset); // LSB flip-flop, toggle on every negative clock edge
    T_flip_flop F1 (A1, A0, ~CLK, Reset);    // Triggered by inverted A0
    T_flip_flop F2 (A2, A1, ~CLK, Reset);    // Triggered by inverted A1
    T_flip_flop F3 (A3, A2, ~CLK, Reset);    // Triggered by inverted A2
endmodule

// T Flip-Flop Module
module T_flip_flop (output reg Q, input T, CLK, Reset);
    always @ (posedge CLK or posedge Reset)
        if (Reset)
            Q <= 1'b0;
        else if (T)
            Q <= ~Q; // Toggle when T = 1
endmodule

// Testbench for the counters
module t_Lab_Test6;
    reg CLK, Reset;       // Inputs: Clock, Reset
    wire [3:0] A;         // Outputs for the Up Counter
    wire [3:0] B;         // Outputs for the Down Counter

    // Instantiate Up Counter
    Lab_Test6_Up U (A[3], A[2], A[1], A[0], CLK, Reset);

    // Instantiate Down Counter
    Lab_Test6_Down D (B[3], B[2], B[1], B[0], CLK, Reset);

    // Generate the waveform dump
    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, t_Lab_Test6);
    end

    // Stop simulation after 170 time units
    initial #170 $finish;

    // Generate clock signal
    initial begin
        CLK = 1'b0;
        repeat (33) #5 CLK = ~CLK;
    end

    // Reset signal
    initial begin
        Reset = 1'b1;      // Activate Reset
        #4 Reset = 1'b0;   // Deactivate Reset after 4 time units
    end

    // Monitor output signals
    always @ (posedge CLK)
        $monitor("Time = %0t | Up Counter = %b | Down Counter = %b", $time, A, B);
endmodule
