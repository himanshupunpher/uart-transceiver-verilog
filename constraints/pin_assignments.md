# Pin Assignments — DE0-Nano (Cyclone IV EP4CE22F17C6)

All I/O standard: **3.3-V LVTTL**.

| Signal | Pin | Board Function |
|---|---|---|
| `clk` | PIN_R8 | 50 MHz onboard oscillator |
| `rst_n` | PIN_J15 | KEY0 (active-low) |
| `tx_start_n` | PIN_E1 | KEY1 (active-low) |
| `tx_data[0]` | PIN_M1 | SW0 |
| `tx_data[1]` | PIN_T8 | SW1 |
| `tx_data[2]` | PIN_B9 | SW2 |
| `tx_data[3]` | PIN_M15 | SW3 |
| `tx_data[4]` | PIN_B16 | GPIO_2 header |
| `tx_data[5]` | PIN_C14 | GPIO_2 header |
| `tx_data[6]` | PIN_C16 | GPIO_2 header |
| `tx_data[7]` | PIN_C15 | GPIO_2 header |
| `tx_busy` | PIN_A15 | LED0 |
| `tx_done` | PIN_A13 | LED1 |

`tx_data[7:4]` have no onboard switch and need external jumpers/switches on the
GPIO header, or should be tied to a fixed value in the top-level for a
switch-free test.

Apply these either via the Quartus Pin Planner / Assignment Editor, or by
importing them into your project's `.qsf` file.
