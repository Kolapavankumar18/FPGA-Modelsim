# 4:1 Multiplexer Using Verilog HDL

## Project Overview

Designed and simulated a 4:1 Multiplexer (MUX) using Verilog HDL and ModelSim.

A Multiplexer is a combinational logic circuit that selects one input from four input lines and forwards the selected input to a single output based on the select lines.

## Project Objectives

- Design a 4:1 Multiplexer using Verilog HDL.
- Understand data selection using select lines.
- Implement combinational logic.
- Verify all possible input and select-line combinations using a testbench.

## Features

- Four data inputs (I0, I1, I2, I3).
- Two select lines (S1, S0).
- One output (Y).
- Combinational logic implementation.
- Complete truth table verification.
- ModelSim waveform analysis.

## Block Diagram

```text
       I0 ─────┐
       I1 ─────┤
       I2 ─────┤
       I3 ─────┤
               │
          +----------+
    S1 -->|          |
    S0 -->|  4:1 MUX |----> Y
          |          |
          +----------+
```

## Input and Output Signals

| Signal | Width | Description |
|---|---|---|
| I0 | 1-bit | Input 0 |
| I1 | 1-bit | Input 1 |
| I2 | 1-bit | Input 2 |
| I3 | 1-bit | Input 3 |
| S1, S0 | 2-bit | Select lines |
| Y | 1-bit | Output |

## Truth Table

| S1 | S0 | Output Y |
|---|---|---|
| 0 | 0 | I0 |
| 0 | 1 | I1 |
| 1 | 0 | I2 |
| 1 | 1 | I3 |

## Boolean Expression

Y = (I0 · S1' · S0') + (I1 · S1' · S0) + (I2 · S1 · S0') + (I3 · S1 · S0)

## Working Principle

1. Four input signals are connected to the multiplexer.
2. Two select lines determine which input is selected.
3. Based on the select-line combination, the corresponding input is transferred to the output.
4. The output changes whenever the selected input or select lines change.

## Verification and Testing

A Verilog testbench is used to verify all possible input and select-line combinations.

- 4 data inputs.
- 2 select lines.
- Total possible combinations: 2^6 = 64.

## Simulation Tools

- **Hardware Description Language:** Verilog HDL
- **Simulation Software:** ModelSim
- **Design Type:** Combinational Logic

## Simulation Waveform

The ModelSim waveform demonstrates the four input signals, select lines and corresponding output selection.

## Learning Outcomes

- Understanding multiplexer architecture.
- Data selection using select lines.
- Boolean expression implementation.
- Combinational logic design.
- Verilog testbench development.
- ModelSim simulation and waveform analysis.

## Project Files

- `mux_4to1.v` – Verilog design.
- `mux_4to1_tb.v` – Testbench.
- `waveform/` – ModelSim simulation screenshots.

