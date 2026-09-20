`timescale 1ns/1ps

module UART_8N1_RX_tb;

    //============================================================
    // DUT SIGNALS
    //============================================================

    reg         clk;
    reg         rst;
    reg         RX;

    wire [7:0]   data;


    //============================================================
    // TEST COUNTERS
    //============================================================

    integer pass_count;
    integer fail_count;


    //============================================================
    // DUT
    //============================================================

    UART_8N1_RX DUT (
        .RX   (RX),
        .clk  (clk),
        .rst  (rst),
        .data (data)
    );


    //============================================================
    // 50 MHz CLOCK
    // Period = 20 ns
    //============================================================

    /* verilator lint_off BLKSEQ */
    always #10 clk = ~clk;
    /* verilator lint_on BLKSEQ */


    //============================================================
    // UART PARAMETERS
    //============================================================

    // 50 MHz clock / 9600 baud
    // Bit time = approximately 104167 ns

    localparam BIT_TIME = 104167;


    //============================================================
    // WAVEFORM DUMP
    //============================================================

    initial begin
        $dumpfile("uart_rx.vcd");
        $dumpvars(0, UART_8N1_RX_tb);
    end


    //============================================================
    // TASK: SEND NORMAL UART BYTE
    //
    // UART:
    //
    // IDLE  = 1
    // START = 0
    // DATA  = LSB first
    // STOP  = 1
    //============================================================

    task send_uart_byte(input [7:0] tx_data);

        integer i;

        begin

            // START BIT
            RX = 1'b0;
            #(BIT_TIME);

            // DATA BITS - LSB FIRST
            for (i = 0; i < 8; i = i + 1) begin
                RX = tx_data[i];
                #(BIT_TIME);
            end

            // STOP BIT
            RX = 1'b1;
            #(BIT_TIME);

            // IDLE
            RX = 1'b1;

        end

    endtask


    //============================================================
    // TASK: SEND BYTE AND CHECK RESULT
    //============================================================

    task send_and_check(input [7:0] expected_data);

        begin

            send_uart_byte(expected_data);

            // Allow DUT to finish processing STOP bit
            #(2 * BIT_TIME);

            if (data === expected_data) begin

                $display(
                    "PASS: Expected = 0x%02h, Received = 0x%02h",
                    expected_data,
                    data
                );

                pass_count = pass_count + 1;

            end
            else begin

                $display(
                    "FAIL: Expected = 0x%02h, Received = 0x%02h",
                    expected_data,
                    data
                );

                fail_count = fail_count + 1;

            end

        end

    endtask


    //============================================================
    // TEST 11
    // BACK-TO-BACK FRAMES
    //============================================================

    task test_back_to_back;

        begin

            $display("");
            $display("------------------------------------------");
            $display("TEST 11: BACK-TO-BACK FRAMES");
            $display("------------------------------------------");

            // FRAME 1
            send_uart_byte(8'hA5);
            #(BIT_TIME);

            if (data === 8'hA5) begin

                $display("PASS: Frame 1 = 0xA5");
                pass_count = pass_count + 1;

            end
            else begin

                $display(
                    "FAIL: Frame 1 - Expected = 0xA5, Received = 0x%02h",
                    data
                );

                fail_count = fail_count + 1;

            end


            // FRAME 2
            send_uart_byte(8'h3C);
            #(BIT_TIME);

            if (data === 8'h3C) begin

                $display("PASS: Frame 2 = 0x3C");
                pass_count = pass_count + 1;

            end
            else begin

                $display(
                    "FAIL: Frame 2 - Expected = 0x3C, Received = 0x%02h",
                    data
                );

                fail_count = fail_count + 1;

            end

        end

    endtask


    //============================================================
    // TEST 12
    // RESET DURING RECEPTION
    //============================================================

    task test_reset_during_reception;

        begin

            $display("");
            $display("------------------------------------------");
            $display("TEST 12: RESET DURING RECEPTION");
            $display("------------------------------------------");


            // START BIT
            RX = 1'b0;
            #(BIT_TIME);


            // FIRST DATA BIT
            RX = 1'b1;
            #(BIT_TIME);


            // SECOND DATA BIT
            RX = 1'b0;

            // Wait half a bit
            #(BIT_TIME / 2);


            // ASSERT RESET
            rst = 1'b1;
            #(100);

            // RELEASE RESET
            rst = 1'b0;

            // Return RX to idle
            RX = 1'b1;

            #(BIT_TIME);


            // Send a completely new valid frame
            send_uart_byte(8'h5A);

            #(2 * BIT_TIME);


            if (data === 8'h5A) begin

                $display(
                    "PASS: RX recovered after reset. Received = 0x%02h",
                    data
                );

                pass_count = pass_count + 1;

            end
            else begin

                $display(
                    "FAIL: RX recovery after reset. Expected = 0x5A, Received = 0x%02h",
                    data
                );

                fail_count = fail_count + 1;

            end

        end

    endtask


    //============================================================
    // TEST 13
    // FALSE START
    //============================================================

    task test_false_start;

        reg [7:0] old_data;

        begin

            $display("");
            $display("------------------------------------------");
            $display("TEST 13: FALSE START");
            $display("------------------------------------------");


            old_data = data;


            // Short LOW pulse
            RX = 1'b0;

            #(BIT_TIME / 4);

            RX = 1'b1;


            // Wait for RX to recover
            #(2 * BIT_TIME);


            // Data should not change
            if (data === old_data) begin

                $display(
                    "PASS: False start rejected. Data remains = 0x%02h",
                    data
                );

                pass_count = pass_count + 1;

            end
            else begin

                $display(
                    "FAIL: False start changed data. Previous = 0x%02h, Current = 0x%02h",
                    old_data,
                    data
                );

                fail_count = fail_count + 1;

            end

        end

    endtask


    //============================================================
    // TEST 14
    // INVALID STOP BIT
    //
    // START = 0
    // DATA  = 0xA5
    // STOP  = 0  <-- INVALID
    //============================================================

   task test_invalid_stop;

    reg [7:0] old_data;
    reg [7:0] test_data;

    integer i;

    begin

        $display("");
        $display("------------------------------------------");
        $display("TEST 14: INVALID STOP BIT");
        $display("------------------------------------------");

        old_data  = data;
        test_data = 8'hA5;

        // START BIT
        RX = 1'b0;
        #(BIT_TIME);

        // DATA BITS - LSB FIRST
        for (i = 0; i < 8; i = i + 1) begin
            RX = test_data[i];
            #(BIT_TIME);
        end

        // INVALID STOP BIT
        RX = 1'b0;
        #(BIT_TIME);

        // Return to IDLE
        RX = 1'b1;
        #(2 * BIT_TIME);

        if (data === old_data) begin

            $display(
                "PASS: Invalid stop frame rejected. Data remains = 0x%02h",
                data
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: Invalid stop frame changed data. Previous = 0x%02h, Current = 0x%02h",
                old_data,
                data
            );

            fail_count = fail_count + 1;

        end

    end

endtask


    //============================================================
    // TASK: SEND BYTE WITH CUSTOM BIT TIME
    //============================================================

    task send_uart_byte_custom_bittime;

        input [7:0] tx_data;
        input integer custom_bit_time;

        integer i;

        begin

            // START
            RX = 1'b0;
            #(custom_bit_time);


            // DATA - LSB FIRST
            for (i = 0; i < 8; i = i + 1) begin

                RX = tx_data[i];
                #(custom_bit_time);

            end


            // STOP
            RX = 1'b1;
            #(custom_bit_time);


            // IDLE
            RX = 1'b1;

        end

    endtask


    //============================================================
    // TEST 15
    // BAUD-RATE VARIATION
    //
    // Nominal bit time = 104167 ns
    //
    // -2% = approximately 102084 ns
    // +2% = approximately 106250 ns
    // -3% = approximately 101042 ns
    // +3% = approximately 107292 ns
    //============================================================

    task test_baud_variation;

    integer bit_time_minus_2;
    integer bit_time_plus_2;
    integer bit_time_minus_3;
    integer bit_time_plus_3;

    begin

        $display("");
        $display("------------------------------------------");
        $display("TEST 15: BAUD-RATE VARIATION");
        $display("------------------------------------------");

        bit_time_minus_2 = 102084;
        bit_time_plus_2  = 106250;

        bit_time_minus_3 = 101042;
        bit_time_plus_3  = 107292;


        //========================================================
        // -2%
        //========================================================

        rst = 1'b1;
        RX  = 1'b1;

        #100;

        rst = 1'b0;

        #(2 * BIT_TIME);

        send_uart_byte_custom_bittime(
            8'hA5,
            bit_time_minus_2
        );

        #(2 * BIT_TIME);

        if (data === 8'hA5) begin

            $display("PASS: -2%% baud variation");

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: -2%% baud variation. Expected = 0xA5, Received = 0x%02h",
                data
            );

            fail_count = fail_count + 1;

        end


        //========================================================
        // +2%
        //========================================================

        rst = 1'b1;
        RX  = 1'b1;

        #100;

        rst = 1'b0;

        #(2 * BIT_TIME);

        send_uart_byte_custom_bittime(
            8'h3C,
            bit_time_plus_2
        );

        #(2 * BIT_TIME);

        if (data === 8'h3C) begin

            $display("PASS: +2%% baud variation");

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: +2%% baud variation. Expected = 0x3C, Received = 0x%02h",
                data
            );

            fail_count = fail_count + 1;

        end


        //========================================================
        // -3%
        //========================================================

        rst = 1'b1;
        RX  = 1'b1;

        #100;

        rst = 1'b0;

        #(2 * BIT_TIME);

        send_uart_byte_custom_bittime(
            8'h55,
            bit_time_minus_3
        );

        #(2 * BIT_TIME);

        if (data === 8'h55) begin

            $display("PASS: -3%% baud variation");

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: -3%% baud variation. Expected = 0x55, Received = 0x%02h",
                data
            );

            fail_count = fail_count + 1;

        end


        //========================================================
        // +3%
        //========================================================

        rst = 1'b1;
        RX  = 1'b1;

        #100;

        rst = 1'b0;

        #(2 * BIT_TIME);

        send_uart_byte_custom_bittime(
            8'hAA,
            bit_time_plus_3
        );

        #(2 * BIT_TIME);

        if (data === 8'hAA) begin

            $display("PASS: +3%% baud variation");

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: +3%% baud variation. Expected = 0xAA, Received = 0x%02h",
                data
            );

            fail_count = fail_count + 1;

        end

    end

endtask

    //============================================================
    // MAIN TEST SEQUENCE
    //============================================================

    initial begin

        //========================================================
        // INITIALIZATION
        //========================================================

        pass_count = 0;
        fail_count = 0;

        clk = 1'b0;
        rst = 1'b1;
        RX  = 1'b1;


        //========================================================
        // RESET
        //========================================================

        #100;

        rst = 1'b0;

        // Allow DUT to enter IDLE
        #100;


        //========================================================
        // HEADER
        //========================================================

        $display("");
        $display("==========================================");
        $display("       UART RX SELF-CHECKING TEST");
        $display("==========================================");


        //========================================================
        // BASIC FUNCTIONAL TESTS
        //========================================================

        $display("");
        $display("TEST 1: 0x00");
        send_and_check(8'h00);


        $display("");
        $display("TEST 2: 0xFF");
        send_and_check(8'hFF);


        $display("");
        $display("TEST 3: 0x55");
        send_and_check(8'h55);


        $display("");
        $display("TEST 4: 0xAA");
        send_and_check(8'hAA);


        $display("");
        $display("TEST 5: 0xA5");
        send_and_check(8'hA5);


        $display("");
        $display("TEST 6: 0x3C");
        send_and_check(8'h3C);


        $display("");
        $display("TEST 7: 0x01");
        send_and_check(8'h01);


        $display("");
        $display("TEST 8: 0x80");
        send_and_check(8'h80);


        $display("");
        $display("TEST 9: 0xC3");
        send_and_check(8'hC3);


        $display("");
        $display("TEST 10: 0x7E");
        send_and_check(8'h7E);


        //========================================================
        // ADVANCED TESTS
        //========================================================

        test_back_to_back();

        test_reset_during_reception();

        test_false_start();

        test_invalid_stop();

        test_baud_variation();


        //========================================================
        // FINAL SUMMARY
        //========================================================

        $display("");
        $display("==========================================");
        $display("             TEST SUMMARY");
        $display("==========================================");

        $display("PASS COUNT = %0d", pass_count);
        $display("FAIL COUNT = %0d", fail_count);


        if (fail_count == 0) begin

            $display("");
            $display("==========================================");
            $display("       ALL UART RX TESTS PASSED");
            $display("==========================================");

        end
        else begin

            $display("");
            $display("==========================================");
            $display("       UART RX TEST FAILED");
            $display("==========================================");

        end


        $display("");

        $finish;

    end

endmodule
