module rx_fsm #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
) (
    input clk,
    input rst_n,
    input tick,
    input rx_line,
    output reg shift,
    output reg rx_busy,
    output reg rx_done,
    output reg frame_error
);
    localparam IDLE = 2'b00,
               START = 2'b01,
               DATA = 2'b10,
               STOP = 2'b11;
    reg [3:0] tick_count;
    reg [1:0] state;
    reg [2:0] bit_index;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            shift <= 0;
            rx_busy <= 0;
            rx_done <= 0;
            frame_error <= 0;
            tick_count <= 0;
            bit_index <= 0;
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE: begin
                    shift <= 0;
                    rx_busy <= 0;
                    rx_done <= 0;
                    frame_error <= 0;
                    tick_count <= 0;
                    bit_index <= 0;
                    if(!rx_line) begin
                        state <= START;
                    end
                    else state <= IDLE;
                end

                START:begin
                    rx_busy <= 1; 
                    if (tick) begin
                        if(tick_count == 8)begin
                            if(!rx_line) begin
                                tick_count <= 0;
                                state <= DATA;
                            end
                            else begin
                                state <= IDLE;
                            end
                        end
                        else begin
                            tick_count <= tick_count + 1;
                        end
                    end
                end

                DATA:begin
                    if(tick)begin
                        if(tick_count == 15)begin
                            shift <= 1;
                            tick_count <= 0;
                            if(bit_index == 3'b111) begin
                                state <= STOP;
                            end
                            else begin
                                bit_index <= bit_index + 1;
                            end
                        end
                        else begin
                            tick_count <= tick_count + 1;
                            shift <= 0;
                        end
                    end
                    else begin
                            shift <= 0;
                    end
                end

                STOP: begin
                    if(tick) begin
                        if(tick_count == 15)begin
                            if(rx_line) begin
                               rx_done <= 1;
                               state <= IDLE; 
                            end
                            else begin
                                frame_error <= 1;
                                state <= IDLE;
                            end
                        end
                        else begin
                            tick_count <= tick_count + 1;
                        end
                    end
                end
            endcase
        end
    end
endmodule