module D_flip_flop (output reg Q, input D, CLK, Reset);
    always @(posedge CLK or posedge Reset)
        if (Reset)
            Q <= 1'b0;
        else
            Q <= D;
endmodule

module BCD_Up_Counter (output [3:0] Q, input CLK, Reset);
    wire [3:0] D;
    wire count_to_9;

    // Logic for next state
    assign count_to_9 = (Q == 4'b1010);  // Check if current state is 9
    assign D[0] = ~Q[0];
    assign D[1] = Q[0] ^ Q[1];
    assign D[2] = Q[2] ^ (Q[0] & Q[1]);
    assign D[3] = (Q[3] ^ (Q[0] & Q[1] & Q[2])) & ~count_to_9;

    // D Flip-Flops for storing the state
    D_flip_flop FF0 (Q[0], D[0], CLK, Reset | count_to_9);
    D_flip_flop FF1 (Q[1], D[1], CLK, Reset | count_to_9);
    D_flip_flop FF2 (Q[2], D[2], CLK, Reset | count_to_9);
    D_flip_flop FF3 (Q[3], D[3], CLK, Reset | count_to_9);
endmodule

module t_BCD_Up_Counter;
    reg CLK;
    reg Reset;
    wire [3:0] Q;

    BCD_Up_Counter UUT (Q, CLK, Reset);

    initial begin
        $dumpfile("bcd_up_counter.vcd");
        $dumpvars(0, t_BCD_Up_Counter);

        CLK = 1'b0;
        Reset = 1'b1;      // Reset the counter
        #10 Reset = 1'b0;  // Release reset after 10 time units

        #200 $finish;      // End simulation after 200 time units
    end

    always #5 CLK = ~CLK;  // Clock generation with a period of 10 units

    initial begin
        $monitor("Time = %0t | Counter = %b (%0d)", $time, Q, Q);
    end
endmodule
