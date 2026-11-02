# Washing Machine Controller Using SystemVerilog and FSM

## Project Overview

Designed a Washing Machine Controller using SystemVerilog and Finite State Machine (FSM) architecture.

The controller manages different washing machine operations through predefined states. It uses control inputs to determine the next state and generates appropriate outputs for each washing cycle.

## Project Objectives

- Design a washing machine controller using SystemVerilog.
- Understand Finite State Machine architecture.
- Implement sequential and combinational logic.
- Control washing operations through state transitions.
- Verify FSM functionality using a SystemVerilog testbench.

## Features

- FSM-based controller design.
- SystemVerilog implementation.
- Multiple washing cycle states.
- Clock-driven state transitions.
- Reset functionality.
- State-based output control.
- Testbench-based verification.

## FSM Architecture

The washing machine controller consists of the following states:

1. IDLE – Waiting for the start command.
2. FILL – Filling water into the washing machine.
3. WASH – Performing the washing operation.
4. RINSE – Rinsing clothes with water.
5. SPIN – Removing water through spinning.
6. DONE – Indicating completion of the washing cycle.

## FSM State Transition

```text
          +------+
          | IDLE |
          +------+
              |
          Start = 1
              |
              v
          +------+
          | FILL |
          +------+
              |
              v
          +------+
          | WASH |
          +------+
              |
              v
          +-------+
          | RINSE |
          +-------+
              |
              v
          +------+
          | SPIN |
          +------+
              |
              v
          +------+
          | DONE |
          +------+
              |
              v
          +------+
          | IDLE |
          +------+
```

## FSM Design Approach

The controller uses a Finite State Machine to manage washing operations.

The design includes:

- State register: Stores the current state.
- Next-state logic: Determines the next operating state.
- Output logic: Generates control signals based on the current state.

## Input and Output Signals

| Signal | Description |
|---|---|
| clk | Clock signal |
| reset | Reset signal |
| start | Starts washing cycle |
| water_full | Indicates water filling completion |
| wash_done | Indicates washing completion |
| rinse_done | Indicates rinsing completion |
| spin_done | Indicates spinning completion |
| water_valve | Controls water inlet |
| wash_motor | Controls washing motor |
| spin_motor | Controls spinning motor |
| done | Indicates cycle completion |

*Signal names should be adjusted to match the actual RTL implementation.*

## Verification

A SystemVerilog testbench is used to verify:

- Reset operation.
- Start command.
- State transitions.
- Washing cycle sequence.
- Completion indication.
- Correct output generation.

## Tools Used

- Hardware Description Language: SystemVerilog
- Simulation Tool: ModelSim
- Design Methodology: Finite State Machine (FSM)

## Learning Outcomes

- Understanding FSM architecture.
- Moore and Mealy FSM concepts.
- SystemVerilog RTL coding.
- State transition logic.
- Sequential circuit design.
- Testbench development.
- Simulation and waveform analysis.

## Project Files

- `washing_machine.sv` – FSM controller design.
- `washing_machine_tb.sv` – SystemVerilog testbench.
- `waveform/` – Simulation waveforms.
