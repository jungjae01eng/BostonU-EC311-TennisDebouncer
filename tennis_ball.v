`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University College of Engineering
// Engineer: Ivan G., Jungjae L.
// 
// Create Date: 04/12/2023 12:25:47 PM
// Module Name: tennis_ball
//////////////////////////////////////////////////////////////////////////////////

module tennis_ball(
        input clk,
        input reset,
        input clkreset,
        input right_trigger,
        input left_trigger,
        input squash_switch,
        output reg [15:0] ball,
        output [7:0] AN_Out,
        output [6:0] C_Out
    );
    
    wire PB_left;
    wire PB_downleft;
    wire PB_upleft;
    
    wire PB_right;
    wire PB_downright;
    wire PB_upright;
    
    reg direction;  // 1 = left direction; 0 = right direction;
    wire newclock;
    reg game_on;
    reg player;
    reg [1:0] right_miss;
    reg [1:0] left_miss;
    reg [100:0] right_win;
    reg [1:0] left_win;
    reg [21:0] toggle_val = 22'b1101011110000100000000;
    reg [7:0] AN_In;
    reg [55:0] C_In;
    
    parameter [69:0] numbers = {7'b0111111, 7'b0000110, 7'b1011011, 7'b1001111, 7'b1100110, 7'b1101101, 7'b1111100, 7'b0100111, 7'b1111111, 7'b1100111};
    parameter [6:0] char = {7'b1110011};
    
    Debouncer left_button(.clk(newclock), .PB(left_trigger), .PB_state(PB_left), .PB_down(PB_downleft), .PB_up(PB_upleft), .reset(reset));
    Debouncer right_button(.clk(newclock), .PB(right_trigger), .PB_state(PB_right), .PB_down(PB_downright), .PB_up(PB_upright), .reset(reset));
    clk_divider cd(.clk_in(clk), .rst(clkreset), .toggle_value(toggle_val), .divided_clk(newclock));
    SevenSegmentLED SevenSegmentLED(.clk(clk),.rst(reset),.AN_In(AN_In),.C_In(C_In),.AN_Out(AN_Out),.C_Out(C_Out));
    
    
    always@ (posedge newclock or posedge reset) begin
        if (reset == 1) begin
            ball = 16'b0000000000000001;
            game_on = 0;
            direction = 1;
            player = 1;
            right_miss = 0;
            left_miss = 0;  
            right_win = 0;
            left_win = 0;
            toggle_val = 22'b1101011110000100000000;
            AN_In <= 8'b10000001;
            C_In <= {numbers[7*(9-left_win)+:7], 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, numbers[7*(9-right_win)+:7]};
        end
        else begin
            if (squash_switch == 0) begin // if squash switch is off
                if (game_on == 1) begin
                    if (direction == 1) begin
                        if (ball == 16'b1000000000000000 && game_on == 1) begin
                            if (PB_left == 0) begin
                                player = ~player;
                                game_on = 0;
                                right_win = right_win + 1;
                                AN_In <= 8'b10000001;
                                C_In <= {numbers[7*(9-left_win)+:7], 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, numbers[7*(9-right_win)+:7]};
                            end
                            right_miss = 0;
                            left_miss = 0;
                            direction = 0;
                            toggle_val = toggle_val - 22'b11111111111111111;
                        end
                        else begin
                            //set this to be the cpu for squash                                                    
                            ball = ball << 1;
                            
                            if (left_miss == 3) begin
                                player = ~player;
                                game_on = 0;
                                right_win = right_win + 1;
                                ball = 16'b0000000000000001;
                                direction = 1'b1;
                                AN_In <= 8'b10000001;
                                C_In <= {numbers[7*(9-left_win)+:7], 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, numbers[7*(9-right_win)+:7]};
                            end
                            if (PB_left == 1) begin
                                left_miss = left_miss + PB_left;
                            end
                        end
                    end
                    else begin
                        if (ball == 16'b0000000000000001 && game_on == 1) begin
                            if (PB_right == 0) begin
                                player = ~player;
                                game_on = 0;
                                left_win = left_win + 1;
                                AN_In <= 8'b10000001;
                                C_In <= {numbers[7*(9-left_win)+:7], 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, numbers[7*(9-right_win)+:7]};
                            end
                            direction = 1'b1; 
                            right_miss = 0;
                            left_miss = 0;
                            toggle_val = toggle_val - 22'b11111111111111111;
                        end
                        else begin
                            ball = ball >> 1;
                            if (right_miss == 3) begin
                                player = ~player;
                                game_on = 0;
                                left_win = left_win + 1;
                                ball = 16'b1000000000000000;
                                direction = 1'b0;
                                AN_In <= 8'b10000001;
                                C_In <= {numbers[7*(9-left_win)+:7], 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, numbers[7*(9-right_win)+:7]};
                            end
                            if (PB_right == 1) begin
                                right_miss = right_miss + PB_right;
                            end
                        end
                    end
                end
                else begin
                    if (right_win == 3) begin
                        ball = 16'b1000000000000000;
                        direction = 1'b0;
                        left_win = 0;
                        right_win = 0;
                        AN_In <= 8'b00011000;
                        C_In <= {7'd0, 7'd0, 7'd0, char[0+:7], numbers[7*(9-2)+:7], 7'd0, 7'd0, 7'd0};
                    end
                    else if (left_win == 3) begin
                        ball = 16'b0000000000000001;
                        direction = 1'b1;
                        left_win = 0;
                        right_win = 0;
                        AN_In <= 8'b00011000;
                        C_In <= {7'd0, 7'd0, 7'd0, char[0+:7], numbers[7*(9-1)+:7], 7'd0, 7'd0, 7'd0};
                    end
                    else begin
                        if (direction == 1) begin
                            if (PB_right == 1) begin
                                game_on = 1;
                                toggle_val = 22'b1101011110000100000000;
                            end
                        end
                        else if (direction == 0) begin
                            if (PB_left == 1) begin
                                game_on = 1;
                                toggle_val = 22'b1101011110000100000000;
                            end
                        end
                    end
                end
            end
            else if (squash_switch == 1) begin  // if squash switch is on
                if (game_on == 1) begin
                    if (direction == 1) begin
                        if (ball == 16'b1000000000000000 && game_on == 1) begin
                            direction = 0;
                        end
                        else begin
                            ball = ball << 1;
                        end
                    end
                    else if (direction == 0) begin
                        if (ball == 16'b0000000000000001 && game_on == 1) begin
                            if (PB_right == 0) begin
                                game_on = 0;
                                direction = 1'b1;  
                            end
                            else if (PB_right == 1) begin
                                direction = 1'b1;
                                right_win = right_win + 1;
                                right_miss = 0;
                                if (right_win <= 9) begin
                                    AN_In <= 8'b00000001;
                                    C_In <= {7'd0, 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, numbers[7*(9-right_win)+:7]};
                                end
                                else if (right_win > 9) begin
                                    AN_In <= 8'b00000011;
                                    C_In <= {7'd0, 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, numbers[7*(9-(right_win/10))+:7], numbers[7*(9-(right_win%10))+:7]};
                                end
                                toggle_val = toggle_val - 22'b11111111111111111;
                            end
                        end
                        else begin
                            ball = ball >> 1;
                            if (right_miss == 3) begin
                                // check misses
                                game_on = 0;
                                ball = 16'b0000000000000001;
                                direction = 1'b1;
                                if (right_win <= 9) begin
                                    AN_In <= 8'b00000001;
                                    C_In <= {7'd0, 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, numbers[7*(9-right_win)+:7]};
                                end
                                else if(right_win > 9) begin
                                    AN_In <= 8'b00000011;
                                    C_In <= {7'd0, 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, numbers[7*(9-(right_win/10))+:7], numbers[7*(9-(right_win%10))+:7]};
                                end
                            end
                            if (PB_right == 1) begin
                                right_miss = right_miss + PB_right;
                            end
                        end
                    end
                end
                else if (game_on == 0) begin
                    if (direction == 1) begin
                        if (PB_right == 1) begin
                            game_on = 1;
                            right_win = 0;
                            AN_In <= 8'b00000001;
                            C_In <= {7'd0, 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, 7'd0, numbers[7*(9-right_win)+:7]};
                            toggle_val = 22'b1101011110000100000000;
                        end
                    end
                    else if (direction == 0) begin
                        if (PB_left == 1) begin
                            game_on = 1;
                            right_win = 0;
                            toggle_val = 22'b1101011110000100000000;
                        end
                    end
                end
            end
        end
    end
endmodule