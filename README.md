# Microprocessor-HDL

A small pipelined microprocessor designed, tested and simulated in **VHDL**. It is built from an instruction queue, decoder, controller, ROM (register file) and ALU, and it evaluates an arithmetic expression over 30 stored register values using addition and subtraction.

Beyond just getting the right answer, the project is about applying digital design fundamentals in practice: synchronous logic, pipelining, and handling data hazards without stalling the processor.

> **Result:** the final design computes `R1 + R2 − R3 − R4 + R5 + R6 − … + R29 + R30 = 236,638` (`0x00039C5E`), writing a result back every clock cycle once the pipeline is full, with no no-ops needed.

![Microprocessor layout](assets/images/Layout.png)

## Contents

- [Architecture](#architecture)
- [Instruction format](#instruction-format)
- [ALU](#alu)
- [Memory (ROM)](#memory-rom)
- [The programme](#the-programme)
- [Pipeline and the read-before-write hazard](#pipeline-and-the-read-before-write-hazard)
- [Performance](#performance)
- [Limitations and future work](#limitations-and-future-work)
- [Repository layout](#repository-layout)
- [Running the simulation](#running-the-simulation)
- [What I learned](#what-i-learned)

## Architecture

| Component | File | Role |
|-----------|------|------|
| Instruction Queue | `InstructionQueue.vhd` | Stores the programme and issues one 32-bit instruction per clock cycle |
| Decoder | `decoder.vhd` | Splits an instruction into opcode and three 5-bit addresses |
| Controller | `controller.vhd` | Detects data hazards, drives the forwarding signals and pipelines the opcode |
| ROM | `ROM.vhd` | 32 × 32-bit register store with two read ports, a third address for write-back, and address pipelining |
| ALU | `Alu.vhd` | 32-bit arithmetic/logic unit with forwarding of its own previous result |
| Microprocessor | `Microprocessor.vhd` | Top level that wires everything together and exposes debug signals |
| Testbench | `Testbench.vhd` | 500 MHz clock and a full set of probe signals for the waveform viewer |

The flow of one instruction is: **fetch** from the queue → **decode** into opcode and addresses → **read** two operands from the ROM → **execute** in the ALU → **write back** to the ROM.

## Instruction format

Each instruction is 32 bits wide. Only the top 21 bits are used.

| Bits | Field | Meaning |
|------|-------|---------|
| 31 – 26 | `opcode` | ALU operation (6 bits) |
| 25 – 21 | `A1` | Register for operand `a` |
| 20 – 16 | `A2` | Register for operand `b` |
| 15 – 11 | `A3` | Destination register |
| 10 – 0 | – | Unused (zero) |

In other words, an instruction means **`A1 <opcode> A2 → A3`**. For example, `0x10220000` decodes to opcode `000100` (add), `A1 = 1`, `A2 = 2`, `A3 = 0`, i.e. `R1 + R2 → R0`.

## ALU

The ALU has two 32-bit inputs, `a` and `b`, a 6-bit opcode and a 32-bit result. An unknown opcode outputs `0`.

| Operation | Denary | Binary |
|-----------|:------:|:------:|
| `a + b` | 4 | `000100` |
| `a − b` | 8 | `001000` |
| `\|a\|` | 11 | `001011` |
| `−a` | 10 | `001010` |
| `\|b\|` | 14 | `001110` |
| `−b` | 6 | `000110` |
| `a or b` | 7 | `000111` |
| `not a` | 9 | `001001` |
| `not b` | 15 | `001111` |
| `a and b` | 2 | `000010` |
| `a xor b` | 3 | `000011` |

The ALU also takes two forwarding flags, `FLa` and `FLb`. When one is set, the corresponding operand is replaced by the ALU's own previous result (see [below](#pipeline-and-the-read-before-write-hazard)).

## Memory (ROM)

The ROM holds 32 registers of 32 bits, initialised with the values below. It has:

- two read addresses (`A1`, `A2`), each with **one pipeline stage**, so operands reach the ALU one clock cycle after the addresses are decoded;
- a third address (`A3`) for write-back, delayed through **pipeline registers** so the write lands when the ALU result is ready, two clock cycles after the operands were passed to the ALU.

<details>
<summary>Initial register values</summary>

| Register | Denary | Hexadecimal |
|:--------:|-------:|-------------|
| 0 | 0 | `00000000` |
| 1 | 70536 | `00011388` |
| 2 | 42658 | `0000A6A2` |
| 3 | 67141 | `00010645` |
| 4 | 25998 | `0000658E` |
| 5 | 86650 | `0001527A` |
| 6 | 64211 | `0000FAD3` |
| 7 | 56067 | `0000DB03` |
| 8 | 40159 | `00009CDF` |
| 9 | 69723 | `0001105B` |
| 10 | 28861 | `000070BD` |
| 11 | 59537 | `0000E891` |
| 12 | 33726 | `000083BE` |
| 13 | 23913 | `00005D69` |
| 14 | 35711 | `00008B7F` |
| 15 | 85087 | `00014C5F` |
| 16 | 22853 | `00005945` |
| 17 | 72191 | `000119FF` |
| 18 | 87837 | `0001571D` |
| 19 | 5042 | `000013B2` |
| 20 | 84884 | `00014B94` |
| 21 | 22842 | `0000593A` |
| 22 | 77156 | `00012D64` |
| 23 | 17363 | `000043D3` |
| 24 | 87296 | `00015500` |
| 25 | 45117 | `0000B03D` |
| 26 | 91034 | `0001639A` |
| 27 | 73021 | `00011D3D` |
| 28 | 56444 | `0000DC7C` |
| 29 | 53900 | `0000D28C` |
| 30 | 78916 | `00013444` |
| 31 | 0 | `00000000` |

</details>

## The programme

The task is to evaluate

```
R1 + R2 − R3 − R4 + R5 + R6 − … + R29 + R30
```

which is 30 operands combined by 29 instructions. The Instruction Queue stores these as a constant array and issues one per clock cycle. Once the programme is exhausted it issues an invalid opcode, which the ALU turns into `0`.

Two programmes were written for this task:

1. **In-order programme** (final design, `src/Part 3 #2`): runs the expression exactly as written, which alternates between pairs of additions and pairs of subtractions. This is the harder case for the hardware, because consecutive instructions keep reading and writing `R0`.
2. **Split-accumulator programme** (`src/part 3/programme.vhd`): first adds all the positive terms into `R0` (`R0 + R1 → R0`, `R0 + R2 → R0`, …), then adds all the terms to be subtracted into `R31` (`R31 + R3 → R31`, …), and finally combines the two accumulators with a single subtraction. Subtraction is the more expensive operation, so this uses only one. It works because `R0` and `R31` are the only two registers whose stored value is not needed for the calculation.

## Pipeline and the read-before-write hazard

![Waveform showing forwarding](assets/images/Waveform1.png)

Both programmes write to `R0` or `R31` almost every instruction. Because the ROM writes back **two clock cycles** after operands reach the ALU, the next two instructions could read a stale value from the register. This is a classic read-after-write (RAW) data hazard.

The **controller** solves it with forwarding rather than stalling:

- It taps the same instruction stream as the decoder and compares the destination address (`A3`) of the instruction in flight against the source addresses (`A1`, `A2`) of the instructions following it.
- If a source matches, it raises `FLa` or `FLb`, and the ALU substitutes its **previous result** for that operand instead of the (outdated) value coming from the ROM.
- The ROM keeps writing back on its normal two-cycle delay, so memory stays correct, but the freshest result is always available to the ALU.
- The opcode is also routed through the controller rather than straight from the decoder, so it is pipelined in step with the operand addresses.

The main advantage is that **no no-ops are needed** and there is no stall/halt signalling. The processor just keeps going with what it has.

## Performance

![Simulation](assets/images/Simulation1.png)

| Metric | Value |
|--------|-------|
| Clock | 500 MHz (2 ns period) |
| Time to write the final result to memory | 71 ns (about 35 clock cycles; the system is undefined for the first nanosecond) |
| Latency of a single instruction | 10 ns (5 clock cycles) |
| Steady-state throughput | 1 instruction / clock cycle |
| Estimate with no-ops instead of forwarding | about 60 clock cycles (120 ns), almost 3× slower |

Without forwarding or no-ops, the design would produce the wrong answer. Forwarding saves roughly a third of the run time compared with inserting no-ops, at the cost of a longer wait for the first result.

## Limitations and future work

The design passes two of the three test programmes. Forwarding only covers a hazard with the instruction(s) immediately before, so it does **not** handle:

- alternating between addition and subtraction **every** cycle, or
- alternating between two destination registers (for example `R0` and `R31`) every cycle.

Ideas for improving it:

- **Extend the dirty list** so the controller checks further back than two instruction cycles. This would also need priority logic for when several in-flight instructions target the same register, and further testing to confirm the ALU correctly prefers the forwarded result over the memory value.
- **Functional no-ops**, so even the worst-case programme still gives the right answer, regardless of efficiency.
- **Smart re-ordering** of the instruction stream to turn a problem programme into one the hardware already handles.

## Repository layout

```
Microprocessor.HDL/
├── assets/images/         Layout, waveform and simulation screenshots
└── src/
    ├── part 1/            ALU, ROM and a first top level, each with a testbench
    ├── part 2/            Adds the decoder
    ├── part 3/            Adds a programme/instruction source (split-accumulator programme)
    ├── Part 3 #2/         Final design: queue, decoder, controller, ROM, ALU, top level, testbench
    └── romtestbench3.bde  Block-design file for the ROM testbench
```

The design was built up in stages, so `src/Part 3 #2` is the one to read and run.

## Running the simulation

The sources use the Synopsys `std_logic_signed` / `std_logic_unsigned` packages, so with GHDL you need `-fsynopsys`:

```bash
cd "src/Part 3 #2"

ghdl -a --std=08 -fsynopsys -frelaxed \
  Alu.vhd InstructionQueue.vhd ROM.vhd decoder.vhd controller.vhd Microprocessor.vhd Testbench.vhd
ghdl -e --std=08 -fsynopsys -frelaxed Testbench
ghdl -r --std=08 -fsynopsys -frelaxed Testbench --stop-time=200ns --vcd=wave.vcd

gtkwave wave.vcd
```

You will see `CONV_INTEGER` warnings at 1 ns. These are expected: signals are undefined until the first clock edge. Watch `Result_Signal` to see the running total, and `FLA_Signal` / `FLB_Signal` to see forwarding fire. Any other VHDL simulator (ModelSim/Questa, Active-HDL, Vivado) should work too, with `Testbench` as the top level and a 500 MHz clock.

## What I learned

The biggest lesson was to **expose internal signals from the testbench from day one**. Being able to see addresses, pipeline stages and forwarding flags at any point in the circuit made debugging dramatically faster, and I lost too much time before adding them.

## Related

A SystemVerilog re-implementation of this design is in progress in the `microprocessor-verilog` repository.
