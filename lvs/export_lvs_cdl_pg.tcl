# UART RX - LVS reference with power connections

read_db /work/UART_RX/pd/uart_rx_filled.odb

set block [ord::get_db_block]
set inst [$block findInst clkbuf_0_clk]

if {$inst eq "NULL"} {
    error "Clock buffer not found"
}

proc show_pg_pins {inst} {
    foreach iterm [$inst getITerms] {
        set mterm [$iterm getMTerm]
        set pin [$mterm getName]

        if {$pin ni {VGND VNB VPB VPWR}} {
            continue
        }

        set net [$iterm getNet]

        if {$net eq "NULL"} {
            puts "$pin -> UNCONNECTED"
        } else {
            puts "$pin -> [$net getName]"
        }
    }
}

puts "\n=== BEFORE GLOBAL CONNECT ==="
show_pg_pins $inst

# SKY130 standard-cell power connections
add_global_connection -net VDD -pin_pattern {^VPWR$} -power
add_global_connection -net VDD -pin_pattern {^VPB$} -power

add_global_connection -net VSS -pin_pattern {^VGND$} -ground
add_global_connection -net VSS -pin_pattern {^VNB$} -ground

global_connect -verbose

puts "\n=== AFTER GLOBAL CONNECT ==="
show_pg_pins $inst

set master_cdl /work/ORFS/flow/platforms/sky130hd/cdl/sky130hd.cdl
set output_cdl /work/UART_RX/lvs/uart_rx_pg_connected.cdl

write_cdl -masters [list $master_cdl] $output_cdl

puts "\nCorrected reference CDL generated:"
puts $output_cdl
