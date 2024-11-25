module Shift_Register_3_beh (
    output reg [2:0] A_par,  // Register output
    input [2:0] I_par,       // Parallel input
    input s1, s0,            // Select inputs
    input MSB_in, LSB_in,    // Serial inputs
    input CLK, Clear_b       // Clock and Clear
);
    always @ (posedge CLK or negedge Clear_b)
        if (Clear_b == 0)
            A_par <= 3'b000; // Clear the register
        else
            case ({s1, s0})
                2'b00: A_par <= A_par;                   // No change
                2'b01: A_par <= {MSB_in, A_par[2:1]};    // Shift right
                2'b10: A_par <= {A_par[1:0], LSB_in};    // Shift left
                2'b11: A_par <= I_par;                  // Parallel load of input
            endcase
endmodule

module t_Shift_Register_3_beh;
    wire [2:0] A_par;        // Output of the shift register
    wire [1:0] state;        // State of the select inputs
    reg [2:0] I_par;         // Parallel input
    reg s1, s0;              // Select inputs
    reg MSB_in, LSB_in;      // Serial inputs
    reg CLK, Clear_b;        // Clock and Clear signals

    // Instantiate the 3-bit universal shift register
    Shift_Register_3_beh U3R (
        .A_par(A_par),
        .I_par(I_par),
        .s1(s1),
        .s0(s0),
        .MSB_in(MSB_in),
        .LSB_in(LSB_in),
        .CLK(CLK),
        .Clear_b(Clear_b)
    );

    assign state = {s1, s0}; // Concatenate select inputs into a single wire

    // Generate waveform dump for simulation
    initial begin
        $dumpfile("t3.vcd");
        $dumpvars(0, t_Shift_Register_3_beh);
    end

    // End simulation after 100 time units
    initial #100 $finish;

    // Clock and Clear signal generation
    initial begin
        Clear_b = 1; // Clear initially high
        CLK = 0;     // Initial clock state
        #5 Clear_b = 0; // Clear the register
        #7 Clear_b = 1; // Release clear
        repeat (16)
            #5 CLK = ~CLK; // Toggle clock every 5 time units
    end

    // Test sequence for the shift register
    initial begin
        s1 = 0; s0 = 0;      // Initial state: no operation
        MSB_in = 1;          // Set MSB input
        LSB_in = 0;          // Set LSB input
        I_par = 3'b101;      // Parallel input
        #10 s0 = 1;          // Shift right
        #30 s1 = 1;          // Parallel load
        #40 s0 = 0;          // Shift left
    end
endmodule
