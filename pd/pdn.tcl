# UART RX - Power Distribution Network
# Technology: SKY130HD

# ---------------------------------------------------------
# 1. Load tap-cell floorplan database
# ---------------------------------------------------------

read_db /work/UART_RX/pd/uart_rx_tapcell.odb

# ---------------------------------------------------------
# 2. Read timing constraints
# ---------------------------------------------------------

read_sdc /work/UART_RX/sta/uart_rx.sdc

# ---------------------------------------------------------
# 3. Load SKY130HD PDN configuration
# ---------------------------------------------------------

source /work/ORFS/flow/platforms/sky130hd/pdn.tcl

# ---------------------------------------------------------
# 4. Generate power distribution network
# ---------------------------------------------------------

pdngen

# ---------------------------------------------------------
# 5. Report design area
# ---------------------------------------------------------

report_design_area

# ---------------------------------------------------------
# 6. Save PDN database
# ---------------------------------------------------------

write_db /work/UART_RX/pd/uart_rx_pdn.odb
