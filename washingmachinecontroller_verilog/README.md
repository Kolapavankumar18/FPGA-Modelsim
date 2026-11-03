# Washing Machine Controller using Verilog HDL

## Project Overview

This project implements an automatic washing machine controller using Verilog HDL and a Finite State Machine (FSM).

The controller manages the washing process through different states, starting from filling water and continuing through washing, draining, rinsing, and spinning.

A **Moore Finite State Machine** is used, where the outputs depend on the current state.

## Objectives

- Design an FSM-based washing machine controller.
- Understand state transitions in Verilog.
- Control water inlet, wash motor, drain pump, and spin motor.
- Simulate the complete washing cycle.
- Verify the design using a Verilog testbench and waveform analysis.

## FSM Architecture

The design consists of seven states:

| State | Binary Encoding | Operation |
|---|---|---|
| IDLE | 000 | Wait for start signal |
| FILL | 001 | Fill water into the machine |
| WASH | 010 | Rotate the drum for washing |
| DRAIN | 011 | Drain dirty water |
| RINSE | 100 | Rinse the clothes |
| SPIN | 101 | Spin the drum |
| DONE | 110 | Indicate cycle completion |

### State Transition Sequence

```text
       IDLE
         |
       start
         |
        FILL
         |
     water_full
         |
        WASH
         |
      wash_done
         |
        DRAIN
         |
     drain_done
         |
        RINSE
         |
     rinse_done
         |
        SPIN
         |
      spin_done
         |
        DONE
```

The machine can start another washing cycle when the start signal is asserted in the DONE state.

## Input Signals

| Input | Description |
|---|---|
| clk | Clock signal |
| reset | Asynchronous active-high reset |
| start | Starts the washing cycle |
| water_full | Indicates that the required water level is reached |
| wash_done | Indicates completion of washing |
| drain_done | Indicates completion of draining |
| rinse_done | Indicates completion of rinsing |
| spin_done | Indicates completion of spinning |

## Output Signals

| Output | Description |
|---|---|
| water_valve | Controls the water inlet valve |
| wash_motor | Controls the washing motor |
| drain_pump | Controls the drain pump |
| spin_motor | Controls the spinning motor |
| cycle_done | Indicates completion of the washing cycle |

## Working Principle

1. **IDLE:** The machine waits for the start signal.
2. **FILL:** The water valve is activated until the water-level sensor indicates that the required level is reached.
3. **WASH:** The washing motor is activated.
4. **DRAIN:** The drain pump removes the dirty water.
5. **RINSE:** The clothes are rinsed.
6. **SPIN:** The spin motor removes excess water from the clothes.
7. **DONE:** The washing cycle is completed and the completion output is activated.

## Verilog Design

The design is implemented using three main parts:

- State register using sequential logic.
- Next-state logic using a combinational `always @(*)` block.
- Output logic using Moore FSM architecture.

## Testbench Verification

A separate Verilog testbench is developed to verify the complete washing cycle.

The testbench generates:
- Clock signal with a 10 ns period.
- Reset signal.
- Start command.
- Water-level completion signal.
- Washing completion signal.
- Draining completion signal.
- Rinsing completion signal.
- Spinning completion signal.

The testbench checks whether the controller reaches the DONE state and asserts the `cycle_done` output.

### Expected Test Result

```text
TEST PASSED: Washing cycle completed!
```

## Simulation

**Tool:** ModelSim

### Steps

1. Create a new ModelSim project.
2. Add `washing_machine.v`.
3. Add `washing_machine_tb.v`.
4. Compile both Verilog files.
5. Simulate `washing_machine_tb`.
6. Add the required signals to the waveform window.
7. Run the simulation and observe the state transitions.

## Simulation Waveform

The waveform demonstrates the complete washing machine sequence.

The waveform verifies the state transitions:

`000 → 001 → 010 → 011 → 100 → 101 → 110`

It also demonstrates the corresponding activation of the water valve, wash motor, drain pump, spin motor, and cycle completion signal.

## Applications

- Automatic washing machine controllers.
- FSM-based embedded control systems.
- Digital control system design.
- RTL design and verification practice.

## Technologies Used

- Verilog HDL
- ModelSim
- Finite State Machine (FSM)
- Digital Electronics

