// Ripple Counter Modules

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
    Comp_D_flip_flop F3 (A3, ~A2, Reset);     // Triggered by A2
endmodule

module Comp_D_flip_flop (output reg Q, input CLK, Reset);
    always @ (negedge CLK or posedge Reset)
        if (Reset)
            Q <= 1'b0;
        else
            Q <= ~Q;
endmodule

module t_Lab_Test6;
    reg CLK;
    reg Reset;
    wire [3:0] A; // Outputs for the Up Counter
    wire [3:0] B; // Outputs for the Down Counter

    Lab_Test6_Up U (A[3],A[2], A[1], A[0], CLK, Reset);
    Lab_Test6_Down D (B[3],B[2], B[1], B[0], CLK, Reset);

    initial begin
        $dumpfile("riti.vcd");
        $dumpvars(0, t_Lab_Test6);
    end

    initial #170 $finish;

    initial begin
        CLK = 1'b0;
        repeat (33)
            #5 CLK = ~CLK;
    end

    initial begin
        Reset = 1'b1;      // Activate Reset
        #4 Reset = 1'b0;   // Deactivate Reset after 4 time units
    end

    always @ (posedge CLK)
        $monitor("Time = %0t | Up Counter = %b | Down Counter = %b", $time, A, B);
endmodule
