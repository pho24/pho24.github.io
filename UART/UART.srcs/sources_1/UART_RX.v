`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2021 10:19:28 AM
// Design Name: UART protocol receiver driver
// Module Name: UART_RX
// Project Name:  UART protocol receiver driver
// Target Devices: Artyx-7 Basys3 FPGA
// Tool Versions: 1.0
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//clock frequency: 100MHz
//UART baud rate: 115200 bit/sec      => clock per bit = (25*10^6 clock/sec)/(115200 bit/sec) = 217

module UART_RX #(parameter clk_per_bit = 868)(
    input   wire         i_clk,
    input   wire         i_serial,
    output  wire  [7:0]   o_byte,
    output  reg          o_valid
    );
    
    localparam IDLE  = 3'b000,
              START = 3'b001,
              DATA  = 3'b010,
              STOP  = 3'B011;
              
    
    reg [2:0] r_state;
    reg [7:0] r_clk_cnt;
    reg [2:0] r_index;    //index for 
    reg [7:0] r_byte; //internal data register
    
    assign o_byte = (o_valid)? r_byte: 0;
    
    always@(posedge i_clk)begin
        case(r_state)
            IDLE:begin
                    //initialize value
                    r_clk_cnt <= 8'b0;
                    o_valid   <= 1'b0;
                    r_index   <= 3'b0;
                    r_byte    <= 8'b0;
                    
                    if(!i_serial)begin      //if serial signal drop to 0
                        r_state <= START;    //go to START state
                    end  
                    else begin              //else, stay in indle mode
                        r_state <= IDLE;
                    end 
                 end //end idle
             
            START:begin
                //if not at the middle of start bit
                //increment the counter
                    if(r_clk_cnt < ((clk_per_bit-1)>>>1))begin  //(217-1)/2
                        r_clk_cnt <= r_clk_cnt +1;  //increment the clock counter      
                        r_state   <= START;         //stay at start state
                    end
               //else, reset the clock and go to data state 
                //only if serial start bit stable at 0
                    else begin                             
                        if(!i_serial)begin          //if serial stable at 0
                            r_clk_cnt <= 0;         //reset counter 
                            r_state   <= DATA;      //go to sampling DATA state
                        end
                        else begin                  //if serial not stable
                            r_state   <= IDLE;      //go back to IDLE
                        end
                    end
                  end //end start state
                  
            DATA:begin
                if(r_clk_cnt < clk_per_bit-1) begin     //if at the middle of the data bit
                    r_clk_cnt <= r_clk_cnt +1;     //increment the counter
                    r_state <= DATA;               //remain in this state
                end
                else begin
                    r_clk_cnt       <= 0;   //reset counter
                    r_byte[r_index] <= i_serial;
                    
                    //if all data bit have not been received
                    if(r_index < 3'b111) begin
                        r_index <= r_index + 1; //increment the index
                        r_state <= DATA;        //stay in this state
                    end
                    //if all data has been collected
                    else begin
                        r_index <= 0;   //reset the index
                        r_state <= STOP;
                    end
                end
            end //end DATA state
            
            STOP:begin
                if(r_clk_cnt < clk_per_bit -1)begin  //if not at middle of stop bit
                    r_clk_cnt <= r_clk_cnt +1;  //increment counter
                    r_state   <= STOP;  // staty in this state
                end
                else begin      //if at the middle
                    o_valid   <= 1'b1; 
                    r_clk_cnt <= 0;
                    r_state   <= IDLE;
                end
            end //end STOP STATE
            
            default: r_state <= IDLE; 
        endcase
    end
    
endmodule
