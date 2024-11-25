module mux21(o,a,b,s);
output o;
input a,b,s;
assign o= s?b:a;
endmodule


module mux21_if(o,a,b,s);
output reg o;
input a,b,s;
always @(*)
if (s==1'b0)  o= a;
else o= b;
endmodule


module mux21_(o,a,b,s);
output o;
input a,b,s;
assign o= a&!s | b&s;
endmodule


module testbench;
reg a,b,s;
wire o;
mux21_ x(o,a,b,s);
  initial begin
    $dumpfile("reyad.vcd");
    $dumpvars(0, testbench);
    s=1;
    a = 0; b = 0;
    #10;
    a = 0; b = 1;
    #10;
    s=0;
    a = 1; b = 0;
    #10;
    a = 1; b = 1;
    #10;
    
    $finish;
  end
  
  initial begin
    $monitor("a = %b, b = %b, s=%b output=%b", a, b, s, o);
  end
  endmodule