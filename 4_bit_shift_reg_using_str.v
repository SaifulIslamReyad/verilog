// 4:1 Multiplexer
module mux41(o, a, b, c, d, s);
    output o;
    input a, b, c, d;
    input [1:0] s;
    assign o = (s == 2'b00) ? a : 
               (s == 2'b01) ? b : 
               (s == 2'b10) ? c : d;
endmodule

// D Flip-Flop with Asynchronous Clear
module d_flipflop_async_clear(output reg q, input d, clk, clear_n);
    always @(posedge clk or negedge clear_n) begin
        if (!clear_n)   // Asynchronous clear
            q <= 1'b0;
        else            // Normal operation
            q <= d;
    end
endmodule

// 4-Bit Universal Shift Register
module universal_shift_register_4bit (
    output [3:0] q,       // Outputs of the register
    input [3:0] data_in,  // Parallel load data input
    input left_in,        // Serial input for shift left
    input right_in,       // Serial input for shift right
    input [1:0] mode,     // Mode control: 00 = Hold, 01 = Shift right, 10 = Shift left, 11 = Parallel load
    input clk,            // Clock signal
    input clear_n         // Asynchronous clear
);

    wire [3:0] mux_out; // Outputs of multiplexers to D flip-flops

    // Instantiate multiplexers and D flip-flops for each bit
    // Q[0]
    mux41 mux0 (mux_out[0], q[0], right_in, q[1], data_in[0], mode);
    d_flipflop_async_clear dff0 (q[0], mux_out[0], clk, clear_n);

    // Q[1]
    mux41 mux1 (mux_out[1], q[1], q[0], q[2], data_in[1], mode);
    d_flipflop_async_clear dff1 (q[1], mux_out[1], clk, clear_n);

    // Q[2]
    mux41 mux2 (mux_out[2], q[2], q[1], q[3], data_in[2], mode);
    d_flipflop_async_clear dff2 (q[2], mux_out[2], clk, clear_n);

    // Q[3]
    mux41 mux3 (mux_out[3], q[3], q[2], left_in, data_in[3], mode);
    d_flipflop_async_clear dff3 (q[3], mux_out[3], clk, clear_n);

endmodule
module universal_shift_register_4bit_tb;
    reg [3:0] data_in;   // Parallel load data
    reg left_in, right_in; // Serial shift inputs
    reg [1:0] mode;      // Mode control
    reg clk, clear_n;    // Clock and clear signals
    wire [3:0] q;        // Register outputs

    // Instantiate the 4-bit universal shift register
    universal_shift_register_4bit UUT (
        .q(q),
        .data_in(data_in),
        .left_in(left_in),
        .right_in(right_in),
        .mode(mode),
        .clk(clk),
        .clear_n(clear_n)
    );

    // Generate clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period = 10 units
    end

    // Test sequence
    initial begin
        $dumpfile("universal_shift_register_4bit.vcd");
        $dumpvars(0, universal_shift_register_4bit_tb);

        // Initialize inputs
        clear_n = 0; data_in = 4'b0000; left_in = 0; right_in = 0; mode = 2'b00;

        // Clear the register
        #10 clear_n = 1;

        // Test: Parallel Load
        #10 mode = 2'b11; data_in = 4'b1101;

        // Test: Hold
        #10 mode = 2'b00;

        // Test: Shift Right
        #10 mode = 2'b01; right_in = 1;

        // Test: Shift Left
        #10 mode = 2'b10; left_in = 1;

        // Test: Shift Right with different input
        #10 mode = 2'b01; right_in = 0;

        // Test: Parallel Load again
        #10 mode = 2'b11; data_in = 4'b1010;

        // Test: Hold
        #10 mode = 2'b00;

        // End the simulation
        #50 $finish;
    end
endmodule
