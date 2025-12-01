`timescale 1ns/1ns 
module burrote (
    input clk,
    input [31:0] instruccion,
    input [31:0] pc_plus4_out,
    input [31:0] dato_escribir,

    // Señales de control a ID/EX
    output salto_uc,
    output branch_uc,
    output mem_leer_uc,
    output mem_a_reg_uc,
    output mem_escribir_uc,
    output alu_fuente_uc,
    output [1:0] alu_operacion_uc,

    // Datos a ID/EX
    output [31:0] salida_corrimiento,
    output [31:0] dr1_salida,
    output [31:0] dr2_salida,
    output [31:0] salida_ext,
    output [5:0]  funct_out,
    output [31:0] pc_plus4_ID,
    output [4:0]  rt_out,
    output [4:0]  rd_out,
    output [31:0] jump_address_out
);

    wire u1, u2;  
    wire [4:0] c1;

    // Unidad de control
    unidad_control instb0(
        .codigo_operacion(instruccion[31:26]),
        .destino_reg(u1),
        .salto(salto_uc),
        .branch(branch_uc),
        .mem_leer(mem_leer_uc),
        .mem_a_reg(mem_a_reg_uc),
        .alu_operacion(alu_operacion_uc),
        .mem_escribir(mem_escribir_uc),
        .alu_fuente(alu_fuente_uc),
        .reg_escribir(u2)
    );

    // Shift left 2 de los 26 bits para jump
    corrimiento_izq2 instb1(
        .entrada_dato({6'b0, instruccion[25:0]}),
        .salida_dato(salida_corrimiento)
    );

    // Banco de registros: decide rd en función de destino_reg (u1)
    multiuno instb2(
        .A(instruccion[20:16]), // rt
        .B(instruccion[15:11]), // rd
        .sel(u1),
        .S(c1)
    );

    bancoRegistros instb3(
        .clk(clk), 
        .reg_escribir(u2),
        .rs(instruccion[25:21]),
        .rt(instruccion[20:16]),
        .rd(c1),
        .dato_escribir(dato_escribir),
        .dr1(dr1_salida),
        .dr2(dr2_salida)
    );

    extension_signo instb4(
        .inmediato(instruccion[15:0]),
        .extendido(salida_ext)
    );

    // Señales combinacionales
    assign funct_out       = instruccion[5:0];
    assign pc_plus4_ID     = pc_plus4_out;
    assign rt_out          = instruccion[20:16];
    assign rd_out          = instruccion[15:11];
    assign jump_address_out = { pc_plus4_out[31:28], salida_corrimiento[27:0] };

endmodule

