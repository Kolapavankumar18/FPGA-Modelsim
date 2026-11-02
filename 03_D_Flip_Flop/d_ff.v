module d_ff (
    input wire clk,     // Clock signal
    input wire rst_n,   // Asynchronous reset (active low)
    input wire d,       // Data input
    output reg q        // Output
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 1'b0;  // Reset output to 0 immediately
        end else begin
            q <= d;     // Capture D input on the rising edge of the clock
        end
    end

endmodule