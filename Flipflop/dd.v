module dd(
    output FA,FB,
    input x_in,clock,reset);
    wire DA,DB;
    assign DA = x_in;
    assign DB = (FB&(~x_in))|(FA&FB)|((~FA)&(~FB)&x_in);
    
    DFF D_A(FA,DA,clock,reset);
    DFF D_B(FB,DB,clock,reset);
endmodule

module DFF ( output reg Q, input D, Clk, rst);
  always @( posedge Clk, negedge rst)
   if (!rst) Q <= 1'b0;
  else Q <= D;
endmodule

module durjay_qs_1;
    reg t_x_in,t_clock,t_reset;
    wire [1:0] state;

    dd p (FA,FB,t_x_in,t_clock,t_reset);
    assign state={FA,FB};

    initial
        begin
            $dumpfile("d.vcd");
            $dumpvars(0,durjay_qs_1);
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

