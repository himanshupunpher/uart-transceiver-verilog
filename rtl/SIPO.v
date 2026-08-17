module SIPO (
    input clk,
    input rst_n,
    input shift,
    input rx_line,
    output reg [7:0] data
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data <= 0;
        end
        else begin
            if(shift) begin
                data <= {data[6:0], rx_line};
            end
        end
    end
endmodule