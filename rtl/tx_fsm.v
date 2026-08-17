module tx_fsm #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
) (
    input clk,
    input rst_n,
    input tx_start,            //will get high when tx starts
    output reg shift,
    output reg load,
    output reg [1:0] select,
    output reg tx_busy,         //high while sending
    output reg tx_done          //pulses high for 1 cycle when done
);
    localparam CYCLES_PER_BIT = CLK_FREQ / BAUD_RATE;
    localparam IDLE = 2'b00,
               START = 2'b01,
               DATA = 2'b10,
               STOP = 2'b11;
    
    reg [1:0] state;
    reg [12:0] counter;
    reg [2:0] bit_index;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= IDLE;
            tx_busy <= 0;
            tx_done <= 0;
            counter <= 0;
            bit_index <= 0;
            select <= 2'b00;
            shift <= 0;
            load <= 0;
        end
        else begin
            case(state)
                IDLE:begin
                    tx_done <= 0;
                    load <= 0;
                    shift <= 0;
                    if(tx_start) begin
                        load <= 1;
                        counter <= 0;
                        bit_index <= 0;
                        tx_busy <= 1;
                        state <= START;
                    end
                    else begin
                        tx_busy <= 0;
                    end
                    end

                START:begin
                    select <= 2'b01;
                    tx_done <= 0;
                    tx_busy <= 1;
                    if(counter == CYCLES_PER_BIT-1) begin
                        counter <= 0;
                        bit_index <= 0;
                        state <= DATA;
                        end
                    else begin
                        counter <= counter + 1;
                        end
                    end

                DATA:begin
                    select<= 2'b10;
                    tx_busy <= 1;
                    tx_done <= 0;
                    if(counter == CYCLES_PER_BIT - 1)begin
                        if(bit_index == 3'b111) begin
                            counter <= 0;
                            shift <= 0;
                            state <= STOP;
                            end
                        else begin    
                            bit_index <= bit_index + 1;
                            shift <= 1;
                            counter <= 0;
                            end
                        end
                    else begin
                        counter <= counter + 1;
                        shift <= 0; 
                        end
                    end

                STOP:begin
                    select <= 2'b11;
                    tx_busy <= 1;
                    if(counter == CYCLES_PER_BIT-1) begin
                        tx_done <= 1;
                        counter <= 0;
                        tx_busy <= 0;
                        bit_index <= 0;
                        state <= IDLE;
                        end
                    else begin
                        counter <= counter + 1;
                        end
                    end
            endcase
        end
    end


endmodule