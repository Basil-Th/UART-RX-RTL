###############################################################################
# Created by write_sdc
# Wed Oct 14 12:36:29 2026
###############################################################################
current_design UART_8N1_RX
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 20.0000 [get_ports {clk}]
set_propagated_clock [get_clocks {clk}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -max -add_delay [get_ports {data[0]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -max -add_delay [get_ports {data[0]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -max -add_delay [get_ports {data[1]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -max -add_delay [get_ports {data[1]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -max -add_delay [get_ports {data[2]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -max -add_delay [get_ports {data[2]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -max -add_delay [get_ports {data[3]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -max -add_delay [get_ports {data[3]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -max -add_delay [get_ports {data[4]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -max -add_delay [get_ports {data[4]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -max -add_delay [get_ports {data[5]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -max -add_delay [get_ports {data[5]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -max -add_delay [get_ports {data[6]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -max -add_delay [get_ports {data[6]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -max -add_delay [get_ports {data[7]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -max -add_delay [get_ports {data[7]}]
set_false_path\
    -from [get_ports {RX}]
###############################################################################
# Environment
###############################################################################
###############################################################################
# Design Rules
###############################################################################
