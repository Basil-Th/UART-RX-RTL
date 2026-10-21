# UART RX — SKY130HD Detailed Routing

# Load technology timing library and globally routed design
read_liberty /work/ORFS/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_db /work/UART_RX/pd/uart_rx_global_route.odb

# Load global routing guides
read_guides /work/UART_RX/pd/uart_rx.route_guide

# Configure routing layers
set_routing_layers -signal met1-met5 -clock met3-met5

# Perform detailed routing
detailed_route \
    -output_drc /work/UART_RX/pd/uart_rx_droute_drc.rpt \
    -verbose 1

# Save routed design
write_db /work/UART_RX/pd/uart_rx_detailed_route.odb

puts "\n========== DETAILED ROUTING COMPLETED =========="
