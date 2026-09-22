RTL = rtl/UART_8N1_RX.v
TB  = tb/UART_8N1_RX_tb.v
TOP = UART_8N1_RX_tb
SVA = tb/UART_8N1_RX_sva.sv

VERILATOR = verilator

lint:
	$(VERILATOR) --lint-only --timing -Wall $(RTL) $(TB) $(SVA)

build:
	$(VERILATOR) --binary --timing --trace --assert --top-module $(TOP) $(RTL) $(TB) $(SVA)

run:
	./obj_dir/V$(TOP)

sim: build run

clean:
	rm -rf obj_dir uart_rx.vcd
