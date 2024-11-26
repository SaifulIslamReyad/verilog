module reyad (
    output reg FA,      
    output reg FB,      
    input t_clock,
    input t_reset 
);
    always @(posedge t_clock or posedge t_reset) begin
        if (t_reset) begin
            FA <= 0;
            FB <= 0;
        end else begin
            case ({FA, FB})
                2'b00: {FA, FB} <= 2'b11; 
                2'b11: {FA, FB} <= 2'b01; 
                2'b01: {FA, FB} <= 2'b10; 
                2'b10: {FA, FB} <= 2'b00; 
                default: {FA, FB} <= 2'b00; 
            endcase
        end
    end
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