# 4-Bit Full Adder with D Flip-Flop Using Verilog HDL

## Project Overview

Designed and simulated a 4-bit Full Adder integrated with D Flip-Flops using Verilog HDL and ModelSim.

The project combines combinational and sequential logic. The Full Adder performs binary addition, while D Flip-Flops store the calculated output at the positive edge of the clock.

## Project Objectives

- Design a 4-bit Full Adder.
- Integrate D Flip-Flops to store the adder output.
- Understand the relationship between combinational and sequential circuits.
- Verify clock-triggered data storage using ModelSim.

## Features

- Two 4-bit binary inputs (A and B).
- One carry input (Cin).
- 4-bit Sum output.
- 1-bit Carry output (Cout).
- Clock-triggered output storage.
- Positive-edge-triggered D Flip-Flop operation.
- Verilog testbench verification.

## Block Diagram

```text
       A[3:0]       B[3:0]
          |            |
          +-----+------+
                |
          +-------------+
 Cin ---> | 4-Bit Full  |
          |    Adder    |
          +-------------+
                |
          5-Bit Result
                |
          +-------------+
 CLK ---> | 5 D Flip-   |
          |   Flops     |
          +-------------+
                |
          +-------------+
          | Registered  |
          |   Output    |
          +-------------+
                |
          Sum[3:0], Cout
```

## Input and Output Signals

| Signal | Width | Description |
|---|---|---|
| A | 4-bit | First binary input |
| B | 4-bit | Second binary input |
| Cin | 1-bit | Carry input |
| clk | 1-bit | Clock signal |
| Sum | 4-bit | Registered sum output |
| Cout | 1-bit | Registered carry output |

## Working Principle

1. Two 4-bit binary inputs and a carry input are supplied to the Full Adder.
2. The Full Adder performs binary addition.
3. The resulting 5-bit value is connected to the D Flip-Flops.
4. At every positive edge of the clock, the result is stored.
5. The stored output remains unchanged until the next positive clock edge.

### Mathematical Expression

Total addition:

`Total = A + B + Cin`

Registered output:

`{Cout, Sum} = Total`

## Verification and Testing

A Verilog testbench is used to verify all possible input combinations.

Total test cases:

`16 × 16 × 2 = 512`

The testbench checks:
- Different binary input combinations.
- Carry input variations.
- Sum and carry generation.
- Correct output storage at positive clock edges.

## Simulation Tools

- **Hardware Description Language:** Verilog HDL
- **Simulation Software:** ModelSim
- **Design Type:** Combinational Logic + Sequential Logic

## Simulation Waveform

The ModelSim waveform demonstrates input variations, clock transitions, and registered Sum and Carry outputs.

## Learning Outcomes

- Understanding 4-bit binary addition.
- Understanding D Flip-Flop operation.
- Clock edge-triggered data storage.
- Integration of combinational and sequential logic.
- Verilog RTL design and testbench development.
- Simulation and waveform analysis using ModelSim.

## Project Files

- `full_adder_dff.v` – Verilog design.
- `full_adder_dff_tb.v` – Testbench.
- `waveform/` – ModelSim simulation screenshots.

