module Lab_Test6_Up(output A3, A2, A1, A0, input CLK, Reset);
    JK_flip_flop F0 (A0, 1'b1, 1'b1, CLK, Reset);   // LSB Flip-Flop
    JK_flip_flop F1 (A1, 1'b1, 1'b1, A0, Reset);    // Triggered by A0
    JK_flip_flop F2 (A2, 1'b1, 1'b1, A1, Reset);    // Triggered by A1
    JK_flip_flop F3 (A3, 1'b1, 1'b1, A2, Reset);    // Triggered by A2
endmodule

// 3-bit Down Counter using JK Flip-Flops
module Lab_Test6_Down(output A3, A2, A1, A0, input CLK, Reset);
    JK_flip_flop F0 (A0, 1'b1, 1'b1, ~CLK, Reset);  // LSB Flip-Flop with inverted clock
    JK_flip_flop F1 (A1, 1'b1, 1'b1, ~A0, Reset);   // Triggered by ~A0
    JK_flip_flop F2 (A2, 1'b1, 1'b1, ~A1, Reset);   // Triggered by ~A1
    JK_flip_flop F3 (A3, 1'b1, 1'b1, ~A2, Reset);   // Triggered by ~A2
endmodule

// JK Flip-Flop Module
module JK_flip_flop(output reg Q, input J, K, CLK, Reset);
    always @(posedge CLK or posedge Reset) begin
        if (Reset)
            Q <= 1'b0;                // Reset the Flip-Flop
        else if (J & ~K)
            Q <= 1'b1;                // Set the Flip-Flop
        else if (~J & K)
            Q <= 1'b0;                // Reset the Flip-Flop
        else if (J & K)
            Q <= ~Q;                  // Toggle the Flip-Flop
    end
endmodule

