`timescale 1ns / 1ps

module tb_d_ff;

    // Inputs
    reg clk;
    reg rst_n;
    reg d;

    // Outputs
    wire q;

    // Instantiate the Unit Under Test (UUT)
    d_ff uut (
        .clk(clk),
        .rst_n(rst_n),
        .d(d),
        .q(q)
    );

    // Clock generation: 10ns period (5ns high, 5ns low)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        d = 0;

        // Hold reset active for 20ns
        #20;
        rst_n = 1; // Release reset

        // Apply test vectors
        #10 d = 1;
        #10 d = 0;
        #15 d = 1;
        #5  d = 0;

        // Test asynchronous reset mid-operation
        #12 rst_n = 0;
        #10 rst_n = 1;
        #10 d = 1;

        // End simulation
        #30;
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time = %0t ns | rst_n = %b | d = %b | q = %b", $time, rst_n, d, q);
    end

endmodule