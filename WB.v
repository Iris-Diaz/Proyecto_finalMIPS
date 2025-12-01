`timescale 1ns/1ns
module WB (
    // Señales desde MEM/WB
    input        reg_escribir_WB,      // Control: escribir al banco
    input [31:0] write_data_WB,        // Dato final para escribir
    input [4:0]  registro_destino_WB,  // Número de registro destino

    // Salidas hacia el banco de registros
    output       reg_write_out,
    output [4:0] rd_out,
    output [31:0] dato_escribir_out
);

assign reg_write_out     = reg_escribir_WB;
assign rd_out            = registro_destino_WB;
assign dato_escribir_out = write_data_WB;

endmodule
