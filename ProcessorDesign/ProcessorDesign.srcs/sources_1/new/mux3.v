`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2020 07:48:24 PM
// Design Name: 
// Module Name: mux3
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


module mux3  (
        input  wire [1:0] sel,
        input  wire [31:0] a,
        input  wire [31:0] b, 
        input  wire [31:0] c, 
        output reg [31:0] y
    );

    always @(*) begin
        case(sel)
            2'b00: y = a;
            2'b01: y = b;
            2'b10: y = c;
            default: y = a;
        endcase
    //assign y = (sel) ? b : a;
    end
endmodule
