`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University College of Engineering
// Engineer: Ivan G., Jungjae L.
// 
// Create Date: 04/12/2023 01:52:47 PM
// Module Name: clk_divider
// Dependencies: Generates a clock with period X ms, from 40 MHz input clock, T=2.5E-5 ms
//						A counter counts till toggle_value = 'b111111111111111111111
//////////////////////////////////////////////////////////////////////////////////

module clk_divider(
	input clk_in,
	input rst,
	input [21:0] toggle_value,
	output reg divided_clk
    );
	 
    reg[21:0] cnt;
    
    always@ (posedge clk_in or posedge rst) begin
        if (rst==1) begin
            cnt <= 0;
            divided_clk <= 0;
        end
        else begin
            if (cnt==toggle_value) begin
                cnt <= 0;
                divided_clk <= ~divided_clk;
            end
            else begin
                cnt <= cnt +1;
                divided_clk <= divided_clk;		
            end
        end
    end
endmodule