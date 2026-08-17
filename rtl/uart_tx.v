module uart_tx #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
) (
    input clk,
    input rst_n,
    input tx_start_n,       
    input [7:0] tx_data,
    output tx_line,
    output tx_busy,
    output tx_done
);

    wire load, shift, data_bit;
    wire [1:0] select;

    wire tx_start_raw = ~tx_start_n;

    reg tx_start_prev;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            tx_start_prev <= 0;
        else
            tx_start_prev <= tx_start_raw;
    end

    wire tx_start_pulse = tx_start_raw & ~tx_start_prev;

    tx_fsm fsm(.clk(clk), .rst_n(rst_n), .tx_start(tx_start_pulse), .shift(shift), .load(load), .select(select), .tx_busy(tx_busy), .tx_done(tx_done));
    PISO piso(.clk(clk), .rst_n(rst_n), .tx_data(tx_data), .shift(shift), .load(load), .data_bit(data_bit));
    MUX mux(.select(select), .data_bit(data_bit), .tx_line(tx_line) );

endmodule