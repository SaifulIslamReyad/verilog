module using_t(
    output FA,FB,
    input x_in,clock,reset);
    wire TA,TB;
    // assign TA = ((FA)&(FB)&(~x_in))|((~FA)&(~FB)&(~x_in));
    // assign TB = ((~FA)&(FB)&(~x_in))|((FA)&(~FB)&(~x_in));
    assign TA= (~FA & x_in) | (FA & (~x_in));
    assign TB= (~FA & x_in);
    
    TFF T_A(FA,TA,clock,reset);
    TFF T_B(FB,TB,clock,reset);
    // DFF K_A(FA,DA,clock,reset);
    // DFF K_B(FB,DB,clock,reset);
endmodule

module TFF (Q, T, Clk, rst);
  output Q;
 input T, Clk, rst;
 wire DT;
  
  assign DT = Q ^ T ; // Continuous assignment
  DFF TF1 (Q, DT, Clk, rst);  // Instantiate the D fl ip-fl op
endmodule

module DFF ( output reg Q, input D, Clk, rst);
 always @( posedge Clk, negedge rst)
  if (!rst) Q <= 1'b0; // Same as: if (rst == 0)
 else Q <= D;
endmodule

module usingt;
    reg t_x_in,t_clock,t_reset;
    wire [1:0] state;

    using_t p (FA,FB,t_x_in,t_clock,t_reset);
    assign state={FA,FB};

    initial
        begin
            $dumpfile("using_t.vcd");
            $dumpvars(0,usingt);
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