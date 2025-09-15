

`timescale 1ns / 1ps

module sm_tb;

    parameter WIDTH = 5;

    reg clk;
    reg rst_n;
    reg act;
    reg up_dwn_n;
    wire [WIDTH-1:0] count;
    wire ovflw;

    // Instantiate the state machine
    sm #(WIDTH) DUT (.clk(clk),
                    .rst_n(rst_n),
                    .act(act),
                    .up_dwn_n(up_dwn_n),
                    .count(count),
                    .ovflw(ovflw));

    // Define a clock
    always #5 clk = ~clk;

    // Set initial values, value monitoring and reset sequence
    initial begin
        clk = 1'b1;
        rst_n = 1'b0; // Activate reset
        act = 1'b0;
        up_dwn_n = 1'b1;

        // Monitor changes
        $monitor("%t: rst_n=%b act=%b up_dwn_n=%b count=%d ovflw=%b\n", $time, rst_n, act, up_dwn_n, count, ovflw);

        // After 100 time steps, release reset
        #100 rst_n = 1'b1;
    end

    // Set stimuli
    initial begin
        // @100, Start counting up until overflow
        #100 act = 1'b1;
        up_dwn_n = 1'b1;

        // Reset (10 cycles pulse)
        #1000 rst_n = 1'b0;
        act = 1'b0;
        #100 rst_n = 1'b1;

        // Do a count-up to 4 and then count-down to ovflw
        #100 act = 1'b1;
        up_dwn_n = 1'b1;
        #40 up_dwn_n = 1'b0;
    end

endmodule