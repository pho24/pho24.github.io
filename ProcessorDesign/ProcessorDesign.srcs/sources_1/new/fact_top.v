`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2020 11:09:18 AM
// Design Name: 
// Module Name: fact_top
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


module fact_top(
        input [1:0] A,
        input WE, clk,rst,
        input [3:0] WD,
        output reg [31:0] RD
    );
wire [1:0] RdSel;
wire WE1,WE2;
wire GoPulseCmb, Go, GoPulse;
wire [3:0] n;
wire [31:0] nf, Result;
wire Done, Err, ResDone, ResErr;
    
    assign GoPulseCmb = WE2 & WD[0];
    
    fact_ad ad(.A(A),
               .WE(WE),
               .RdSel(RdSel),
               .WE1(WE1),
               .WE2(WE2));
    
    dreg #4 n_reg(.clk(clk),
                  .rst(rst),
                  .we(WE1),
                  .d(WD),
                  .q(n));
                  
    dreg #1 Go_reg(.clk(clk),
                  .rst(rst),
                  .we(WE2),
                  .d(WD[0]),
                  .q(Go));
                  
    dreg #1 GoPulse_reg(.clk(clk),
                  .rst(rst),
                  .we(1'b1),
                  .d(GoPulseCmb),
                  .q(GoPulse));
    
    Factorial Factorial(.go(GoPulse),
                        .n(n),
                        .clk(clk),
                        .rst(rst),
                        .done(Done),
                        .err(Err),
                        .Out(nf));
                        
    SRreg Result_Done(.s(Done),
                      .r(GoPulseCmb),
                      .clk(clk),
                      .q(ResDone));   
    
    SRreg Result_Err(.s(Err),
                      .r(GoPulseCmb),
                      .clk(clk),
                      .q(ResErr)); 
                      
    dreg #32 nf_reg(.clk(clk),
                  .rst(rst),
                  .we(Done),
                  .d(nf),
                  .q(Result)); 
                  
     always @ (*) begin
        case (RdSel)
            2'b00: RD = {28'b0,n};
            2'b01: RD = {31'b0,Go};
            2'b10: RD = {30'b0,ResErr,ResDone};
            2'b11: RD = Result;
            default: RD = 31'bx;
        endcase
    end       
    
endmodule
