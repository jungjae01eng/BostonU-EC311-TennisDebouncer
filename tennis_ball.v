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
        //input newclk,
        input reset,
        input clkreset,
        input right_trigger,
        input left_trigger,
        output reg [15:0] ball
    );
    
    Debouncer left_button(.clk(newclock), .PB(left_trigger), .PB_state(PB_left), .PB_down(PB_downleft), .PB_up(PB_upleft), .reset(reset));
    Debouncer right_button(.clk(newclock), .PB(right_trigger), .PB_state(PB_right), .PB_down(PB_downright), .PB_up(PB_upright), .reset(reset));
    clk_divider cd(.clk_in(clk), .rst(clkreset), .toggle_value(toggle_val), .divided_clk(newclock));
    
    wire PB_left;  
    wire PB_downleft;  
    wire PB_upleft;
    
    wire PB_right;  
    wire PB_downright;  
    wire PB_upright;
    
    
    reg direction; // 1 = left direction; 0 = right direction;
    wire newclock;
    reg game_off;
    reg player;
    reg [1:0] right_miss;
    reg [1:0] left_miss;
    reg [1:0] right_win;
    reg [1:0] left_win;
    reg [21:0] toggle_val = 22'b1101011110000100000000;
       
    
    always@ (posedge newclock or posedge reset)
            begin
                if(reset == 1)
                    begin
                        ball = 16'b0000000000000001;
                        game_off = 1;
                        direction = 1;
                        player = 1;
                        right_miss = 0;
                        left_miss = 0;  
                        right_win = 0;
                        left_win = 0;
                        toggle_val = 22'b1101011110000100000000;
                    end
                else
                    begin
                        if(game_off == 0)
                            begin
                                if(direction == 1)
                                    begin
                                        if(ball == 16'b1000000000000000)
                                            begin
                                            if(PB_left == 0)
                                                begin
                                                    player = ~player;
                                                    game_off = 1;
                                                    right_win = right_win + 1;
                                                end
                                            right_miss = 0;
                                            left_miss = 0;
                                            direction = 0;
                                            toggle_val = toggle_val - 22'b11111111111111111;
                                            end
                                        else               
                                        //set this to be the cpu for squash                                                    
                                                ball = ball << 1;
                                                if(PB_left == 1)
                                                        left_miss = left_miss + PB_left; 
                                                if(left_miss == 3)
                                                    begin
                                                        player = ~player;
                                                        game_off = 1;
                                                        right_win = right_win + 1;
                                                        ball = 16'b0000000000000001;
                                                        direction = 1'b0;    
                                                    end           
                                                
                                    end
                                else 
                                    begin
                                        if(ball == 16'b0000000000000001)
                                            begin
                                            if(PB_right == 0)
                                                begin
                                                    player = ~player;
                                                    game_off = 1;
                                                    left_win = left_win + 1;
                                                end
                                                direction = 1'b1; 
                                                right_miss = 0;
                                                left_miss = 0;
                                                toggle_val = toggle_val - 22'b11111111111111111;
                                          end
                                       else                                                                     
                                                
                                                ball = ball >> 1;
                                                if(PB_right == 1)
                                                        right_miss = right_miss + PB_right;
                                                if(right_miss == 3)
                                                    begin
                                                        player = ~player;
                                                        game_off = 1;
                                                        left_win = left_win + 1;
                                                        ball = 16'b1000000000000000;
                                                        direction = 1'b1;
                                                    end
                                                
                                  end
                            end                         
                        else   
                            begin
                                if(right_win == 3)
                                    begin
                                        ball = 16'b0000100000000001;
                                        left_win = 0;
                                        right_win = 0;
                                    end
                                else if(left_win == 3)
                                    begin
                                        ball = 16'b0100000000010000;
                                        left_win = 0;
                                        right_win = 0;
                                    end
                                else
                                    //toggle_val = 22'b1101011110000100000000;
                                    if(direction == 1)
                                        begin
                                            if(PB_right == 1)
                                                begin
                                                    game_off = 0;
                                                    toggle_val = 22'b1101011110000100000000;
                                                end
                                        end
                                    else if (direction == 0)
                                        begin
                                            if(PB_left == 1)
                                                begin
                                                    game_off = 0;
                                                    toggle_val = 22'b1101011110000100000000;
                                                end
                                        end
                                                            
                           end   
                                    
//                                direction = player;
//                                if(direction == 0)
//                                    ball = 16'b0000000000000001;
                   end
        end


        

       
                        
                        
       
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
       

//        always@ (posedge clk or posedge reset)
//            begin
//                if(reset)
//                    begin
//                        ball = 16'b0000000000000001;
//                        game_off = 0;
//                        direction = 1;
//                        player = 1;
//                    end
//                else
//                    begin 
//                        if(game_off == 0)
//                            begin
//                                ;
//                            end 
//                        else
//                            if(direction == 1)
//                                begin  
//                                    if(left_trigger)
//                                        begin
//                                            game_off = 0;
//                                        end    
//                                    else
//                                        if(right_trigger)
//                                            begin
//                                                game_off = 0;
//                                            end
////                            begin
////                                if(direction == 1'b1)
////                                    begin
////                                        if(left_trigger == 0)
////                                            begin    
////                                                player = ~player;
////                                                game_off = 1;
////                                                right_win = right_win + 1;
////                                            end
////                                            right_miss = 0;
////                                            left_miss = 0;
////                                    end
////                                        else
////                                            begin
////                                                left
                                            
//                             end
//                         end       
//                    end
       
                        
                      
endmodule
