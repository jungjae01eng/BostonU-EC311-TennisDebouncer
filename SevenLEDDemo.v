`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2023 10:36:33 PM
// Design Name: 
// Module Name:
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


module SevenLED (
    input clk, rst, point1, point2,
    output [6:0] AN_Out,
    output [6:0] C_Out
);

reg [7:0] AN_In;
reg [55:0] C_In;

parameter ZERO = 7'b0111111, ONE = 7'b0000110, TWO = 7'b1011011, THREE = 7'b1001111, FOUR = 7'b1100110, FIVE = 7'b1101101, SIX = 7'b1111100, SEVEN = 7'b0100111, EIGHT = 7'b1111111, NINE = 7'b1100111;

SevenSegmentLED SevenSegmentLED(.clk(clk),.rst(rst),.AN_In(AN_In),.C_In(C_In),.AN_Out(AN_Out),.C_Out(C_Out));

always @ (*) begin
    if(rst) begin
//        AN_In <= 8'h0;
        C_In <= 64'h0;
    end
    else begin
//        AN_In <= 8'b00111110;
        C_In <= {7'd0,7'd0,FOUR, FIVE, THREE,ONE,ONE,7'd0};
    end
end

endmodule
