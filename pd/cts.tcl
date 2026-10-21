# =====================================================
# UART RX - Clock Tree Synthesis (CTS)
# Technology: SKY130HD
# =====================================================

# 1. Load the standard-cell timing library
read_liberty /work/ORFS/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# 2. Load the detailed-placement database
read_db /work/UART_RX/pd/uart_rx_detail_place.odb

# 3. Load timing constraints
read_sdc /work/UART_RX/sta/uart_rx.sdc

# 4. Configure estimated wire resistance and capacitance
source /work/ORFS/flow/platforms/sky130hd/setRC.tcl

# 5. Repair clock inverters before CTS
repair_clock_inverters

# 6. Perform Clock Tree Synthesis
clock_tree_synthesis \
    -buf_list {
        sky130_fd_sc_hd__clkbuf_1
        sky130_fd_sc_hd__clkbuf_2
        sky130_fd_sc_hd__clkbuf_4
        sky130_fd_sc_hd__clkbuf_8
        sky130_fd_sc_hd__clkbuf_16
    } \
    -sink_clustering_enable \
    -repair_clock_nets

# 7. Legalize newly inserted clock buffers
detailed_placement

# 8. Check placement legality
check_placement -verbose

# 9. Estimate parasitics using placement
estimate_parasitics -placement

# 10. Report design area
report_design_area

# 11. Save the CTS database
write_db /work/UART_RX/pd/uart_rx_cts.odb

# 12. Save updated timing constraints
write_sdc /work/UART_RX/pd/uart_rx_cts.sdc
