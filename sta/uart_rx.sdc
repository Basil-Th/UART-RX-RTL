# UART RX - Static Timing Constraints

# System clock: 50 MHz = 20 ns period
create_clock -name clk -period 20.0 [get_ports clk]

# RX is asynchronous to the local system clock.
# Its CDC entry path is excluded from conventional synchronous STA.
set_false_path -from [get_ports RX]

# Design assumption for standalone UART RX block:
# reserve 5 ns for downstream external logic.
set_output_delay -max 5.0 -clock clk [get_ports {data[*]}]
