# =====================================================
# UART RX - Post-CTS Static Timing Analysis
# Technology: SKY130HD
# =====================================================

# 1. Load the timing library
read_liberty /work/ORFS/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# 2. Load the CTS database
read_db /work/UART_RX/pd/uart_rx_cts.odb

# 3. Load the CTS timing constraints
read_sdc /work/UART_RX/pd/uart_rx_cts.sdc

# 4. Load SKY130HD wire RC parameters
source /work/ORFS/flow/platforms/sky130hd/setRC.tcl

# 5. Estimate placement-based parasitics
estimate_parasitics -placement

# 6. Enable propagated clock analysis
set_propagated_clock [all_clocks]

# 7. Check timing constraints
check_setup -verbose

# 8. Report setup timing
puts "\n========== SETUP TIMING =========="
report_checks -path_delay max \
    -fields {slew cap input_pin} \
    -digits 3

# 9. Report hold timing
puts "\n========== HOLD TIMING =========="
report_checks -path_delay min \
    -fields {slew cap input_pin} \
    -digits 3

# 10. Report timing violations
puts "\n========== ELECTRICAL VIOLATIONS =========="
report_check_types \
    -max_slew \
    -max_capacitance \
    -max_fanout \
    -violators

# 11. Report worst setup and hold slack
puts "\n========== WORST SLACK =========="
report_worst_slack -max
report_worst_slack -min
