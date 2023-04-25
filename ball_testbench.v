`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 12:38:41 PM
// Design Name: 
// Module Name: ball_testbench
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


module ball_testbench(

    );
    
    reg clk;
    reg reset;
    reg right_trigger;
    reg left_trigger;
    wire [15:0] ball;
    
    tennis_ball object1(.clk(clk), .reset(reset), .ball(ball), .right_trigger(right_trigger), .left_trigger(left_trigger));
    
    initial 
        begin 
            clk = 0;
            forever #2 clk = ~clk;
        end
        
     initial 
        begin
            reset = 1; right_trigger = 1; left_trigger = 0;
            #2 reset = 0; right_trigger = 0;
            #68 left_trigger = ~left_trigger;
            #2 left_trigger = 0;
            #68 right_trigger = ~right_trigger; left_trigger = ~left_trigger;
            
            #68 right_trigger = ~right_trigger; left_trigger = ~left_trigger;
            #68 right_trigger = ~right_trigger; left_trigger = ~left_trigger;
        end
        

        
        
endmodule
