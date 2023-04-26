`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2023 01:30:39 PM
// Design Name: 
// Module Name: clk_withball
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


module clk_withball(
	    input clk,
        input reset,
        //input clkreset,
        input right_trigger,
        input left_trigger,
        output [15:0] ball	    
    );  
        
    wire PB_stateleft;  
    wire PB_downleft;  
    wire PB_upleft;
    
    wire PB_stateright;  
    wire PB_downright;  
    wire PB_upright;
    
    
    
    
    
    
    //Debouncer left_button(.clk(clk), .PB(left_trigger), .PB_state(PB_stateleft), .PB_down(PB_downleft), .PB_up(PB_upleft), .reset(reset));
   // Debouncer right_button(.clk(clk), .PB(right_trigger), .PB_state(PB_stateright), .PB_down(PB_downright), .PB_up(PB_upright), .reset(reset));
    
    tennis_ball object1(.clk(clk), .reset(reset), .ball(ball), .left_trigger(left_trigger), .right_trigger(right_trigger));
    
endmodule

