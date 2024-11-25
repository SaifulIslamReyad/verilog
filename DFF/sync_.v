module DFF (output reg Q, input D, clk, preset, clear); 
always @ (posedge clk) 
if (preset  == 0) Q <= 1'b1; 
else if (clear == 0) Q <= 1'b0; 
else Q <= D; 
endmodule