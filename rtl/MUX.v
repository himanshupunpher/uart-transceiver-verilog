module MUX(
    input [1:0] select,
    input data_bit,
    output reg tx_line
);
    localparam SEL_IDLE = 2'b00,
               SEL_START = 2'b01,
               SEL_DATA = 2'b10,
               SEL_STOP = 2'b11;
    always@(*) begin
        case(select)
            SEL_START: tx_line = 0;
            SEL_DATA: tx_line = data_bit;
            SEL_STOP: tx_line = 1;
            default: tx_line = 1;
        endcase
    end
endmodule