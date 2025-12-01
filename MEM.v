`timescale 1ns/1ns
module MEM (
    input clk,

    //-- Señales de control recibidas desde EX/MEM --
    input reg_escribir_MEM,
    input mem_a_reg_MEM,
    input mem_escribir_MEM,
    input mem_leer_MEM,

    //-- Datos desde EX/MEM --
    input [31:0] resultado_alu_MEM,    // Dirección calculada por ALU (LW/SW)
    input [31:0] dr2_forward_MEM,      // Valor para SW
    input [4:0]  registro_destino_MEM, // Numero del registro destino

    //-- Salidas hacia MEM/WB --
    output [31:0] dato_memoria_out,    // Dato leído desde RAM
    output [31:0] alu_result_out,      // Resultado ALU para WB
    output [4:0]  rd_out,              // Registro destino
    output mem_a_reg_out,              // Control MemToReg
    output reg_escribir_out            // Control RegWrite
);


    wire [31:0] dato_leido;

    memoria_datos mem_ram (
        .clk(clk),
        .mem_escribir(mem_escribir_MEM),
        .mem_leer(mem_leer_MEM),
        .direccion(resultado_alu_MEM),
        .dato_escribir(dr2_forward_MEM),
        .dato_leer(dato_leido)
    );


    assign dato_memoria_out   = dato_leido;         // dato para WB
    assign alu_result_out     = resultado_alu_MEM;  // ALU para WB
    assign rd_out             = registro_destino_MEM;

    assign mem_a_reg_out      = mem_a_reg_MEM;      // control para WB
    assign reg_escribir_out   = reg_escribir_MEM;   // control para WB

endmodule

