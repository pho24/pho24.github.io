`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2020 12:04:04 PM
// Design Name: 
// Module Name: pqio_top
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


module gpio_top(
        input [31:0] gpI1,
        input [31:0] gpI2,
        input [1:0] A,
        input WE, clk,rst,
        input [31:0] WD,
        output reg [31:0] RD,
        output [31:0] gpO1, gpO2
    );
    
wire [1:0] RdSel;
wire WE1,WE2;
    
    GPIO_ad ad(.A(A),
               .WE(WE),
               .RdSel(RdSel),
               .WE1(WE1),
               .WE2(WE2));
    
    dreg #32 O1 (.clk(clk),
                  .rst(rst),
                  .we(WE1),
                  .d(WD),
                  .q(gpO1));
    
    dreg #32 O2 (.clk(clk),
                  .rst(rst),
                  .we(WE2),
                  .d(WD),
                  .q(gpO2)); 
                  
    always @ (*) begin
        case (RdSel)
            2'b00: RD = gpI1;
            2'b01: RD = gpI2;
            2'b10: RD = gpO1;
            2'b11: RD = gpO2;
            default: RD = 31'bx;
        endcase
    end                         
    
endmodule
