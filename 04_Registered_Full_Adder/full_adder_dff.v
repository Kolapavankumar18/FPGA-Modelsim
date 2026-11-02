module full_adder_dff(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input clk,
    output reg [3:0] Sum,
    output reg Cout
);

reg [4:0] temp;

// Full Adder + D Flip-Flop
always @(posedge clk)
begin
    temp = A + B + Cin;

    Sum  <= temp[3:0];
    Cout <= temp[4];
end

endmodule