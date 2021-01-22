module auxdec (
        input  wire [1:0] alu_op,
        input  wire [5:0] funct,
        output wire [2:0] alu_ctrl,
        
        //update
        output reg        multu_sel,
        output reg  [1:0] hilo_sel,
        output reg        sl_sel,
        output reg        jr_sel
    );

    reg [2:0] ctrl;

    assign {alu_ctrl} = ctrl;

    always @ (alu_op, funct) begin
        case (alu_op)
            2'b00: //ctrl = 3'b010;          // ADD
            begin
                    ctrl = 3'b010;
                    multu_sel = 0;
                    hilo_sel = 00;
                    sl_sel = 0;
                    jr_sel = 0;     
            end 
            
            2'b01: //ctrl = 3'b110;          // SUB
            begin
                    ctrl = 3'b110;
                    multu_sel = 0;
                    hilo_sel = 00;
                    sl_sel = 0;
                    jr_sel = 0;     
            end 
                
            default: case (funct)
                6'b10_0100: //ctrl = 3'b000;//and
                begin
                    ctrl = 3'b000;
                    multu_sel = 0;
                    hilo_sel = 00;
                    sl_sel = 0;
                    jr_sel = 0;     
                end 
                
                6'b10_0101: //ctrl = 3'b001; // OR
                begin
                    ctrl = 3'b001;
                    multu_sel = 0;
                    hilo_sel = 00;
                    sl_sel = 0;
                    jr_sel = 0;     
                end 
                
                6'b10_0000: //ctrl = 3'b010; // ADD
                begin
                    ctrl = 3'b010;
                    multu_sel = 0;
                    hilo_sel = 00;
                    sl_sel = 0;
                    jr_sel = 0;     
                end 
                
                6'b10_0010: //ctrl = 3'b110; // SUB
                begin
                    ctrl = 3'b110;
                    multu_sel = 0;
                    hilo_sel = 00;
                    sl_sel = 0;
                    jr_sel = 0;     
                end 
                6'b10_1010: //ctrl = 3'b111; // SLT
                begin
                    ctrl = 3'b111;
                    multu_sel = 0;
                    hilo_sel = 00;
                    sl_sel = 0;
                    jr_sel = 0;     
                end 
                
                6'b01_0000: // mfhi
                begin
                    ctrl = 3'bxxx;
                    multu_sel = 0;
                    hilo_sel = 10;
                    sl_sel = 0;
                    jr_sel = 0;     
                end 
                
                6'b01_0010: // mflo
                begin
                    ctrl = 3'bxxx;
                    multu_sel = 0;
                    hilo_sel = 01;
                    sl_sel = 0;
                    jr_sel = 0;     
                end 
                
                6'b00_0000: // sll
                begin
                    ctrl = 3'b011;
                    multu_sel = 0;
                    hilo_sel = 00;
                    sl_sel = 1;
                    jr_sel = 0;     
                end 
                
                6'b00_0010: // slr
                begin
                    ctrl = 3'b100;
                    multu_sel = 0;
                    hilo_sel = 00;
                    sl_sel = 1;
                    jr_sel = 0;     
                end 
                
                6'b00_1000: // jr
                begin
                    ctrl = 3'bxxx;
                    multu_sel = 0;
                    hilo_sel = 00;
                    sl_sel = 0;
                    jr_sel = 1;     
                end 
                
                6'b01_1001: // multu
                begin
                    ctrl = 3'bxxx;
                    multu_sel = 1;
                    hilo_sel = 00;
                    sl_sel = 0;
                    jr_sel = 0;     
                end 
                
                default:    //ctrl = 3'bxxx;
                begin
                    ctrl = 3'bxxx;
                    multu_sel = 0;
                    hilo_sel = 00;
                    sl_sel = 0;
                    jr_sel = 0;     
                end 
            endcase
        endcase
    end

endmodule