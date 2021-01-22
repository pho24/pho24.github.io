`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2020 10:37:54 AM
// Design Name: 
// Module Name: SRreg
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


module SRreg( input s,r, clk,
              output reg q);

always@(posedge clk, posedge r)
begin
    if(r) q <= 1'b0;
    else q <= ~r & (s|q);    // based on SR truth table
end              
      
endmodule
