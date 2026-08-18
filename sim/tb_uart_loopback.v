`timescale 1ns / 1ps
module tb_uart_loopback;

    reg clk;
    reg rst_n;
    reg  [7:0] tx_data;
    reg        tx_start_n;

    wire tx_busy;
    wire tx_done;
    wire rx_busy;
    wire [7:0] rx_data;
    wire rx_done;
    wire frame_error;

    integer errors;
    integer i;

    uart_loopback dut (
        .clk         (clk),
        .rst_n       (rst_n),
        .tx_data     (tx_data),
        .tx_start_n  (tx_start_n),
        .tx_busy     (tx_busy),
        .tx_done     (tx_done),
        .rx_busy     (rx_busy),
        .rx_data     (rx_data),
        .rx_done     (rx_done),
        .frame_error (frame_error)
    );

    initial clk = 1'b0;
    always #10 clk = ~clk;

    task send_and_check(input [7:0] data);
        begin
            @(posedge clk);
            tx_data    = data;
            tx_start_n = 1'b0;
            @(posedge clk);
            tx_start_n = 1'b1;

            @(posedge tx_done);
            $display("[%0t] TX done, byte=0x%02h", $time, data);

            @(posedge rx_done);
            $display("[%0t] RX done, rx_data=0x%02h frame_error=%b",
                      $time, rx_data, frame_error);

            if (rx_data !== data) begin
                $display("  ** FAIL: expected 0x%02h, got 0x%02h", data, rx_data);
                errors = errors + 1;
            end else if (frame_error !== 1'b0) begin
                $display("  ** FAIL: unexpected frame_error on 0x%02h", data);
                errors = errors + 1;
            end else begin
                $display("  PASS");
            end

            repeat (50) @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("tb_uart_loopback.vcd");
        $dumpvars(0, tb_uart_loopback);

        errors     = 0;
        rst_n      = 1'b0;
        tx_data    = 8'h00;
        tx_start_n = 1'b1;

        repeat (5) @(posedge clk);
        rst_n = 1'b1;
        repeat (5) @(posedge clk);

        send_and_check(8'h00);
        send_and_check(8'hFF);
        send_and_check(8'hA5);
        send_and_check(8'h5A);
        send_and_check(8'h55);
        send_and_check(8'h01);

        for (i = 0; i < 4; i = i + 1) begin
            send_and_check($random & 8'hFF);
        end

        if (errors == 0)
            $display("\n==== ALL TESTS PASSED ====\n");
        else
            $display("\n==== %0d TEST(S) FAILED ====\n", errors);

        $finish;
    end

    initial begin
        #50_000_000;
        $display("** TIMEOUT: simulation did not finish in time **");
        $finish;
    end

endmodule
