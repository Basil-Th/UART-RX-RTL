# UART 8N1 Receiver

This repository contains the RTL design and verification of an 8-bit UART receiver implemented in Verilog.

I developed this project to gain practical experience with an ASIC-oriented RTL design flow. Along with the UART receiver RTL, the design was taken through lint checking, simulation, SystemVerilog assertions, CDC analysis, generic synthesis, SKY130HD technology mapping, and formal equivalence checking.

The current work is completed up to the synthesis stage.

## Design Specification

The UART receiver is designed with the following configuration:

- System clock: 50 MHz
- Baud rate: 9600
- Data bits: 8
- Parity: None
- Stop bits: 1
- Data order: LSB first
- RX idle level: HIGH

For a 50 MHz system clock and 9600 baud rate, the number of clock cycles for one UART bit is approximately:

```text
50,000,000 / 9600 ≈ 5208 clock cycles
```

The receiver uses four states:

```text
IDLE
START
DATA
STOP
```

In the `IDLE` state, the receiver waits for the RX line to go LOW.

Once a possible start bit is detected, the receiver enters the `START` state and waits until approximately the middle of the start bit. RX is checked again at this point to confirm that it is still LOW.

After a valid start bit is detected, the receiver enters the `DATA` state and samples eight incoming data bits at the required baud interval. The data is received LSB first.

After receiving all eight bits, the receiver enters the `STOP` state and checks whether RX is HIGH before updating the received data.

Since the UART RX signal is asynchronous to the system clock, a two-flip-flop synchronizer is used before the RX signal is processed by the receiver logic.

## RTL Verification

The RTL was lint checked using Verilator.

Functional simulation was performed using the Verilator-based simulation flow with the UART receiver testbench.

The testbench is available at:

```text
tb/UART_8N1_RX_tb.v
```

SystemVerilog assertions were also added to check important receiver behaviour.

The assertion file is available at:

```text
tb/UART_8N1_RX_sva.sv
```

## CDC Analysis

The UART RX input is asynchronous with respect to the 50 MHz system clock.

A two-flip-flop synchronizer is used in the RTL before the RX signal is used by the receiver state machine.

CDC analysis was performed using RTL-Buddy CDC.

The related constraint file is available at:

```text
cdc/uart_rx.sdc
```

## Synthesis

Synthesis was performed using Yosys.

The design was first synthesized into a generic gate-level representation.

The generated generic synthesized netlist is:

```text
synth/UART_8N1_RX_synth.v
```

The corresponding Yosys synthesis script is:

```text
synth/yosys_synth.ys
```

After generic synthesis, the design was mapped to the SKY130HD standard-cell library.

The generated SKY130HD technology-mapped netlist is:

```text
synth/UART_8N1_RX_sky130.v
```

The SKY130-related synthesis scripts are:

```text
synth/yosys_sky130_synth.ys
synth/yosys_sky130_map.ys
```

The SKY130HD mapped synthesis reported:

```text
Number of cells: 205
Chip area: 1983.152
Sequential element area: 1004.7136 (50.66%)
```

These are synthesis-level results based on the SKY130HD standard-cell library and are not final post-layout area results.

Schematic views were also generated using Yosys during the synthesis analysis to inspect the RTL, generic synthesized design, and SKY130HD mapped design.

## Formal Equivalence

Formal equivalence checking was performed using Yosys.

The RTL implementation was compared with the generic synthesized netlist to verify that synthesis preserved the design behaviour.

The final result was:

```text
Found 37 $equiv cells in equiv:
  Of those cells 37 are proven and 0 are unproven.

Equivalence successfully proven!
```

Therefore, all 37 equivalence points between the RTL and generic synthesized implementation were successfully proven.

Additional experiments were performed to compare the generic synthesized design with the SKY130HD technology-mapped netlist.

The SKY130HD equivalence check was not fully proven, so it is not considered a completed equivalence result in this project. The related scripts have been retained in the `equiv/` directory for further study.

## Repository Contents

### RTL

```text
rtl/UART_8N1_RX.v
```

Main synthesizable UART receiver RTL.

### Testbench and Assertions

```text
tb/UART_8N1_RX_tb.v
tb/UART_8N1_RX_sva.sv
```

Contains the UART receiver testbench and SystemVerilog assertions.

### CDC

```text
cdc/uart_rx.sdc
```

Constraint file used for CDC analysis.

### Synthesis

```text
synth/UART_8N1_RX_synth.v
synth/UART_8N1_RX_sky130.v
synth/yosys_synth.ys
synth/yosys_sky130_synth.ys
synth/yosys_sky130_map.ys
```

Contains the Yosys synthesis scripts and generated netlists.

### Formal Equivalence

```text
equiv/equiv_generic.ys
equiv/equiv_sky130.ys
equiv/equiv_generic_vs_sky130.ys
equiv/equiv_generic_vs_sky130_fflogic.ys
```

Contains the Yosys scripts used during formal equivalence checking and the SKY130HD equivalence experiments.

## Tools Used

- Verilog HDL – RTL design
- SystemVerilog – assertion-based verification
- Verilator – lint checking and simulation
- Yosys – synthesis, SKY130HD technology mapping, schematic generation, and formal equivalence
- RTL-Buddy CDC – CDC analysis
- SKY130HD – standard-cell library used for technology mapping
- OpenROAD Flow Scripts – SKY130HD platform and library environment
- Docker Desktop with WSL2 – ASIC tool environment
- Git – version control

## Current Status

The following stages have been completed for this project:

- UART receiver RTL design
- RTL lint checking
- Functional simulation
- SystemVerilog assertion-based verification
- CDC analysis
- Generic synthesis
- SKY130HD technology mapping
- RTL-to-generic formal equivalence checking

The RTL-to-generic equivalence check passed with all **37/37 equivalence points proven**.

The SKY130HD post-mapping equivalence experiment was not fully proven and has been left for further study.

Static timing analysis and physical design have not been performed as part of the current project.

## Future Work

The next stages I plan to explore using this design are:

- Static Timing Analysis (STA)
- Floorplanning
- Placement
- Clock Tree Synthesis
- Routing
- Post-layout timing analysis
- Physical verification

## Author

**Basil Thankachan**

B.Tech in Electronics and Communication Engineering  
RTL Design | Digital Design | VLSI
