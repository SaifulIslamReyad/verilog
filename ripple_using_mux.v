// 3-bit Up Counter
module Lab_Test6_Up(output A3, A2, A1, A0, input CLK, Reset);
    Comp_D_flip_flop F0 (A0, CLK, Reset);    // LSB flip-flop
    Comp_D_flip_flop F1 (A1, A0, Reset);     // Triggered by A0
    Comp_D_flip_flop F2 (A2, A1, Reset);     // Triggered by A1
    Comp_D_flip_flop F3 (A3, A2, Reset);     // Triggered by A2
endmodule

// 3-bit Down Counter
module Lab_Test6_Down(output A3, A2, A1, A0, input CLK, Reset);
    Comp_D_flip_flop F0 (A0, ~CLK, Reset);   // LSB flip-flop with inverted clock
    Comp_D_flip_flop F1 (A1, ~A0, Reset);    // Triggered by ~A0
    Comp_D_flip_flop F2 (A2, ~A1, Reset);    // Triggered by ~A1
    Comp_D_flip_flop F3 (A3, ~A2, Reset);    // Triggered by ~A2
endmodule

// D Flip-Flop Module
module Comp_D_flip_flop (output reg Q, input CLK, Reset);
    always @ (negedge CLK or posedge Reset)
        if (Reset)
            Q <= 1'b0;
        else
            Q <= ~Q;
endmodule

// Multiplexer to choose between Up Counter and Down Counter
module Mux_4bit(output [3:0] Y, input [3:0] Up, Down, input Sel);
    assign Y = Sel ? Up : Down; // If Sel = 1, choose Up; otherwise, choose Down
endmodule

// Testbench
module t_Lab_Test6;
    reg CLK, Reset, MUX;         // Inputs: Clock, Reset, and Multiplexer selector
    wire [3:0] A_Up;             // Up Counter output
    wire [3:0] A_Down;           // Down Counter output
    wire [3:0] A_Final;          // Final Counter output after MUX

    // Instantiate Up Counter
    Lab_Test6_Up U (A_Up[3], A_Up[2], A_Up[1], A_Up[0], CLK, Reset);

    // Instantiate Down Counter
    Lab_Test6_Down D (A_Down[3], A_Down[2], A_Down[1], A_Down[0], CLK, Reset);

    // Instantiate Multiplexer
    Mux_4bit MUX1 (A_Final, A_Up, A_Down, MUX);

    // Generate the waveform dump
    initial begin
        $dumpfile("counter_mux.vcd");
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

    // Multiplexer control signal
    initial begin
        MUX = 1'b1;        // Start with Up Counter
        #60 MUX = 1'b0;    // Switch to Down Counter after 60 time units
        #60 MUX = 1'b1;    // Switch back to Up Counter after another 60 time units
    end

    // Monitor signals
    always @ (posedge CLK)
        $monitor("Time = %0t | MUX = %b | Final Counter = %b", $time, MUX, A_Final);
endmodule
