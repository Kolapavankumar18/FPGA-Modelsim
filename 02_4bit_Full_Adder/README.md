# 4-Bit Full Adder Using Verilog HDL

## Project Overview
Designed and simulated a 4-bit Full Adder using Verilog HDL and ModelSim.

The circuit performs binary addition of two 4-bit input numbers along with a carry input (Cin), producing a 4-bit sum and a carry output (Cout).

## Features
- Two 4-bit binary inputs (A and B)
- One carry input (Cin)
- 4-bit sum output
- Carry output (Cout)
- Combinational logic design
- Loop-based exhaustive testbench verification

## Input and Output Signals

| Signal | Width | Description |
|---|---|---|
| A | 4-bit | First binary input |
| B | 4-bit | Second binary input |
| Cin | 1-bit | Carry input |
| Sum | 4-bit | Sum output |
| Cout | 1-bit | Carry output |

## Working Principle

The Full Adder adds two 4-bit binary numbers and an additional carry input.

The mathematical operation is:

**Total = A + B + Cin**

The 5-bit result is divided into:
- Sum: Lower 4 bits
- Cout: Most significant bit

## Verification

A Verilog testbench was developed using nested loops to verify all possible input combinations.

Total combinations:

16 × 16 × 2 = **512 test cases**

## Simulation Tool
- HDL: Verilog
- Simulator: ModelSim
- Design Type: Combinational Logic

## Simulation Results

The simulation waveform demonstrates the input combinations, carry input, sum output and carry output.

## Learning Outcomes
- Understanding multi-bit binary addition
- Verilog module design
- Carry propagation
- Exhaustive testbench development
- ModelSim simulation and waveform analysis
