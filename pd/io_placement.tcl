# UART RX - I/O Pin Placement
# Technology: SKY130HD

# ---------------------------------------------------------
# 1. Load completed floorplan database
# ---------------------------------------------------------

read_db /work/UART_RX/pd/uart_rx_floorplan.odb

# ---------------------------------------------------------
# 2. Place block I/O pins
# ---------------------------------------------------------

place_pins \
    -hor_layers met3 \
    -ver_layers met2

# ---------------------------------------------------------
# 3. Report design area
# ---------------------------------------------------------

report_design_area

# ---------------------------------------------------------
# 4. Save I/O placement database
# ---------------------------------------------------------

write_db /work/UART_RX/pd/uart_rx_io.odb

# ---------------------------------------------------------
# 5. Save pin placement as Tcl
# ---------------------------------------------------------

write_pin_placement /work/UART_RX/pd/uart_rx_io_pins.tcl
