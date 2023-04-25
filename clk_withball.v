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
        input reset1,       // clock reset
        input reset2,       // bouncer reset
        input right_trigger,
        input left_trigger,
        output [15:0] ball	    
    );
        
      
    wire divided_clk;    
        
    wire PB_stateleft;  
    wire PB_downleft;  
    wire PB_upleft;
    
    wire PB_stateright;  
    wire PB_downright;  
    wire PB_upright;
    
    
    clk_divider cd(.clk_in(clk), .rst(reset1), .divided_clk(divided_clk));
    
    tennis_ball object1(.clk(divided_clk), .reset(reset2), .ball(ball), .left_trigger(PB_upleft), .right_trigger(PB_upright));
    
//    Debouncer left_button(.clk(clk), .PB(left_trigger), .PB_state(PB_stateleft), .PB_down(PB_downleft), .PB_up(PB_upleft), .reset(reset2));
//    Debouncer right_button(.clk(clk), .PB(right_trigger), .PB_state(PB_stateright), .PB_down(PB_downright), .PB_up(PB_upright), .reset(reset2));

    Debouncer left_button(.clk(clk), .PB(left_trigger), .reset(reset2));
    Debouncer right_button(.clk(clk), .PB(right_trigger), .reset(reset2));
    
    
endmodule

