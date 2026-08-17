module PISO (
    input clk,
    input rst_n,
    input load,
    input shift,
    input [7:0] tx_data,
    output data_bit
);
    reg [7:0] shifter;
    assign data_bit = shifter[0];
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            shifter <= 0;
        end
        else begin
            if(load) begin
                shifter <= tx_data;
            end
            else if(shift) begin
                shifter <= shifter >> 1;
            end

        end
    end
endmodule