# UART RX — SKY130HD Global Routing

# Load technology timing information and repaired post-CTS design
read_liberty /work/ORFS/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_db /work/UART_RX/pd/uart_rx_post_cts_repaired.odb
read_sdc /work/UART_RX/pd/uart_rx_post_cts_repaired.sdc

# Configure routing layers
set_routing_layers -signal met1-met5 -clock met3-met5

# Configure estimated interconnect parasitics
source /work/ORFS/flow/platforms/sky130hd/setRC.tcl
set_propagated_clock [all_clocks]

# Run global routing and save routing guides
global_route \
    -guide_file /work/UART_RX/pd/uart_rx.route_guide \
    -verbose

# Save global-routing checkpoint
write_db /work/UART_RX/pd/uart_rx_global_route.odb

puts "\n========== GLOBAL ROUTING COMPLETED =========="
