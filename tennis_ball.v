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
        input right_trigger,
        input left_trigger,
        output reg [15:0] ball
    );
    
    reg [3:0] location;
    reg direction; // 0 = right -> left direction; 1 = right -> left direction;
    reg game_on;

        always@ (posedge clk)
        begin
            if(reset == 1) begin
                location <= 0;
                ball[0] <= 1;
                game_on <= 0;
            end
            else if(right_trigger == 1) begin
                location <= 0;
                ball[0] <= 1;
                direction <= 0;
                game_on <= 1;
            end
            else if(left_trigger == 1) begin
                location <= 15;
                ball[15] <= 1;
                direction <= 1;
                game_on <= 1;
            end
            
            if(game_on == 1) begin 
                case(direction)
                    0: location <= location + 1;    
                    1: location <= location - 1;
//                    default: ;
                endcase
                        
                case(location)
                     0: begin
                        ball <= 16'b0000000000000001;
                        direction <= 0;
                        end
                     1: ball <= 16'b0000000000000010;
                     2: ball <= 16'b0000000000000100;
                     3: ball <= 16'b0000000000001000;
                     4: ball <= 16'b0000000000010000;
                     5: ball <= 16'b0000000000100000;
                     6: ball <= 16'b0000000001000000;
                     7: ball <= 16'b0000000010000000;
                     8: ball <= 16'b0000000100000000;
                     9: ball <= 16'b0000001000000000;
                     10: ball <= 16'b0000010000000000;
                     11: ball <= 16'b0000100000000000;
                     12: ball <= 16'b0001000000000000;
                     13: ball <= 16'b0010000000000000;
                     14: ball <= 16'b0100000000000000;
                     15: begin
                        ball <= 16'b1000000000000000;
                        direction <= 1;
                        end
                     default: ball <= 16'b0000000000000000;
                endcase
            end
//        end // inner nested
        end // outer nested        
endmodule