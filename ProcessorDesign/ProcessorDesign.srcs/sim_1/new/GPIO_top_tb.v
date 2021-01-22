`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2020 02:33:11 PM
// Design Name: 
// Module Name: GPIO_top_tb
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


module GPIO_top_tb;
    reg [31:0] gpI1_tb, gpI2_tb, WD_tb;
    reg [1:0] A_tb;
    reg WE_tb, clk, rst;
    wire [31:0] gpO1_tb, gpO2_tb, RD_tb;
    
    gpio_top DUT(.gpI1(gpI1_tb),
                 .gpI2(gpI2_tb),
                 .A(A_tb),
                 .WE(WE_tb),
                 .clk(clk),
                 .rst(rst),
                 .WD(WD_tb),
                 .gpO1(gpO1_tb),
                 .gpO2(gpO2_tb),
                 .RD(RD_tb));
   
   task tick; 
    begin 
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end
    endtask

    task reset;
    begin 
        rst = 1'b0; #5;
        rst = 1'b1; #5;
        rst = 1'b0;
    end
    endtask
        
    initial begin
        gpI1_tb = 0; //provide input
        gpI2_tb = 0; // provide input
        WD_tb = 0;
        clk = 0;
        reset();
        tick();
        
        WE_tb = 1'b1;
        A_tb = 2'b00; //select input 1(gpI1)
        gpI1_tb = $random; //provide input
        gpI2_tb = $random; // provide input
        WD_tb = $random;
        tick();// display gpI1
        
        A_tb = 2'b01;
        tick();//display gpI2
        
        A_tb = 2'b10;
        tick();//display gpO1
        
        A_tb = 2'b11;
        tick();//display gpO2
        
        $finish;
    end
endmodule
