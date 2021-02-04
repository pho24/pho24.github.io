`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2020 01:13:14 PM
// Design Name: 
// Module Name: fact_top_tb
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


module fact_top_tb;
      reg clk, rst, WE_tb;
      reg [1:0] A_tb;
      reg [3:0] WD_tb;
      wire [31:0] RD_tb;

    fact_top DUT(.clk(clk),
                .rst(rst),
                .WE(WE_tb),
                .A(A_tb),
                .WD(WD_tb),
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
    
    integer i;
    
    initial begin
        clk = 0;
        reset();                    //initialization
        tick();
        WE_tb = 1'b1; //enable factorial
        
        for(i = 0; i< 16; i = i+1)
        begin
            WD_tb = i;  // assign n value
            A_tb = 2'b00; // perform input n
            tick(); //hold n in reg
            
            WD_tb = 4'b0001; // go signal
            A_tb = 2'b01;
            tick(); //hold go signal
            
            A_tb = 2'b10; // select display done signal
            tick();
            
            while(RD_tb[1:0] != 2'b01)begin //wait for done signal
                tick(); //clk until finish
                if(RD_tb[1:0] == 2'b10) $stop;  //stop if error
            end           
      
            A_tb = 2'b11; // sidplay result
            tick();
            
        end
    
        $finish;
    end
    
endmodule
