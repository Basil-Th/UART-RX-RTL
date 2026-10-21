# UART RX - Initial Floorplan
# Technology: SKY130HD

# ---------------------------------------------------------
# 1. Read technology and standard-cell LEFs
# ---------------------------------------------------------

read_lef /work/ORFS/flow/platforms/sky130hd/lef/sky130_fd_sc_hd.tlef
read_lef /work/ORFS/flow/platforms/sky130hd/lef/sky130_fd_sc_hd_merged.lef

# ---------------------------------------------------------
# 2. Read timing library
# ---------------------------------------------------------

read_liberty /work/ORFS/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# ---------------------------------------------------------
# 3. Read mapped gate-level netlist
# ---------------------------------------------------------

read_verilog /work/UART_RX/synth/UART_8N1_RX_sky130.v

# ---------------------------------------------------------
# 4. Link top-level design
# ---------------------------------------------------------

link_design UART_8N1_RX

# ---------------------------------------------------------
# 5. Read timing constraints
# ---------------------------------------------------------

read_sdc /work/UART_RX/sta/uart_rx.sdc

# ---------------------------------------------------------
# 6. Initialize floorplan
# ---------------------------------------------------------

initialize_floorplan \
    -die_area  {0 0 80 80} \
    -core_area {5 5 75 75} \
    -site unithd
# ---------------------------------------------------------
# 7. Create SKY130HD routing tracks
# ---------------------------------------------------------

source /work/ORFS/flow/platforms/sky130hd/make_tracks.tcl

# ---------------------------------------------------------
# 8. Report basic design information
# ---------------------------------------------------------

report_design_area

# ---------------------------------------------------------
# 9. Save OpenROAD database
# ---------------------------------------------------------

write_db /work/UART_RX/pd/uart_rx_floorplan.odb
