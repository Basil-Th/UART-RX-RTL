RTL = rtl/UART_8N1_RX.v
TB  = tb/UART_8N1_RX_tb.v
TOP = UART_8N1_RX_tb

VERILATOR = verilator

lint:
	$(VERILATOR) --lint-only --timing -Wall $(RTL) $(TB)

build:
	$(VERILATOR) --binary --timing --trace --top-module $(TOP) $(RTL) $(TB)

run:
	./obj_dir/V$(TOP)

sim: build run

clean:
	rm -rf obj_dir uart_rx.vcd
