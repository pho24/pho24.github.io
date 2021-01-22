module datapath (
        input  wire        clk,
        input  wire        rst,
        input  wire        branch,
        input  wire        jump,
        input  wire        reg_dst,
        input  wire        we_reg,
        input  wire        alu_src,
        input  wire        dm2reg,
        input  wire [2:0]  alu_ctrl,
        input  wire [4:0]  ra3,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm,
        output wire [31:0] pc_current,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm,
        output wire [31:0] rd3,
        
        //updated
        input wire        multu_sel,
        input wire  [1:0] hilo_sel,
        input wire        jr_sel,
        input wire        jal_ra, 
        input wire        jal_wd,
        input wire        sl_sel
    );

    wire [4:0]  rf_wa;
    wire        pc_src;
    wire [31:0] pc_plus4;
    wire [31:0] pc_pre;
    wire [31:0] pc_next;
    wire [31:0] sext_imm;
    wire [31:0] ba;
    wire [31:0] bta;
    wire [31:0] jta;
    wire [31:0] alu_pa;
    wire [31:0] alu_pb;
    wire [31:0] wd_rf;
    wire        zero;
    
    wire [63:0] aMultb, wd_multu;
    wire [31:0] wd_multu_rf;
    wire [31:0] wd;
    wire [4:0] wa;
    wire [31:0] pc;
    wire [31:0] sl_alu_pa;
    
    
    assign pc_src = branch & zero;
    assign ba = {sext_imm[29:0], 2'b00};
    assign jta = {pc_plus4[31:28], instr[25:0], 2'b00};
    
    // --- PC Logic --- //
    dreg #(32) pc_reg (
            .clk            (clk),
            .rst            (rst),
            .we             (1'b1),
            .d              (pc_next),
            .q              (pc_current)
        );

    adder pc_plus_4 (
            .a              (pc_current),
            .b              (32'd4),
            .y              (pc_plus4)
        );

    adder pc_plus_br (
            .a              (pc_plus4),
            .b              (ba),
            .y              (bta)
        );

    mux2 #(32) pc_src_mux (
            .sel            (pc_src),
            .a              (pc_plus4),
            .b              (bta),
            .y              (pc_pre)
        );

    mux2 #(32) pc_jmp_mux (
            .sel            (jump),
            .a              (pc_pre),
            .b              (jta),
            .y              (pc)
        );

    // --- RF Logic --- //
    mux2 #(5) rf_wa_mux (
            .sel            (reg_dst),
            .a              (instr[20:16]),
            .b              (instr[15:11]),
            .y              (rf_wa)
        );

    regfile rf (
            .clk            (clk),
            .we             (we_reg),
            .ra1            (instr[25:21]),
            .ra2            (instr[20:16]),
            .ra3            (ra3),
            .wa             (wa),
            .wd             (wd),
            .rd1            (alu_pa),
            .rd2            (wd_dm),
            .rd3            (rd3)
        );

    signext se (
            .a              (instr[15:0]),
            .y              (sext_imm)
        );

    // --- ALU Logic --- //
    mux2 #(32) alu_pb_mux (
            .sel            (alu_src),
            .a              (wd_dm),
            .b              (sext_imm),
            .y              (alu_pb)
        );

    alu alu (
            .op             (alu_ctrl),
            .b              (alu_pb),
            .a              (sl_alu_pa),
            .zero           (zero),
            .y              (alu_out)
        );

    // --- MEM Logic --- //
    mux2 #(32) rf_wd_mux (
            .sel            (dm2reg),
            .a              (alu_out),
            .b              (rd_dm),
            .y              (wd_rf)
        );
        
    //lab 7 updated//
        //multu
    multu multu (
            .a(alu_pa),
            .b(wd_dm),
            .result(aMultb)
    );
    
    dreg #(64) hilo_reg (
            .clk            (clk),
            .rst            (rst),
            .we             (multu_sel),
            .d              (aMultb),
            .q              (wd_multu)
    );
    
    mux3 multu_mux (
            .a(wd_rf),
            .b(wd_multu[31:0]),
            .c(wd_multu[63:32]),
            .sel(hilo_sel),
            .y(wd_multu_rf)
    );
    
        //jr jump to register
    mux2 #(32) jr_mux (
            .sel            (jr_sel),
            .a              (pc),
            .b              (alu_pa),
            .y              (pc_next)
    );
    
        //jal jump and link
    mux2 #(32) jal_wd_mux (
            .sel            (jal_wd),
            .a              (wd_multu_rf),
            .b              (pc_plus4),
            .y              (wd)
        );
    
    mux2 #(5) jal_ra_mux (
            .sel            (jal_ra),
            .a              (rf_wa),
            .b              (5'd31),
            .y              (wa)
    );
    
        //shift logical
    mux2 #(32) sl_mux (
            .sel            (sl_sel),
            .a              (alu_pa),
            .b              ({27'b0,instr[10:6]}),
            .y              (sl_alu_pa)
    );
        

endmodule