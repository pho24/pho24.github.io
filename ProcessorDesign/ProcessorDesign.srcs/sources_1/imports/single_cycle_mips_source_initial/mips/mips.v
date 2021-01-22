module mips (
        input  wire        clk,
        input  wire        rst,
        input  wire [4:0]  ra3,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm,
        output wire        we_dm,
        output wire [31:0] pc_current,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm,
        output wire [31:0] rd3
    );
    
    wire       branch;
    wire       jump;
    wire       reg_dst;
    wire       we_reg;
    wire       alu_src;
    wire       dm2reg;
    wire [2:0] alu_ctrl;
    
    //update
    wire        multu_sel;
    wire  [1:0] hilo_sel;
    wire        jr_sel;
    wire        jal_ra; 
    wire        jal_wd;
    wire        sl_sel;

    datapath dp (
            .clk            (clk),
            .rst            (rst),
            .branch         (branch),
            .jump           (jump),
            .reg_dst        (reg_dst),
            .we_reg         (we_reg),
            .alu_src        (alu_src),
            .dm2reg         (dm2reg),
            .alu_ctrl       (alu_ctrl),
            .ra3            (ra3),
            .instr          (instr),
            .rd_dm          (rd_dm),
            .pc_current     (pc_current),
            .alu_out        (alu_out),
            .wd_dm          (wd_dm),
            .rd3            (rd3),
            
            //update
            .multu_sel      (multu_sel),
            .hilo_sel       (hilo_sel),
            .jr_sel         (jr_sel),
            .jal_ra         (jal_ra),
            .jal_wd         (jal_wd),
            .sl_sel         (sl_sel)
              
        );

    controlunit cu (
            .opcode         (instr[31:26]),
            .funct          (instr[5:0]),
            .branch         (branch),
            .jump           (jump),
            .reg_dst        (reg_dst),
            .we_reg         (we_reg),
            .alu_src        (alu_src),
            .we_dm          (we_dm),
            .dm2reg         (dm2reg),
            .alu_ctrl       (alu_ctrl),
            
            //update
            .multu_sel      (multu_sel),
            .hilo_sel       (hilo_sel),
            .jr_sel         (jr_sel),
            .jal_ra         (jal_ra),
            .jal_wd         (jal_wd),
            .sl_sel         (sl_sel)
        );

endmodule