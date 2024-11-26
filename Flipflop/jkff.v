// JK flip-flop using D flip-flop and gates (Single File)

// D Flip-Flop Module
module DFF (output reg Q, input D, Clk, rst);
    always @(posedge Clk or negedge rst)
        if (!rst) 
            Q <= 1'b0; // Reset Q to 0 when rst is low
        else 
            Q <= D;    // Store D in Q on the rising edge of Clk
endmodule


// JK Flip-Flop Module
module JKFF (output Q, input J, K, Clk, rst);
    wire JK;
    assign JK = (J & ~Q) | (~K & Q); // JK logic
    // Instantiate D flip-flop
    DFF JK1 (Q, JK, Clk, rst);
endmodule


// Testbench for JK Flip-Flop
module t_JKFF;
    wire t_Q;
    reg t_J, t_K, t_Clk, t_rst;
    // Instantiate JK flip-flop
    JKFF JK (t_Q, t_J, t_K, t_Clk, t_rst);
    initial begin
        $dumpfile("jk.vcd");
        $dumpvars(0, t_JKFF);
    end
    initial #110 $finish;
    // Clock signal generation
    initial begin
        t_Clk = 0;
        forever #5 t_Clk = ~t_Clk; // Toggle clock every 5 time units
    end


    initial fork
        t_rst = 0;    // Reset active low at time 0
        #1 t_rst = 1;    // De-assert reset at time 1
        #3 t_rst = 0;    // Assert reset again at time 3
        #4 t_rst = 1;    // De-assert reset at time 4
        #87 t_rst = 0;   // Assert reset at time 87
        #92 t_rst = 1;   // De-assert reset at time 92
        #2 t_J = 0;      // Initialize J and K to 0 at time 2
        #2 t_K = 0;
        #22 t_K = 1;     // Change K to 1 at time 22
        #32 t_J = 1;     // Change J to 1 at time 32
        #32 t_K = 0;
        #42 t_K = 1;     // Change both J and K to 1 at time 42
        #52 t_J = 0;     // Change both J and K to 0 at time 52
        #52 t_K = 0;
        #62 t_J = 1;     // Change both J and K to 1 at time 62
        #62 t_K = 1;
    join
endmodule
