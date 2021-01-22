module controlunit (
        input  wire [5:0]  opcode,
        input  wire [5:0]  funct,
        output wire        branch,
        output wire        jump,
        output wire        reg_dst,
        output wire        we_reg,
        output wire        alu_src,
        output wire        we_dm,
        output wire        dm2reg,
        output wire [2:0]  alu_ctrl,
        
        //updated
        output wire        multu_sel,
        output wire  [1:0] hilo_sel,
        output wire        sl_sel,
        output wire        jr_sel,
        output wire        jal_ra, 
        output wire        jal_wd
        
    );
    
    wire [1:0] alu_op;

    maindec md (
        .opcode         (opcode),
        .branch         (branch),
        .jump           (jump),
        .reg_dst        (reg_dst),
        .we_reg         (we_reg),
        .alu_src        (alu_src),
        .we_dm          (we_dm),
        .dm2reg         (dm2reg),
        .alu_op         (alu_op),
        
        //update
        .jal_ra         (jal_ra),
        .jal_wd         (jal_wd)
        
    );

    auxdec ad (
        .alu_op         (alu_op),
        .funct          (funct),
        .alu_ctrl       (alu_ctrl),
        
        //update 
        .jr_sel         (jr_sel),
        .multu_sel      (multu_sel),
        .hilo_sel       (hilo_sel),
        .sl_sel         (sl_sel)
    );

endmodule