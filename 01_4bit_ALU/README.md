# 4-Bit Arithmetic Logic Unit (ALU) Using Verilog

## Project Overview
Designed and simulated a 4-bit Arithmetic Logic Unit (ALU) using Verilog HDL and ModelSim.

The ALU performs arithmetic and logical operations based on a 3-bit opcode. It also generates carry/borrow and zero status flags.

## Features
- 4-bit input operands (A and B)
- 3-bit operation selection (opcode)
- Arithmetic operations: Addition and Subtraction
- Logical operations: AND, OR and XOR
- Carry and Borrow detection
- Zero flag generation
- Combinational logic design

## Operation Table

| Opcode | Operation |
|:---:|---|
| 000 | Addition |
| 001 | Subtraction |
| 010 | AND |
| 011 | OR |
| 100 | XOR |
| 101–111 | Default output (zero) |

## Input and Output Signals

| Signal | Width | Description |
|---|---:|---|
| A | 4-bit | First input |
| B | 4-bit | Second input |
| opcode | 3-bit | Operation selector |
| result | 4-bit | ALU output |
| carry_borrow | 1-bit | Carry or borrow flag |
| zero | 1-bit | Zero status flag |

## Design Methodology
- Developed the ALU using combinational logic (`always @(*)`).
- Used a `case` statement to select operations.
- Implemented a 5-bit temporary register for addition to capture carry.
- Generated a borrow flag during subtraction.
- Implemented zero detection based on the result.

## Verification
A Verilog testbench was developed to verify all five supported operations and different input combinations.

Test scenarios include:
- Normal addition
- Addition with carry overflow
- Normal subtraction
- Subtraction with borrow
- AND, OR and XOR operations
- Zero-result detection

## Simulation Tool
- Language: Verilog HDL
- Simulator: ModelSim
- Design Type: Combinational Logic

## Simulation Waveform

![4-Bit ALU ModelSim Waveform](waveform/alu_simulation.png)

## Project Files
- `alu4.v` – ALU design module
- `alu4_tb.v` – Verification testbench
- `waveform/` – Simulation waveform screenshot
- `docs/` – Operation truth table

## Learning Outcomes
- Understanding ALU architecture
- Verilog combinational logic design
- Opcode-based operation selection
- Carry and borrow detection
- Testbench development and simulation using ModelSim
