module full_adder_dff_tb;

reg [3:0] A, B;
reg Cin, clk;

wire [3:0] Sum;
wire Cout;

integer i, j, k;
reg [4:0] expected;

full_adder_dff uut(
    .A(A),
    .B(B),
    .Cin(Cin),
    .clk(clk),
    .Sum(Sum),
    .Cout(Cout)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    A = 0;
    B = 0;
    Cin = 0;

    for(i = 0; i < 16; i = i + 1)
    begin
        for(j = 0; j < 16; j = j + 1)
        begin
            for(k = 0; k < 2; k = k + 1)
            begin
                @(negedge clk);

                A = i;
                B = j;
                Cin = k;

                expected = i + j + k;

                @(posedge clk);
                #1;

                if({Cout, Sum} !== expected)
                    $display("FAIL: A=%d B=%d Cin=%d",
                              A, B, Cin);
                else
                    $display("PASS: A=%d B=%d Cin=%d Sum=%d Cout=%b",
                              A, B, Cin, Sum, Cout);
            end
        end
    end

    $display("All 512 test cases completed.");
    $finish;
end

endmodule