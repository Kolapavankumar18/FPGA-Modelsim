# 2-Stage Pipelined RISC-V Processor using Verilog HDL

## Project Overview

This project implements a 32-bit, two-stage pipelined RISC-V processor using Verilog HDL.

The processor architecture divides instruction execution into two pipeline stages:

1. Instruction Fetch (IF)
2. Decode, Execute, Memory Access and Write Back (EX)

The design supports a subset of RISC-V instructions, including arithmetic, logical, load/store and branch operations.

The processor is verified using a Verilog testbench and ModelSim waveform simulation.

## Objectives

- Understand RISC-V processor architecture.
- Implement a two-stage pipeline.
- Design an instruction fetch mechanism.
- Implement instruction decoding.
- Perform arithmetic and logical operations.
- Implement load and store operations.
- Implement conditional branching.
- Understand pipeline registers and instruction flow.
- Verify processor functionality using a testbench.

## Processor Architecture

The processor contains the following major components:

- Program Counter (PC)
- Instruction Memory
- IF/ID Pipeline Register
- Instruction Decoder
- Register File
- Immediate Generator
- Arithmetic Logic Unit (ALU)
- Data Memory
- Control Logic
- Register Write-Back Logic

## Pipeline Stages

### Stage 1: Instruction Fetch (IF)

The first stage fetches instructions from instruction memory using the Program Counter.

Operations:
- Fetch instruction from instruction memory.
- Maintain the current instruction address.
- Update the PC.
- Pass the fetched instruction and PC to the IF/ID pipeline register.

### Stage 2: Decode, Execute, Memory Access and Write Back

The second stage performs the remaining instruction operations.

Operations:
- Decode opcode and function fields.
- Read source registers.
- Generate immediate values.
- Perform arithmetic and logical operations.
- Read or write data memory.
- Write results into the destination register.
- Evaluate branch conditions.

## Supported RISC-V Instructions

| Instruction | Description |
|---|---|
| ADD | Register addition |
| SUB | Register subtraction |
| AND | Bitwise AND |
| OR | Bitwise OR |
| ADDI | Addition with immediate |
| LW | Load word from memory |
| SW | Store word into memory |
| BEQ | Branch if equal |

## Instruction Formats

The implementation uses the relevant RISC-V instruction formats:

- R-type: ADD, SUB, AND, OR
- I-type: ADDI, LW
- S-type: SW
- B-type: BEQ

## Testbench Program

The testbench generates a sample RISC-V instruction program.

| Instruction | Expected Result |
|---|---|
| ADDI x1,x0,5 | x1 = 5 |
| ADDI x2,x0,7 | x2 = 7 |
| ADD x3,x1,x2 | x3 = 12 |
| SUB x4,x3,x1 | x4 = 7 |
| SW x3,0(x0) | MEM[0] = 12 |
| LW x5,0(x0) | x5 = 12 |
| BEQ x4,x2,+8 | Branch taken |
| ADDI x6,x0,99 | Instruction skipped |
| ADDI x7,x0,11 | x7 = 11 |

## Expected Simulation Results

| Register / Memory | Expected Value |
|---|---:|
| x1 | 5 |
| x2 | 7 |
| x3 | 12 |
| x4 | 7 |
| x5 | 12 |
| x6 | 0 |
| x7 | 11 |
| MEM[0] | 12 |

The branch instruction skips the instruction that attempts to write 99 into register x6.

## Pipeline Operation

A pipeline register is used between the instruction fetch stage and the execution stage.

The processor also handles a taken branch by updating the PC with the branch target and inserting a NOP into the pipeline register to discard the incorrectly fetched instruction.

## Simulation

**Tool:** ModelSim

### ModelSim Commands

```tcl
vlib work
vlog riscv_2stage.v tb_riscv_2stage.v
vsim work.tb_riscv_2stage
add wave -r /*
run -all
```

### Icarus Verilog Commands

```bash
iverilog -g2012 -o riscv_sim riscv_2stage.v tb_riscv_2stage.v
vvp riscv_sim
```

## Simulation Waveforms

The ModelSim waveforms are used to observe:

- Clock and reset signals.
- Program Counter updates.
- Instruction fetch.
- Pipeline register values.
- Register file updates.
- ALU operations.
- Memory read and write operations.
- Branch decision and PC redirection.
- Final register and memory values.

### Waveform 1

![RISC-V processor waveform 1](waveform/riscv_waveform1.png)

### Waveform 2

![RISC-V processor waveform 2](waveform/riscv_waveform2.png)

## Design Limitations

- Supports only a subset of the RV32I instruction set.
- No forwarding unit is implemented.
- No hazard detection or stall unit is implemented.
- Uses separate instruction and data memories.
- Implements a simplified two-stage educational pipeline.
- Does not implement interrupts, exceptions or a complete processor privilege architecture.

## Technologies Used

- Verilog HDL
- ModelSim
- Icarus Verilog
- RISC-V Instruction Set Architecture
- Digital Design
- Computer Architecture
- RTL Design and Simulation

## Applications

- Processor architecture learning.
- RISC-V based hardware design.
- RTL design practice.
- Computer architecture education.
- Digital processor development.

## Future Enhancements

- Implement a hazard detection unit.
- Add data forwarding.
- Extend the processor to a five-stage pipeline.
- Support additional RV32I instructions.
- Add branch prediction.
- Develop a SystemVerilog verification environment.
- Implement functional coverage and assertions.



## References

- RISC-V Instruction Set Manual
- RISC-V Unprivileged Architecture Specification

**Note:** This is an educational two-stage pipelined processor implementation, not a complete RV32I-compliant commercial processor.
