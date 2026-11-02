`timescale 1ns/1ps

module full_adder_4bit_tb;

    // Inputs
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;

    // Outputs
    wire [3:0] Sum;
    wire Cout;

    // Integer variables for loops
    integer i, j, k;

    // Instantiate the Design Under Test (DUT)
    full_adder_4bit dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    // Test all possible combinations
    initial begin

        $display("A\tB\tCin\tSum\tCout");
        $display("-------------------------------------");

        // A = 0 to 15
        for (i = 0; i < 16; i = i + 1) begin

            // B = 0 to 15
            for (j = 0; j < 16; j = j + 1) begin

                // Cin = 0 and 1
                for (k = 0; k < 2; k = k + 1) begin

                    A = i;
                    B = j;
                    Cin = k;

                    #10;

                    $display("%b\t%b\t%b\t%b\t%b",
                             A, B, Cin, Sum, Cout);
                end
            end
        end

        $finish;
    end

endmodule