`timescale 1ns/1ps
module UART_8N1_RX(
input RX,
input clk,
input rst,
output reg [7:0] data
 );
 reg [1:0] STATE;
 reg rff1;
 reg rff2;
 reg [7:0] data_reg;
 reg [13:0] baud_counter;
 reg [3:0] bit_counter;
 
 localparam IDLE = 2'b00;
 localparam START = 2'b01;
 localparam DATA = 2'b10;
 localparam STOP = 2'b11; 
 
 always @(posedge clk or posedge rst) begin
     if (rst) begin
        STATE <= IDLE;
        baud_counter <= 14'b0;
        bit_counter <= 4'b0;
        rff1 <= 1'b1;
        rff2 <= 1'b1;
        data_reg <= 8'b0;
        data <= 8'b0;
     end
     else begin
        rff1 <= RX;
        rff2 <= rff1;
        case (STATE)
            IDLE : begin
                
                if (rff2 == 0) begin
                    STATE <= START;
                    baud_counter <= 14'b0;
                    bit_counter <= 4'b0;
                end
                else begin
                    STATE <= IDLE;
                end
            end
            START : begin
                if (baud_counter == 2603) begin
                    if (rff2 == 0) begin
                        baud_counter <= 14'b0;
                        bit_counter <= 4'b0;
                        STATE <= DATA;                     
                    end
                    else begin
                        STATE <= IDLE;
                    end   
                end
                else begin
                    baud_counter <= baud_counter + 1;
                end 
            end 
            DATA : begin
                if (bit_counter == 8) begin
                    STATE <= STOP;
                    baud_counter <= 14'b0;
                    bit_counter <= 4'b0;   
                end
                else begin
                    
                    if (baud_counter == 5207) begin
                        data_reg <= {rff2, data_reg[7:1]};
                        bit_counter <= bit_counter + 1;
                        baud_counter <= 14'b0; 
                    end
                    else begin
                        baud_counter <= baud_counter + 1;
                    end
                end
            end   
            STOP : begin
                if (baud_counter == 5207) begin
                    baud_counter <= 14'b0;
                    if (rff2 == 1) begin
                        data <= data_reg;
                    end 
                    STATE <= IDLE;   
                end
                else begin
                    baud_counter <= baud_counter + 1;
                end
            end
            default begin
                baud_counter <= 14'b0;
                bit_counter <= 4'b0;
                STATE <= IDLE;
                
            end
        
        endcase
     end
 end
endmodule
