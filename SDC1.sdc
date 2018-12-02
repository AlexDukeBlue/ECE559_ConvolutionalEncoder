create_clock -name clk50 -period 20.000 -waveform {0 10} [get_ports {clk50}]
derive_clock_uncertainty