module hello(
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

module labtest;
    reg x,clk,reset;
    wire [1:0] state;

    hello p (FA,FB,x,clk,reset);
    assign state={FA,FB};

    initial
        begin
            $dumpfile("hello.vcd");
            $dumpvars(0,labtest);
        end
    initial #150 $finish;

    initial
        begin
            reset=1;
            repeat(2)
                #5 reset = ~reset;
        end

    initial
        begin
            clk=0;
            repeat(28)
                #5 clk = ~clk;
        end
    
    initial
        begin
            x=0;
            #10 x=1;
            repeat(10)
                #20 x = ~x;
        end
endmodule