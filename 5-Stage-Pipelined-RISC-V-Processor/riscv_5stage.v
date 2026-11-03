
module riscv_5stage (
    input clk,
    input reset
);

    // Instruction and data memories
    reg [31:0] imem [0:63];
    reg [31:0] dmem [0:63];

    // Register file: x0 to x31
    reg [31:0] regfile [0:31];

    // Program counter
    reg [31:0] pc;

    // =========================================
    // IF/ID PIPELINE REGISTER
    // =========================================

    reg [31:0] if_id_pc;
    reg [31:0] if_id_instr;

    // =========================================
    // ID/EX PIPELINE REGISTER
    // =========================================

    reg [31:0] id_ex_pc;
    reg [31:0] id_ex_rs1_data;
    reg [31:0] id_ex_rs2_data;
    reg [31:0] id_ex_imm;

    reg [4:0] id_ex_rs1;
    reg [4:0] id_ex_rs2;
    reg [4:0] id_ex_rd;

    reg [2:0] id_ex_funct3;
    reg id_ex_funct7;

    reg id_ex_regwrite;
    reg id_ex_memread;
    reg id_ex_memwrite;
    reg id_ex_memtoreg;
    reg id_ex_alusrc;
    reg id_ex_branch;

    // =========================================
    // EX/MEM PIPELINE REGISTER
    // =========================================

    reg [31:0] ex_mem_alu_result;
    reg [31:0] ex_mem_write_data;
    reg [31:0] ex_mem_branch_target;

    reg [4:0] ex_mem_rd;

    reg ex_mem_regwrite;
    reg ex_mem_memread;
    reg ex_mem_memwrite;
    reg ex_mem_memtoreg;
    reg ex_mem_branch_taken;

    // =========================================
    // MEM/WB PIPELINE REGISTER
    // =========================================

    reg [31:0] mem_wb_alu_result;
    reg [31:0] mem_wb_mem_data;

    reg [4:0] mem_wb_rd;

    reg mem_wb_regwrite;
    reg mem_wb_memtoreg;

    // =========================================
    // INSTRUCTION DECODE
    // =========================================

    wire [6:0] opcode = if_id_instr[6:0];
    wire [4:0] rs1 = if_id_instr[19:15];
    wire [4:0] rs2 = if_id_instr[24:20];
    wire [4:0] rd  = if_id_instr[11:7];

    wire [2:0] funct3 = if_id_instr[14:12];
    wire funct7 = if_id_instr[30];

    wire [31:0] rs1_data = regfile[rs1];
    wire [31:0] rs2_data = regfile[rs2];

    // Immediate generation
    reg [31:0] immediate;

    always @(*) begin
        case (opcode)

            // I-type: ADDI, LW
            7'b0010011,
            7'b0000011:
                immediate = {{20{if_id_instr[31]}},
                             if_id_instr[31:20]};

            // S-type: SW
            7'b0100011:
                immediate = {{20{if_id_instr[31]}},
                             if_id_instr[31:25],
                             if_id_instr[11:7]};

            // B-type: BEQ
            7'b1100011:
                immediate = {{19{if_id_instr[31]}},
                             if_id_instr[31],
                             if_id_instr[7],
                             if_id_instr[30:25],
                             if_id_instr[11:8],
                             1'b0};

            default:
                immediate = 32'b0;

        endcase
    end

    // =========================================
    // CONTROL UNIT
    // =========================================

    reg dec_regwrite;
    reg dec_memread;
    reg dec_memwrite;
    reg dec_memtoreg;
    reg dec_alusrc;
    reg dec_branch;

    always @(*) begin

        dec_regwrite = 0;
        dec_memread  = 0;
        dec_memwrite = 0;
        dec_memtoreg = 0;
        dec_alusrc   = 0;
        dec_branch   = 0;

        case (opcode)

            // R-type
            7'b0110011:
                dec_regwrite = 1;

            // ADDI
            7'b0010011: begin
                dec_regwrite = 1;
                dec_alusrc = 1;
            end

            // LW
            7'b0000011: begin
                dec_regwrite = 1;
                dec_memread = 1;
                dec_memtoreg = 1;
                dec_alusrc = 1;
            end

            // SW
            7'b0100011: begin
                dec_memwrite = 1;
                dec_alusrc = 1;
            end

            // BEQ
            7'b1100011: begin
                dec_branch = 1;
            end

            default: begin
            end

        endcase
    end

    // =========================================
    // HAZARD DETECTION UNIT
    // =========================================

    wire id_uses_rs1 =
        (opcode == 7'b0110011) ||
        (opcode == 7'b0010011) ||
        (opcode == 7'b0000011) ||
        (opcode == 7'b0100011) ||
        (opcode == 7'b1100011);

    wire id_uses_rs2 =
        (opcode == 7'b0110011) ||
        (opcode == 7'b0100011) ||
        (opcode == 7'b1100011);

    wire stall =
        id_ex_memread &&
        (id_ex_rd != 0) &&
        ((id_uses_rs1 && id_ex_rd == rs1) ||
         (id_uses_rs2 && id_ex_rd == rs2));

    // =========================================
    // FORWARDING UNIT
    // =========================================

    reg [31:0] forward_a;
    reg [31:0] forward_b;

    always @(*) begin

        forward_a = id_ex_rs1_data;
        forward_b = id_ex_rs2_data;

        // EX/MEM forwarding
        if (ex_mem_regwrite &&
            !ex_mem_memread &&
            ex_mem_rd != 0 &&
            ex_mem_rd == id_ex_rs1)
            forward_a = ex_mem_alu_result;

        if (ex_mem_regwrite &&
            !ex_mem_memread &&
            ex_mem_rd != 0 &&
            ex_mem_rd == id_ex_rs2)
            forward_b = ex_mem_alu_result;

        // MEM/WB forwarding
        if (mem_wb_regwrite &&
            mem_wb_rd != 0 &&
            mem_wb_rd == id_ex_rs1)
            forward_a = mem_wb_memtoreg ?
                        mem_wb_mem_data :
                        mem_wb_alu_result;

        if (mem_wb_regwrite &&
            mem_wb_rd != 0 &&
            mem_wb_rd == id_ex_rs2)
            forward_b = mem_wb_memtoreg ?
                        mem_wb_mem_data :
                        mem_wb_alu_result;

    end

    // =========================================
    // EXECUTION / ALU
    // =========================================

    wire [31:0] alu_operand_b =
        id_ex_alusrc ? id_ex_imm : forward_b;

    reg [31:0] alu_result;

    always @(*) begin

        alu_result = 32'b0;

        if (id_ex_branch) begin
            alu_result = forward_a - forward_b;
        end
        else begin
            case (id_ex_funct3)

                3'b000: begin
                    if (id_ex_funct7)
                        alu_result = forward_a - alu_operand_b;
                    else
                        alu_result = forward_a + alu_operand_b;
                end

                3'b111:
                    alu_result = forward_a & alu_operand_b;

                3'b110:
                    alu_result = forward_a | alu_operand_b;

                default:
                    alu_result = forward_a + alu_operand_b;

            endcase
        end

    end

    wire branch_taken =
        id_ex_branch && (forward_a == forward_b);

    wire [31:0] branch_target =
        id_ex_pc + id_ex_imm;

    // =========================================
    // MEMORY ACCESS
    // =========================================

    wire [31:0] memory_read_data =
        dmem[ex_mem_alu_result[7:2]];

    // =========================================
    // WRITE BACK
    // =========================================

    wire [31:0] writeback_data =
        mem_wb_memtoreg ?
        mem_wb_mem_data :
        mem_wb_alu_result;

    integer i;

    // =========================================
    // PIPELINE SEQUENTIAL LOGIC
    // =========================================

    always @(posedge clk) begin

        if (reset) begin

            pc <= 0;

            if_id_pc <= 0;
            if_id_instr <= 0;

            id_ex_pc <= 0;
            id_ex_rs1_data <= 0;
            id_ex_rs2_data <= 0;
            id_ex_imm <= 0;
            id_ex_rs1 <= 0;
            id_ex_rs2 <= 0;
            id_ex_rd <= 0;
            id_ex_funct3 <= 0;
            id_ex_funct7 <= 0;

            id_ex_regwrite <= 0;
            id_ex_memread <= 0;
            id_ex_memwrite <= 0;
            id_ex_memtoreg <= 0;
            id_ex_alusrc <= 0;
            id_ex_branch <= 0;

            ex_mem_alu_result <= 0;
            ex_mem_write_data <= 0;
            ex_mem_branch_target <= 0;
            ex_mem_rd <= 0;

            ex_mem_regwrite <= 0;
            ex_mem_memread <= 0;
            ex_mem_memwrite <= 0;
            ex_mem_memtoreg <= 0;
            ex_mem_branch_taken <= 0;

            mem_wb_alu_result <= 0;
            mem_wb_mem_data <= 0;
            mem_wb_rd <= 0;
            mem_wb_regwrite <= 0;
            mem_wb_memtoreg <= 0;

            for (i = 0; i < 32; i = i + 1)
                regfile[i] <= 0;

            for (i = 0; i < 64; i = i + 1)
                dmem[i] <= 0;

        end

        else begin

            // WRITE BACK STAGE
            if (mem_wb_regwrite && mem_wb_rd != 0)
                regfile[mem_wb_rd] <= writeback_data;

            regfile[0] <= 0;

            // MEMORY STAGE
            if (ex_mem_memwrite)
                dmem[ex_mem_alu_result[7:2]]
                    <= ex_mem_write_data;

            mem_wb_alu_result <= ex_mem_alu_result;
            mem_wb_mem_data <= memory_read_data;
            mem_wb_rd <= ex_mem_rd;
            mem_wb_regwrite <= ex_mem_regwrite;
            mem_wb_memtoreg <= ex_mem_memtoreg;

            // EXECUTE STAGE -> EX/MEM
            ex_mem_alu_result <= alu_result;
            ex_mem_write_data <= forward_b;
            ex_mem_branch_target <= branch_target;
            ex_mem_rd <= id_ex_rd;

            ex_mem_regwrite <= id_ex_regwrite;
            ex_mem_memread <= id_ex_memread;
            ex_mem_memwrite <= id_ex_memwrite;
            ex_mem_memtoreg <= id_ex_memtoreg;
            ex_mem_branch_taken <= branch_taken;

            // BRANCH FLUSH
            if (branch_taken) begin

                pc <= branch_target;

                if_id_pc <= 0;
                if_id_instr <= 0;

                id_ex_pc <= 0;
                id_ex_rs1_data <= 0;
                id_ex_rs2_data <= 0;
                id_ex_imm <= 0;
                id_ex_rs1 <= 0;
                id_ex_rs2 <= 0;
                id_ex_rd <= 0;
                id_ex_funct3 <= 0;
                id_ex_funct7 <= 0;

                id_ex_regwrite <= 0;
                id_ex_memread <= 0;
                id_ex_memwrite <= 0;
                id_ex_memtoreg <= 0;
                id_ex_alusrc <= 0;
                id_ex_branch <= 0;

            end

            // LOAD-USE STALL
            else if (stall) begin

                // Hold PC and IF/ID
                pc <= pc;
                if_id_pc <= if_id_pc;
                if_id_instr <= if_id_instr;

                // Insert bubble into ID/EX
                id_ex_regwrite <= 0;
                id_ex_memread <= 0;
                id_ex_memwrite <= 0;
                id_ex_memtoreg <= 0;
                id_ex_alusrc <= 0;
                id_ex_branch <= 0;

                id_ex_pc <= 0;
                id_ex_rs1_data <= 0;
                id_ex_rs2_data <= 0;
                id_ex_imm <= 0;
                id_ex_rs1 <= 0;
                id_ex_rs2 <= 0;
                id_ex_rd <= 0;
                id_ex_funct3 <= 0;
                id_ex_funct7 <= 0;

            end

            // NORMAL PIPELINE OPERATION
            else begin

                // FETCH STAGE
                if_id_pc <= pc;
                if_id_instr <= imem[pc[7:2]];
                pc <= pc + 4;

                // DECODE STAGE
                id_ex_pc <= if_id_pc;
                id_ex_rs1_data <= rs1_data;
                id_ex_rs2_data <= rs2_data;
                id_ex_imm <= immediate;

                id_ex_rs1 <= rs1;
                id_ex_rs2 <= rs2;
                id_ex_rd <= rd;

                id_ex_funct3 <= funct3;
                id_ex_funct7 <= funct7;

                id_ex_regwrite <= dec_regwrite;
                id_ex_memread <= dec_memread;
                id_ex_memwrite <= dec_memwrite;
                id_ex_memtoreg <= dec_memtoreg;
                id_ex_alusrc <= dec_alusrc;
                id_ex_branch <= dec_branch;

            end

        end
    end

endmodule
