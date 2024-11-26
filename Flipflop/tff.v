
// D flip-flop with asynchronous t_rst
module DFF (output reg Q, input D, Clk, t_rst);
    always @(posedge Clk or negedge t_rst)
        if (!t_rst) 
            Q <= 1'b0; // Reset Q to 0 when t_rst is low
        else 
            Q <= D;    // Store D in Q on the rising edge of Clk
endmodule

// t_T flip-flop using D flip-flop and gates
module TFF (output Q, input t_T, Clk, t_rst);
    wire DT;               // Intermediate signal for D input
    assign DT = Q ^ t_T;     // XOR for toggle logic
    DFF dff_inst(Q, DT, Clk, t_rst); // Instantiate D flip-flop
endmodule

// Testbench for t_T flip-flop
module t_TFF;
    wire t_Q;                 // Output of TFF
    reg t_T, t_Clk, t_rst;    // Testbench inputs

    // Instantiate the TFF
    TFF uut(t_Q, t_T, t_Clk, t_rst);

    // Dump waveforms for simulation
    initial begin
        $dumpfile("tff.vcd"); // Specify the dump file
        $dumpvars(0, t_TFF);    // Dump all variables in the module
    end

    // Stop simulation after 110 ns
    initial #110 $finish;

    // Generate a clock signal with a period of 10 ns
    initial begin
        t_Clk = 0;
        forever #5 t_Clk = ~t_Clk; // Toggle clock every 5 ns
    end


initial fork
    t_rst = 0;        // Set t_rst to 0 at time 0
    #2 t_rst = 1;     // De-assert reset
    #87 t_rst = 0;    // Assert reset again
    #92 t_rst = 1;    // De-assert reset

    t_T = 0;          // Initialize t_T
    #10 t_T = 1;      // Set t_T to 1
    #30 t_T = 0;      // Toggle t_T
    #60 t_T = 1;      // Toggle t_T again
    #100 t_T = 0;     // Set t_T to 0
join

endmodule
