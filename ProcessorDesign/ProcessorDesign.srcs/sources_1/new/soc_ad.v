`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2020 12:29:35 PM
// Design Name: 
// Module Name: soc_ad
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


module soc_ad(
        input wire [11:2] A,
        input wire      WE,
        output reg      WEM,
        output reg      WE1,
        output reg      WE2,
        output wire [1:0] RdSel 
    );
    
    always@(*)begin
    casex(A)
    10'b0000_xxxx_xx: begin //0x000- 0x0FC
        WEM = WE;
        WE1 = 1'b0;
        WE2 = 1'b0;
    end
    
    10'b1000_0000_xx: begin //0x800-0x80C
        WEM = 1'b0;
        WE1 = WE;
        WE2 = 1'b0;
    end
    
    10'b1001_0000_xx: begin//0x900-0x90C
        WEM = 1'b0;
        WE1 = 1'b0;
        WE2 = WE;
    end
    
    default: begin
        WEM = 1'bx;
        WE1 = 1'bx;
        WE2 = 1'bx;
    end
    endcase
    end
    assign RdSel = {A[11],A[8]};
endmodule