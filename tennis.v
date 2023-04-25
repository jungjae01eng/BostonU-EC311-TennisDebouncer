`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2023 02:35:28 AM
// Design Name: 
// Module Name: tennis
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


module tennis(
        input clk,
        input reset1,       // clock reset
        input reset2,       // game reset
        input left_trigger1,
        input right_trigger1,
        output ball
    );
	
    wire left_button1;
    wire right_button1;
    
    clk_divider cd(
        .clk_in(clk),
        .rst(reset1),       // clock reset
        .toggle_value(toggle_val1),
        .divided_clk(divided_clk1)      // output
    );
        
    tennis_ball object(
        .clk(divided_clk1),
        .reset(reset2),     // game reset
        .left_trigger(left_trigger1),
        .right_trigger(right_trigger1),
        .toggle_val(toggle_val1),
        .ball(ball)     // output
    );
    
    Debouncer left_button(
        .clk(clk),
        .PB(left_trigger),
        .reset(reset2),
        .PB_state(),
        .PB_up(left_button1),
        .PB_down()
    );
    
    Debouncer right_button(
        .clk(clk),
        .PB(right_trigger),
        .reset(reset2),
        .PB_state(),
        .PB_up(right_button1),
        .PB_down()
    );

//      Debouncer left_button_debounced(clk, left_button, 1'b0, .PB_up(left_button1), .PB_down());
//      Debouncer right_button_debounced(clk, right_button, 1'b0, .PB_up(right_button1), .PB_down());
    
      // update ball position based on button presses
      reg [1:0] current_position;
      always @(posedge clk) begin
        if (left_button1 && current_position == 2'b01) begin
          current_position <= 2'b00;
        end else if (right_button1 && current_position == 2'b00) begin
          current_position <= 2'b01;
        end
      end
    
      assign ball_position = current_position;
    
endmodule
