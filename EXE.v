`timescale 1ns/1ns
module EXE (
    // Desde Buffer2 (ID/EX)
    input [31:0] pc_plus4_EX,
    input [31:0] dr1_EX,
    input [31:0] dr2_EX,
    input [31:0] inmediato_ext_EX,
    input [31:0] jump_address_EX,
    input [4:0]  rt_EX,
    input [4:0]  rd_EX,
    input [5:0]  funct_EX,

    // Controles desde ID/EX
    input salto_EX, 
    input reg_escribir_EX,
    input mem_a_reg_EX,
    input mem_escribir_EX,
    input mem_leer_EX,
    input branch_EX,
    input alu_fuente_EX,
    input [1:0] alu_operacion_EX,

    // Salidas hacia EX/MEM
    output [31:0] resultado_alu_EX_out,
    output [31:0] dr2_forward_EX_out,
    output [4:0]  registro_destino_EX_out,
    output [31:0] proximo_pc_EX_out,
    
    // Señales de control reenviadas hacia MEM
    output reg reg_escribir_MEM_ctrl,
    output reg mem_a_reg_MEM_ctrl,
    output reg mem_escribir_MEM_ctrl,
    output reg mem_leer_MEM_ctrl
);

    // Reenvío de señales de control a MEM
    always @(*) begin
        reg_escribir_MEM_ctrl = reg_escribir_EX;
        mem_a_reg_MEM_ctrl    = mem_a_reg_EX;
        mem_escribir_MEM_ctrl = mem_escribir_EX;
        mem_leer_MEM_ctrl     = mem_leer_EX;
    end

    // MUX RegDst
    multiuno mux_regdst (
        .A(rt_EX),
        .B(rd_EX),
        .sel(alu_operacion_EX == 2'b10),
        .S(registro_destino_EX_out)
    );

    // MUX ALUSrc
    wire [31:0] entrada_b_alu;

    multidos mux_alusrc (
        .A2(dr2_EX),
        .B2(inmediato_ext_EX),
        .sel2(alu_fuente_EX),
        .S2(entrada_b_alu)
    );
    
    // ALU CONTROL
    wire [3:0] control_alu_w;

    alu_control alu_ctrl (
        .operacion_alu(alu_operacion_EX),
        .funcion(funct_EX),
        .funcion_alu(control_alu_w)
    );

    // ALU
    wire cero_flag;

    alu alu_unit (
        .entrada_a(dr1_EX),
        .entrada_b(entrada_b_alu),
        .control_alu(control_alu_w),
        .resultado(resultado_alu_EX_out),
        .cero(cero_flag)
    );

    // Branch: PC+4 + (imm << 2)
    wire [31:0] immediate_shifted = inmediato_ext_EX << 2;
    wire [31:0] branch_add_w;

    sumador_branch sum_branch (
        .pc_mas_4(pc_plus4_EX),
        .sign_extend(immediate_shifted),
        .result_add(branch_add_w)
    );

    // AND branch & zero
    wire and_branch_w;
    and_zero and_branch_inst (
        .branch(branch_EX),
        .cero(cero_flag),
        .branch_habilitado(and_branch_w)
    );

    // MUX branch / PC+4
    wire [31:0] salida_branch_mux_w;
    multi_cuatro mux_branch (
        .branch_and_zero(and_branch_w),
        .pc_mas_4(pc_plus4_EX),
        .branch_add(branch_add_w),
        .salida_branch_mux(salida_branch_mux_w)
    );
    
    // MUX jump
    mux_jump mux_jump_inst (
        .jump(salto_EX),
        .entrada_branch(salida_branch_mux_w),
        .jump_address(jump_address_EX),
        .proximo_pc(proximo_pc_EX_out)
    );

    // dr2 para SW
    assign dr2_forward_EX_out = dr2_EX;

endmodule
