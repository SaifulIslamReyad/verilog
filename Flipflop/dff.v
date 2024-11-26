// Gate-level description of D flip-flop with asynchronous reset
module DFF (output reg Q, input D, Clk, rst);
    always @(posedge Clk or negedge rst)
        if (!rst) 
            Q <= 1'b0; // Reset Q to 0 when rst is low
        else 
            Q <= D;    // Store D in Q on the rising edge of Clk
endmodule

// Testbench for DFF
module t_DFF;
    wire t_Q;           // Output of the D flip-flop
    reg t_D, t_Clk, t_rst; // Testbench signals for input

    // Instantiate the DFF module
    DFF D (t_Q, t_D, t_Clk, t_rst);

    // Dump waveforms for simulation
    initial begin
        $dumpfile("dff.vcd"); // Specify the dump file
        $dumpvars(0, t_DFF);    // Dump all variables in the module
    end

    // Stop simulation after 110 ns
    initial #110 $finish;

    // Generate a clock signal with a period of 10 ns
    initial begin
        t_Clk = 0;
        forever #5 t_Clk = ~t_Clk; // Toggle clock every 5 ns
    end

    // Control signals for testing
    initial fork
        t_rst = 0;           // Start with reset low
        #2 t_rst = 1;        // De-assert reset at 2 ns
        #87 t_rst = 0;       // Assert reset at 87 ns
        #92 t_rst = 1;       // De-assert reset at 92 ns

        #10 t_D = 1;         // Set D to 1 at 10 ns
        #20 t_D = 0;         // Set D to 0 at 20 ns
        #40 t_D = 1;         // Set D to 1 at 40 ns
        #50 t_D = 0;         // Set D to 0 at 50 ns
        #60 t_D = 1;         // Set D to 1 at 60 nsy
        #100 t_D = 0;        // Set D to 0 at 100 ns
    join
endmodule
