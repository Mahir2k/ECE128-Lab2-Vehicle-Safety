# ECE 128 Lab 4: Vehicle Safety Interlock and Warning System

This project implements a combinational vehicle safety system on a Basys3 FPGA. Sixteen switches represent vehicle conditions, and the LEDs display start permission and warnings. The same logic is written in three Verilog modeling styles: dataflow, behavioral, and structural.

## Files

| File | Purpose |
| --- | --- |
| `vehicle_safety_dataflow.v` | Dataflow implementation |
| `vehicle_safety_behavioral.v` | Behavioral implementation |
| `vehicle_safety_structural.v` | Structural gate-level implementation |
| `tb_vehicle_safety.v` | Directed checks and comparison of all three versions |
| `basys3_vehicle_safety.xdc` | Basys3 switch and LED pin constraints |

## Input and output map

| Switch | Condition | LED | Output |
| --- | --- | --- | --- |
| SW15 | Driver belt fastened | LED15 | Start permitted |
| SW14 | Door closed | LED14 | Chime indication |
| SW13 | Key inserted | LED13 | Priority 2 warning |
| SW12 | Brake pressed | LED12 | Priority 1 warning |
| SW11 | Gear in Park | LED11 | Seatbelt warning |
| SW10 | Hood closed | LED10 | Door warning |
| SW9 | Battery OK | LED9 | Hood warning |
| SW8 | Airbag OK | LED8 | Trunk warning |
| SW7 | Temperature OK | LED7 | Battery warning |
| SW6 | Passenger present | LED6 | Airbag warning |
| SW5 | Passenger belt fastened | LED5 | Temperature warning |
| SW4 | Trunk closed | LED4–LED0 | Unused |
| SW3 | Parking brake engaged | | |
| SW2 | Service mode | | |

SW1 and SW0 do not affect the logic. Service mode bypasses the seatbelt requirement for start permission; warning LEDs remain active.

## Vivado setup

1. Create an RTL project for the Basys3 part `xc7a35tcpg236-1`.
2. Add the three `vehicle_safety_*.v` files as **design sources**.
3. Add `tb_vehicle_safety.v` as a **simulation source**.
4. Add `basys3_vehicle_safety.xdc` as a **constraint source**.
5. Set `vehicle_safety_dataflow` as the design top and `tb_vehicle_safety` as the simulation top.
6. Run Behavioral Simulation. The console should print `PASS: directed checks and all 16384 model comparisons`.
7. Run synthesis, implementation, and bitstream generation to program the Basys3. To compare resource usage, repeat synthesis and implementation with each of the other design modules as top.

## Results

The directed simulation checks passed. The three implementations agreed for all 16,384 combinations of SW15–SW2. In the measured implementations, each modeling style used **10 Slice LUTs and 7 slices**. The behavioral utilization report confirmed **0 flip-flops**, as expected for combinational logic.

The healthy board case used `SW = FFB8` and produced `LED = 8000`. Driver-belt, service-mode, battery-fault, and parking-brake cases were also checked on the board.
