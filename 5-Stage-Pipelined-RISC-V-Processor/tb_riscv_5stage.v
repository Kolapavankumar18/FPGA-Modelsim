
`timescale 1ns/1ps

module tb_riscv_5stage;

    reg clk;
    reg reset;

    riscv_5stage dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    // Encode I-type instruction
    function [31:0] enc_i;
        input integer imm;
        input integer rs1;
        input integer funct3;
        input integer rd;
        input [6:0] opcode;
        begin
            enc_i = {imm[11:0], rs1[4:0], funct3[2:0],
                     rd[4:0], opcode};
        end
    endfunction

    // Encode R-type instruction
    function [31:0] enc_r;
        input integer funct7;
        input integer rs2;
        input integer rs1;
        input integer funct3;
        input integer rd;
        input [6:0] opcode;
        begin
            enc_r = {funct7[6:0], rs2[4:0], rs1[4:0],
                     funct3[2:0], rd[4:0], opcode};
        end
    endfunction

    // Encode S-type instruction
    function [31:0] enc_s;
        input integer imm;
        input integer rs2;
        input integer rs1;
        input integer funct3;
        input [6:0] opcode;
        begin
            enc_s = {imm[11:5], rs2[4:0], rs1[4:0],
                     funct3[2:0], imm[4:0], opcode};
        end
    endfunction

    // Encode B-type instruction
    function [31:0] enc_b;
        input integer offset;
        input integer rs2;
        input integer rs1;
        input integer funct3;
        input [6:0] opcode;
        reg [12:0] b;
        begin
            b = offset;
            enc_b = {b[12], b[10:5], rs2[4:0], rs1[4:0],
                     funct3[2:0], b[4:1], b[11], opcode};
        end
    endfunction

    integer k;

    initial begin

        clk = 0;
        reset = 1;

        // Initialize instruction memory and data memory
        for (k = 0; k < 64; k = k + 1) begin
            dut.imem[k] = 32'h00000013; // NOP
            dut.dmem[k] = 0;
        end

        // Initialize register file
        for (k = 0; k < 32; k = k + 1)
            dut.regfile[k] = 0;

        // --------------------------------
        // RISC-V TEST PROGRAM
        // --------------------------------

        // x1 = 5
        dut.imem[0] = enc_i(5, 0, 0, 1, 7'b0010011);

        // x2 = 7
        dut.imem[1] = enc_i(7, 0, 0, 2, 7'b0010011);

        // x3 = x1 + x2 = 12
        dut.imem[2] = enc_r(0, 2, 1, 0, 3, 7'b0110011);

        // x4 = x3 - x1 = 7
        dut.imem[3] = enc_r(7'b0100000, 1, 3, 0, 4, 7'b0110011);

        // MEM[0] = x3
        dut.imem[4] = enc_s(0, 3, 0, 2, 7'b0100011);

        // x5 = MEM[0] = 12
        dut.imem[5] = enc_i(0, 0, 2, 5, 7'b0000011);

        // x8 = x5 + 1 = 13
        // Tests load-use hazard and forwarding
        dut.imem[6] = enc_i(1, 5, 0, 8, 7'b0010011);

        // BEQ x4, x2, +8
        // x4 = 7 and x2 = 7, so branch is taken
        dut.imem[7] = enc_b(8, 2, 4, 0, 7'b1100011);

        // x6 = 99 (should be skipped)
        dut.imem[8] = enc_i(99, 0, 0, 6, 7'b0010011);

        // x7 = 11 (branch target)
        dut.imem[9] = enc_i(11, 0, 0, 7, 7'b0010011);

        // --------------------------------
        // RESET
        // --------------------------------

        #12;
        reset = 0;

        // Allow all instructions to complete
        repeat (30) @(posedge clk);
        #1;

        // --------------------------------
        // DISPLAY RESULTS
        // --------------------------------

        $display("------------------------------------------");
        $display("       5-STAGE RISC-V TEST RESULTS");
        $display("------------------------------------------");

        $display("x1 = %0d (expected 5)", dut.regfile[1]);
        $display("x2 = %0d (expected 7)", dut.regfile[2]);
        $display("x3 = %0d (expected 12)", dut.regfile[3]);
        $display("x4 = %0d (expected 7)", dut.regfile[4]);
        $display("x5 = %0d (expected 12)", dut.regfile[5]);
        $display("x6 = %0d (expected 0; skipped)", dut.regfile[6]);
        $display("x7 = %0d (expected 11)", dut.regfile[7]);
        $display("x8 = %0d (expected 13)", dut.regfile[8]);

        $display("MEM[0] = %0d (expected 12)", dut.dmem[0]);

        $display("------------------------------------------");

        // --------------------------------
        // CHECK RESULTS
        // --------------------------------

        if (dut.regfile[1] == 5 &&
            dut.regfile[2] == 7 &&
            dut.regfile[3] == 12 &&
            dut.regfile[4] == 7 &&
            dut.regfile[5] == 12 &&
            dut.regfile[6] == 0 &&
            dut.regfile[7] == 11 &&
            dut.regfile[8] == 13 &&
            dut.dmem[0] == 12)

            $display("TEST PASSED");

        else
            $display("TEST FAILED");

        $display("------------------------------------------");

        $finish;

    end

endmodule
