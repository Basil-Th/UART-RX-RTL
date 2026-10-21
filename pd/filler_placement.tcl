# UART RX — SKY130HD Filler Cell Placement

# Load the detailed-routed design
read_db /work/UART_RX/pd/uart_rx_detailed_route.odb

# Insert SKY130HD filler cells into available placement gaps
filler_placement \
    -prefix FILL_ \
    -verbose \
    {sky130_fd_sc_hd__fill_8 sky130_fd_sc_hd__fill_4 sky130_fd_sc_hd__fill_2 sky130_fd_sc_hd__fill_1}

# Save the filled design
write_db /work/UART_RX/pd/uart_rx_filled.odb

puts "\n========== FILLER PLACEMENT COMPLETED =========="
