`timescale 1ns / 1ps

module mux_memtoreg(
    input  [31:0] alu_result,   // Resultado de la ALU
    input  [31:0] mem_data,     // Dato leído de memoria
    input         mem_a_reg,    // Señal MemtoReg
    output [31:0] write_data    // Dato final para escribir en el registro
);

    assign write_data = (mem_a_reg) ? mem_data : alu_result;

endmodule
