# UART RX — SKY130HD Post-Route STA

# Load timing library and routed design
read_liberty /work/ORFS/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_db /work/UART_RX/pd/uart_rx_detailed_route.odb

# Load timing constraints
read_sdc /work/UART_RX/pd/uart_rx_post_cts_repaired.sdc
set_propagated_clock [all_clocks]

# Extract parasitics from routed interconnect
extract_parasitics \
    -ext_model_file /work/ORFS/flow/platforms/sky130hd/rcx_patterns.rules

write_spef /work/UART_RX/sta/uart_rx_post_route.spef

# Report timing constraints
puts "\n========== TIMING CONSTRAINT CHECK =========="
check_setup -verbose

# Report setup timing
puts "\n========== POST-ROUTE SETUP SLACK =========="
report_worst_slack -max
report_checks -path_delay max

# Report hold timing
puts "\n========== POST-ROUTE HOLD SLACK =========="
report_worst_slack -min
report_checks -path_delay min

# Check electrical violations
puts "\n========== ELECTRICAL VIOLATIONS =========="
report_check_types -max_slew -max_capacitance -max_fanout -violators

puts "\n========== POST-ROUTE STA COMPLETED =========="
