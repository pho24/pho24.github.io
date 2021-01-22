`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2020 05:00:29 PM
// Design Name: 
// Module Name: multu
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


module multu(
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [63:0] result
    );
    assign result = a * b;
endmodule
