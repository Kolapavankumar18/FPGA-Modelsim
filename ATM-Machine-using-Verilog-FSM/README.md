# ATM Machine Controller using Verilog HDL and FSM

## Project Overview

This project implements an Automated Teller Machine (ATM) controller using Verilog HDL and a Finite State Machine (FSM).

The design supports PIN verification, balance inquiry, cash withdrawal, money deposit, insufficient balance detection, and invalid transaction detection.

A six-state FSM is implemented to control the ATM operations.

## Objectives

- Design an ATM controller using Verilog HDL.
- Implement a Finite State Machine.
- Perform PIN verification.
- Implement balance inquiry.
- Perform cash withdrawal and deposit operations.
- Update the account balance using sequential logic.
- Detect insufficient funds.
- Detect incorrect PIN and invalid transactions.
- Verify the design using a Verilog testbench.

## FSM Architecture

The ATM controller consists of six states.

| State | Binary Encoding | Function |
|---|---|---|
| IDLE | 000 | Wait for transaction start |
| PIN_CHECK | 001 | Verify the entered PIN |
| MENU | 010 | Proceed to transaction selection |
| EXECUTE | 011 | Execute the selected operation |
| SUCCESS | 100 | Indicate successful transaction |
| ERROR | 101 | Indicate transaction error |

## State Transition Diagram

```text
             IDLE
               |
             Start
               |
           PIN_CHECK
           /       \
       Correct     Wrong
          |           |
         MENU        ERROR
          |
        EXECUTE
       /   |    \
   Balance Withdraw Deposit
      |      |      |
      |   Check     Update
      |  Balance   Balance
      |      |      |
      +---- SUCCESS
                 |
                IDLE

ERROR
  |
 IDLE
```

## Transaction Types

The design supports three valid transaction types.

| Transaction | Binary Code | Description |
|---|---|---|
| CHECK_BALANCE | 00 | Display current balance |
| WITHDRAW | 01 | Withdraw money |
| DEPOSIT | 10 | Deposit money |
| INVALID | 11 | Invalid transaction |

## Input Signals

| Input | Width | Description |
|---|---|---|
| clk | 1 bit | Clock signal |
| reset | 1 bit | Active-high asynchronous reset |
| start | 1 bit | Starts ATM operation |
| pin | 16 bits | Entered PIN |
| txn_type | 2 bits | Selected transaction |
| amount | 16 bits | Transaction amount |

## Output Signals

| Output | Width | Description |
|---|---|---|
| balance | 16 bits | Current account balance |
| txn_done | 1 bit | Transaction completion indicator |
| pin_error | 1 bit | Incorrect PIN indicator |
| insufficient_funds | 1 bit | Insufficient balance indicator |
| invalid_txn | 1 bit | Invalid transaction indicator |

## Working Principle

### 1. IDLE State
The ATM waits for the start signal.

### 2. PIN_CHECK State
The entered PIN is compared with the predefined correct PIN (16'h1234).

- Correct PIN: Moves to MENU.
- Incorrect PIN: Moves to ERROR.

### 3. MENU State
The controller proceeds to the transaction execution state.

### 4. EXECUTE State
The selected transaction is performed.

- Balance Inquiry: Proceeds to SUCCESS.
- Withdrawal: Checks account balance before deducting the amount.
- Deposit: Adds the requested amount to the account balance.
- Invalid Transaction: Moves to ERROR.

### 5. SUCCESS State
The transaction completion signal is activated, and the controller returns to IDLE.

### 6. ERROR State
The appropriate error output is activated for an incorrect PIN, insufficient funds, or invalid transaction. The controller then returns to IDLE.

## Initial Conditions

- Initial account balance: 10000
- Correct PIN: 1234 (16'h1234)
- Balance register width: 16 bits
- FSM state width: 3 bits
- FSM states: 6
- Clock period in testbench: 10 ns
- Reset: Active-high asynchronous reset

## Testbench Verification

A separate Verilog testbench is developed to verify the ATM controller.

The testbench performs the following operations:

1. Balance inquiry with correct PIN.
2. Withdraw 2000.
3. Deposit 5000.
4. Attempt withdrawal of 20000.
5. Enter an incorrect PIN.
6. Perform an invalid transaction.

### Simulation Results

| Test | Operation | Amount | Expected Balance |
|---|---|---:|---:|
| 1 | Initial balance | - | 10000 |
| 2 | Balance inquiry | 0 | 10000 |
| 3 | Withdrawal | 2000 | 8000 |
| 4 | Deposit | 5000 | 13000 |
| 5 | Insufficient withdrawal | 20000 | 13000 |
| 6 | Wrong PIN | - | 13000 |
| 7 | Invalid transaction | 100 | 13000 |

## Simulation Waveform

The design is simulated using ModelSim.

The waveform demonstrates:

- Clock and reset signals.
- ATM start signal.
- PIN verification.
- Transaction type selection.
- Transaction amount.
- Account balance updates.
- Transaction completion.
- PIN error detection.
- Insufficient funds detection.
- Invalid transaction detection.
- FSM state transitions.

![ATM Machine FSM ModelSim Waveform](waveform/atm_machine_waveform.png)

## ModelSim Simulation Commands

```tcl
vlib work
vlog atm_machine.v atm_machine_tb.v
vsim work.atm_tb
add wave -r /*
run -all
```

## Icarus Verilog Simulation Commands

```bash
iverilog -g2012 -o atm_sim atm_machine.v atm_machine_tb.v
vvp atm_sim
```

## Technologies Used

- Verilog HDL
- ModelSim
- Icarus Verilog
- Finite State Machine
- Digital Electronics
- RTL Design and Simulation

## Applications

- ATM controller systems.
- Digital banking systems.
- FSM-based control systems.
- RTL design and verification practice.

## Future Enhancements

- Multiple PIN attempts and account lockout.
- Separate account and transaction modules.
- Deposit overflow protection.
- Transaction amount validation.
- SystemVerilog-based self-checking testbench.
- UVM-based verification environment.


## Note

This is an educational Verilog RTL implementation. PIN verification uses a predefined PIN for simulation and is not intended for real banking security or deployment.
