`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 12:25:47 PM
// Design Name: 
// Module Name: tennis_ball
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
                        

module tennis_ball(
        input clk,
        input reset,
        input left_trigger,
        input right_trigger,
        output toggle_val,
        output reg [15:0] ball
    );
    

    reg direction; // 1 = left direction; 0 = right direction;
    reg game_on = 0;
    reg player;
    reg [1:0] right_miss;
    reg [1:0] left_miss;
    reg [1:0] right_win;
    reg [1:0] left_win;
    reg [21:0] toggle_val = 22'b1101011110000100000000;
    reg timer;
    
    
    always@ (posedge clk or posedge reset) begin
        if(reset == 1) begin        // START the game
            // RESET the game
            right_miss = 0;
            left_miss = 0;
            right_win = 0;
            left_win = 0;
            
            timer = 0;
            while (left_trigger != 1 || right_trigger != 1) begin
                if (left_trigger == 1) begin        // LEFT player will begin the game
                    ball = 16'b1000000000000000;
                    game_on = 0;
                    direction = 0;      // direction is from left to right
                    player = 1;         // player LEFT begins
                    toggle_val = 22'b1101011110000100000000;
                    
                    // START the game
                    game_on = 1;
                 end
                 else if (right_trigger == 1 || timer == 1999) begin     // RIGHT player will begin the game
                    ball = 16'b0000000000000001;
                    game_on = 0;
                    direction = 1;      // direction is from right to left
                    player = 0;         // player RIGHT begins
                    toggle_val = 22'b1101011110000100000000;
                    
                    // START the game
                    game_on = 1;
                end
                else
                    timer = timer + 1;
            end
        end
        else if (game_on == 1) begin      // game is ON
            if (direction == 1) begin       // direction is from right to left
                if(ball == 16'b0100000000000000 || ball == 16'b1000000000000000) begin      // ball reaches LEFT side
                    if(left_trigger == 0) begin     // if LEFT player does NOT press button in time
                        game_on = 0;       // game is over
                        player = ~player;       // player's start turn changes
                        right_win = right_win + 1;      // player RIGHT win
                        
                        // direction
                        if (player == 1) begin
                            direction = 0;
                        end
                        else if (player == 0) begin
                            direction = 1;
                        end
                        
                        toggle_val = toggle_val - 22'b1111111111111;
                    end
                    else if (left_trigger == 1) begin      // LEFT player press button
                        direction = 0;
                    end
                end
                else
                    ball = ball << 1;
            end
            else if (direction == 0) begin
                if(ball == 16'b0000000000000001 || ball == 16'b0000000000000010) begin      // ball reaches RIGTH side
                    if(right_trigger == 0) begin        // if RIGHT player does NOT press button in time
                        game_on = 0;       // game is over
                        player = ~player;       // player's start turn changes
                        left_win = left_win + 1;      // player LEFT win
                        // direction
                        if (player == 1) begin
                            direction = 0;
                        end
                        else if (player == 0) begin
                            direction = 1;
                        end
                        
                        toggle_val = toggle_val - 22'b1111111111111;
                    end
                    else if (right_trigger == 1) begin      // RIGHT player press button
                        direction = 1;
                    end
                end
                else
                    ball = ball >> 1;
            end
        end
    end
    
    
endmodule