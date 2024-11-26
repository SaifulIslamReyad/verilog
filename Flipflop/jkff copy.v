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
    // assign JK = (J & ~Q) | (~K & Q); // JK logic
    assign JK = (J & ~Q) | (~K & J) | (Q & (~J) & K); 
    // Instantiate D flip-flop
    DFF JK1 (Q, JK, Clk, rst);
endmodule


module reyad_f;
    reg t_clock, t_reset;   
    wire [1:0] state;      
    wire FA, FB;           

    reyad P (FA, FB, t_clock, t_reset);
    assign state = {FA, FB};

    initial begin
        $dumpfile("reyad.vcd");
        $dumpvars(0, reyad_f);
    end

    initial #150 $finish;

    initial begin
        t_reset = 0;
        #5 t_reset = 1;  
        #5 t_reset = 0; 
        t_clock = 0;
        repeat (28)
            #5 t_clock = ~t_clock; 
    end
endmodule


make the code correct , dont change test bench , replace J with P and K with N