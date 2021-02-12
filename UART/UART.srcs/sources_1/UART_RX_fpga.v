`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2021 02:20:08 PM
// Design Name: 
// Module Name: UART_RX_fpga
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


module UART_RX_fpga( 
        input   wire       i_clk_100MHz,
        input   wire       i_rst,
        input   wire       i_serial,
        output  wire [3:0] LEDSEL,
        output  wire [7:0] LEDOUT,
        output  wire       o_valid
    );
    
    //wire    w_serial;
    wire    [7:0] w_byte;
    wire    w_valid;   
    wire    clk_5KHz; 
    
    wire [7:0]  digit0;
    wire [7:0]  digit1;
    
    supply1[7:0] vcc;
    
    UART_RX #(868) DUT (
        .i_clk(i_clk_100MHz),
        .i_serial(i_serial),
        .o_byte(w_byte),
        .o_valid(o_valid)
    );
    
    clk_gen clk_gen (
            .clk100MHz          (i_clk_100MHz),
            .rst                (i_rst),
            .clk_4sec           (),
            .clk_5KHz           (clk_5KHz)
     );

    hex_to_7seg hex1 (
            .HEX                (w_byte[7:4]),
            .s                  (digit1)
    );

    hex_to_7seg hex0 (
            .HEX                (w_byte[3:0]),
            .s                  (digit0)
    );
    
    led_mux led_mux (
            .clk                (clk_5KHz),
            .rst                (i_rst),
            .LED3               (vcc),
            .LED2               (vcc),
            .LED1               (digit1),
            .LED0               (digit0),
            .LEDSEL             (LEDSEL),
            .LEDOUT             (LEDOUT)
     );
    
    
endmodule
