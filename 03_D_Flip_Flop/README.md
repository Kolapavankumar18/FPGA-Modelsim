# D Flip-Flop Using Verilog HDL

## Project Overview
Designed and simulated a D Flip-Flop using Verilog HDL and ModelSim.

A D Flip-Flop is a sequential logic circuit that stores one bit of data. It captures the input D at the active clock edge and transfers it to the output Q.

## Features
- 1-bit data input (D)
- Clock input (CLK)
- Stored output (Q)
- Complementary output (Qbar), if implemented
- Edge-triggered operation
- Sequential logic design

## Working Principle
The D Flip-Flop captures the input data at the active clock edge.

Characteristic equation:

Q(next) = D

## Truth Table

| Clock | D | Q(next) |
|---|---|---|
| Rising edge | 0 | 0 |
| Rising edge | 1 | 1 |
| No active edge | X | Q(previous) |

## Simulation Tool
- HDL: Verilog
- Simulator: ModelSim
- Design Type: Sequential Logic

## Verification
A Verilog testbench is used to verify data storage and output changes at the active clock edge.

## Learning Outcomes
- Understanding sequential circuits
- Clock edge triggering
- Data storage
- Verilog procedural blocks
- Testbench development
- ModelSim waveform analysis
