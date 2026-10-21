# UART RX - Global Placement
# Technology: SKY130HD

# ---------------------------------------------------------
# 1. Load PDN database
# ---------------------------------------------------------

read_db /work/UART_RX/pd/uart_rx_pdn.odb

# ---------------------------------------------------------
# 2. Read timing constraints
# ---------------------------------------------------------

read_sdc /work/UART_RX/sta/uart_rx.sdc

# ---------------------------------------------------------
# 3. Perform global placement
# ---------------------------------------------------------

global_placement \
    -density 0.60 \
    -force_center_initial_place

# ---------------------------------------------------------
# 4. Estimate parasitics from placement
# ---------------------------------------------------------

estimate_parasitics -placement

# ---------------------------------------------------------
# 5. Report design area
# ---------------------------------------------------------

report_design_area

# ---------------------------------------------------------
# 6. Save global-placement database
# ---------------------------------------------------------

write_db /work/UART_RX/pd/uart_rx_global_place.odb
