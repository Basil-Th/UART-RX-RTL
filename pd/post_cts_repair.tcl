# =====================================================
# UART RX - Post-CTS Electrical Repair
# Technology: SKY130HD
# =====================================================

# 1. Load timing library
read_liberty /work/ORFS/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# 2. Load completed CTS database
read_db /work/UART_RX/pd/uart_rx_cts.odb

# 3. Load post-CTS constraints
read_sdc /work/UART_RX/pd/uart_rx_cts.sdc

# 4. Configure SKY130HD wire RC
source /work/ORFS/flow/platforms/sky130hd/setRC.tcl

# 5. Estimate placement-based parasitics
estimate_parasitics -placement

# 6. Confirm propagated clock analysis
set_propagated_clock [all_clocks]

# 7. Repair slew, capacitance and related electrical issues
puts "\n========== ELECTRICAL REPAIR =========="
repair_design -verbose

# 8. Legalize any inserted or resized cells
detailed_placement

# 9. Verify placement legality
check_placement -verbose

# 10. Update estimated parasitics after placement changes
estimate_parasitics -placement

# 11. Recheck electrical violations
puts "\n========== ELECTRICAL VIOLATIONS AFTER REPAIR =========="
report_check_types \
    -max_slew \
    -max_capacitance \
    -max_fanout \
    -violators

# 12. Recheck timing
puts "\n========== TIMING AFTER REPAIR =========="
report_worst_slack -max
report_worst_slack -min

# 13. Save a separate checkpoint
write_db /work/UART_RX/pd/uart_rx_post_cts_repaired.odb
write_sdc /work/UART_RX/pd/uart_rx_post_cts_repaired.sdc
