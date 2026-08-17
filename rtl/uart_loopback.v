module uart_loopback (
    input clk,
    input rst_n,
    input tx_start_n,
    input [7:0] tx_data,
    output tx_busy,
    output tx_done,
    output [7:0] rx_data,
    output rx_done,
    output frame_error,
    output rx_busy
);
    wire tx_line;

    uart_tx tx_inst (.clk(clk), .rst_n(rst_n), .tx_start_n(tx_start_n), .tx_data(tx_data), .tx_line(tx_line), .tx_busy(tx_busy), .tx_done(tx_done));
    uart_rx rx_inst (.clk(clk), .rst_n(rst_n), .rx_line(tx_line), .rx_data(rx_data), .rx_done(rx_done), .frame_error(frame_error), .rx_busy(rx_busy));
endmodule