`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2023 05:11:38 PM
// Design Name: 
// Module Name: newball
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


module newball(
        input clk,
        input serve_button,
        output reg [15:0] ball
    );
    
    reg [3:0] location;
    
    always @(posedge clk)
        begin
            if(serve_button)
                ball <= 0;
            else
                location <= location + 1;
        end
        
    always @(location) 
        begin
            case(location)
                0: ball <= 16'b0000000000000001;
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
                15: ball <= 16'b1000000000000000;
                default: ball <= 16'b0000000000000000;
            endcase
       end
           
endmodule
