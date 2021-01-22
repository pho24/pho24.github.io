`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2020 03:34:27 PM
// Design Name: 
// Module Name: system_tb
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


module system_tb;
    reg clk, rst;
    reg [31:0] gpI1_tb, gpI2_tb;
    wire [31:0] gpO1_tb, gpO2_tb, pc_current_tb;
    
    System DUT(.clk(clk),
               .rst(rst),
               .gpI1(gpI1_tb),
               .gpI2(gpI2_tb),
               .gpO1(gpO1_tb),
               .gpO2(gpO2_tb),
               .pc_current(pc_current_tb));
    //integer pc_current = 2'h0;
               
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
        clk = 0;
        reset();                    //initialization
        tick();
        
        gpI1_tb = 5'b11101; // n = 4
        while(pc_current_tb != 32'h40) 
        begin 
            tick();
            if(gpO1_tb[0]) $stop;
        end
        $finish;
    end
endmodule
