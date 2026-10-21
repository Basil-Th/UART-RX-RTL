# UART RX - Tap Cell Insertion
# Technology: SKY130HD

# ---------------------------------------------------------
# 1. Load I/O placement database
# ---------------------------------------------------------

read_db /work/UART_RX/pd/uart_rx_io.odb

# ---------------------------------------------------------
# 2. Insert SKY130HD tap cells
# ---------------------------------------------------------

tapcell \
    -distance 14 \
    -tapcell_master sky130_fd_sc_hd__tapvpwrvgnd_1

# ---------------------------------------------------------
# 3. Report updated design area
# ---------------------------------------------------------

report_design_area

# ---------------------------------------------------------
# 4. Save database
# ---------------------------------------------------------

write_db /work/UART_RX/pd/uart_rx_tapcell.odb
