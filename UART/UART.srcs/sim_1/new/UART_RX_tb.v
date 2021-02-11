`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2021 01:23:18 PM
// Design Name: 
// Module Name: UART_RX_tb
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


module UART_RX_tb;
    reg r_clk = 0;
    reg r_serial = 1;
    wire [7:0] w_byte;
    wire valid;   
    
    UART_RX #(217) DUT (
        .i_clk(r_clk),
        .i_serial(r_serial),
        .o_byte(w_byte),
        .o_valid(valid)
    );
    
    initial begin
        r_clk = 0;
        forever begin
            #20 r_clk = ~r_clk;    //40 ns clock period
        end
    end
    
    task writeByte;
        input [7:0] i_data;
        integer i;
        begin
            //start bit
            r_serial <= 1'b0;  //drive serial to 0 to begin
            #8600;
            #1000;
            
            //send 8 bit of data
            for(i = 0; i< 8; i = i+1) begin
                r_serial <= i_data[i];
                #8600;
            end
            
            //send stop bit
            r_serial <= 1'b1;
            #8600;
        end
    endtask
    
    integer i_error;
    initial begin
        i_error = 0;
        @(posedge r_clk);
        writeByte(8'h48);
        if(w_byte != 8'h48)begin
            i_error = i_error +1;
        end
        $finish();
    end
endmodule
