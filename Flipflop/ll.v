module final(output A,B, input clk,reset);
    wire PA,NA,PB,NB;
    assign PA = 1;
    assign NA= 0;
    assign PB= ~A;
    assign NB= A;
    PNFF pa (A,PA,NA,clk,reset);
    PNFF pb (B,PB,NB,clk,reset);

endmodule
module DFF (output reg Q, input D, clk, reset);
    always @(posedge reset , negedge clk) begin
        if (!reset) Q<= D;
        else Q<=1'b0;
    end
endmodule
module PNFF (output Q , input P,N,clk,reset);
    wire PN ;
    assign PN= (N & Q) | (P & (~Q));
    DFF FA1 (Q,PN,clk,reset);
endmodule

module t_final;
    reg t_clock, t_reset;
    wire [1:0] state;
    wire FA, FB;

    final P (FA, FB, t_clock, t_reset);
    assign state = {FA, FB};

    initial begin
        $dumpfile("t.vcd");
        $dumpvars(0, t_final);
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