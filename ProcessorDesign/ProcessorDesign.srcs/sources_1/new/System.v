`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2020 12:16:01 PM
// Design Name: 
// Module Name: System
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


module System(
        input clk, rst,
        input [31:0] gpI1, gpI2, 
        output [31:0] gpO1, gpO2, pc_current
);

//wire [31:0] pc_current;
wire [31:0] instr, alu_out;
wire        we_dm;
wire [31:0] wd_dm;
reg  [31:0] RD;
wire [1:0] RdSel;
wire WE1,WE2,WEM;
wire [31:0] DmemData, FactData, GPIOData;
wire [4:0] dont_care;
wire [31:0] Dont_care;

    soc_ad ad(
            .A              ({alu_out[11:2]}),
            .WE             (we_dm),
            .RdSel          (RdSel),
            .WE1            (WE1),
            .WE2            (WE2),
            .WEM            (WEM));

    imem imem (
            .a              (pc_current[7:2]),
            .y              (instr)
        );
        
    mips Mips (
            .clk            (clk),
            .rst            (rst),
            .ra3            (dont_care),
            .instr          (instr),
            .rd_dm          (RD),
            .we_dm          (we_dm),
            .pc_current     (pc_current),
            .alu_out        (alu_out),
            .wd_dm          (wd_dm),
            .rd3            (Dont_care)
    );
        
   dmem dmem (
            .clk            (clk),
            .we             (WEM),
            .a              (alu_out[7:2]),
            .d              (wd_dm),
            .q              (DmemData)
        );
        
   fact_top factorial(
            .A(alu_out[3:2]),
            .WE(WE1),
            .clk(clk),
            .rst(rst),
            .WD(wd_dm[3:0]),
            .RD(FactData));
   
   gpio_top GPIO(
            .A              (alu_out[3:2]),
            .WE             (WE2),
            .clk            (clk),
            .rst            (rst),
            .WD             (wd_dm[31:0]),
            .RD             (GPIOData),
            .gpI1           (gpI1),
            .gpI2           (gpI2),
            .gpO1           (gpO1),
            .gpO2           (gpO2));
    
   always @ (*) begin
        case (RdSel)
            2'b00: RD = DmemData;
            2'b01: RD = DmemData;
            2'b10: RD = FactData;
            2'b11: RD = GPIOData;
            default: RD = 32'bx;
        endcase
    end  
endmodule
