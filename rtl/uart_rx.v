module uart_rx #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
) (
    input clk,
    input rst_n,
    input rx_line,
    output [7:0] rx_data,
    output rx_done,
    output frame_error,
    output rx_busy
);
    wire tick, shift;
    baud_gen baud(.clk(clk), .rst_n(rst_n), .tick(tick));
    rx_fsm fsm(.clk(clk), .rst_n(rst_n), .tick(tick), .rx_line(rx_line), .shift(shift), .rx_busy(rx_busy), .rx_done(rx_done), .frame_error(frame_error));
    SIPO sipo(.clk(clk), .rst_n(rst_n), .shift(shift), .rx_line(rx_line), .data(rx_data));
    
endmodule