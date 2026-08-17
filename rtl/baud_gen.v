module baud_gen #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
) (
    input clk,
    input rst_n,
    output reg tick
);
    localparam CYCLE_PER_TICK = CLK_FREQ/(BAUD_RATE*16);
    reg [8:0] counter;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tick <= 0;
            counter <= 0;
        end
        else begin
            if(counter == CYCLE_PER_TICK - 1) begin
                counter <= 0;
                tick <= 1;
            end
            else begin
                tick <= 0;
                counter <= counter + 1;
            end
        end
    end
endmodule