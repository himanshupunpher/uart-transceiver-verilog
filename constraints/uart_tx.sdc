# uart_tx.sdc
# Timing constraint for the DE0-Nano's 50 MHz onboard oscillator.
# Without this, Quartus's Timing Analyzer defaults to an unconstrained/
# fictitious 1 GHz clock and reports failing setup timing.

create_clock -period 20.000 -name clk [get_ports clk]
derive_clock_uncertainty
