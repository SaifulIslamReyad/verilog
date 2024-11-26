module using_jk(
    output FA,FB,
    input x_in,clock,reset);
    wire JA,JB,KA,KB;
    assign JA = x_in;
    assign JB = ~FA & x_in;
    assign KA = ~x_in;
    assign KB = ~FA & x_in;
    
    JKFF J_A(FA,JA,KA,clock,reset);
    JKFF J_B(FB,JB,KB,clock,reset);
endmodule

module JKFF (output Q, input J, K, Clk, rst);
 wire JK;
 assign JK = (J & ~Q) | (~K & Q);
 // Instantiate D fl ip-fl op
  DFF JK1 (Q, JK, Clk, rst);
endmodule

module DFF ( output reg Q, input D, Clk, rst);
 always @( posedge Clk, negedge rst)
  if (!rst) Q <= 1'b0; // Same as: if (rst == 0)
 else Q <= D;
endmodule

module usingjk;
    reg t_x_in,t_clock,t_reset;
    wire [1:0] state;
    using_jk p (FA,FB,t_x_in,t_clock,t_reset);
    assign state={FA,FB};

    initial
        begin
            $dumpfile("u.vcd");
            $dumpvars(0,usingjk);
        end
    initial #150 $finish;

    initial
        begin
            t_reset=1;
            repeat(2)
                #5 t_reset = ~t_reset;
        end

    initial
        begin
            t_clock=0;
            repeat(28)
                #5 t_clock = ~t_clock;
        end
    
    initial
        begin
            t_x_in=0;
            #10 t_x_in=1;
            repeat(10)
                #20 t_x_in = ~t_x_in;
        end
endmodule