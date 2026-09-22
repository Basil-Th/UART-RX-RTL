module UART_8N1_RX_sva (
    input wire clk,
    input wire [1:0] STATE,
    input wire [3:0] bit_counter
);
always @(posedge clk) begin
    if (STATE == 2'b10) begin
        assert (bit_counter <= 4'd8)
            else $error("ASSERTION FAILED: bit_counter exceeded 8 in DATA state");
    end
end

endmodule
bind UART_8N1_RX UART_8N1_RX_sva sva_inst (
    .clk(clk),
    .STATE(STATE),
    .bit_counter(bit_counter)
);

