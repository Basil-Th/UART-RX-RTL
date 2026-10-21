# UART RX - Detailed Placement

# Technology: SKY130HD
# Load SKY130HD timing library
read_liberty /work/ORFS/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# Load global-placement database
read_db /work/UART_RX/pd/uart_rx_global_place.odb

# Load timing constraints
read_sdc /work/UART_RX/sta/uart_rx.sdc

# Load SKY130HD RC parameters
source /work/ORFS/flow/platforms/sky130hd/setRC.tcl

# Legalize standard-cell placement
detailed_placement

# Optimize cell orientations
optimize_mirroring

# Check placement legality
check_placement -verbose

# Estimate parasitics using placement
estimate_parasitics -placement

# Report area
report_design_area

# Save detailed-placement database
write_db /work/UART_RX/pd/uart_rx_detail_place.odb
