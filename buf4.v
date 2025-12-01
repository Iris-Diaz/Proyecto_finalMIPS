`timescale 1ns/1ns
module buffer_MEM_WB (
    input clk,
    input reset,

    // Señales de control desde MEM
    input reg_escribir_MEM,
    input mem_a_reg_MEM,

    // Datos desde MEM
    input [31:0] dato_memoria_MEM,
    input [31:0] resultado_alu_MEM,
    input [4:0]  registro_destino_MEM,

    // Salidas hacia WB
    output reg reg_escribir_WB,
    output reg mem_a_reg_WB,

    output reg [31:0] dato_memoria_WB,
    output reg [31:0] resultado_alu_WB,
    output reg [4:0]  registro_destino_WB
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Control
        reg_escribir_WB      <= 0;
        mem_a_reg_WB         <= 0;

        // Datos
        dato_memoria_WB      <= 32'b0;
        resultado_alu_WB     <= 32'b0;
        registro_destino_WB  <= 5'b0;
    end 
    else begin
        // Control
        reg_escribir_WB      <= reg_escribir_MEM;
        mem_a_reg_WB         <= mem_a_reg_MEM;

        // Datos
        dato_memoria_WB      <= dato_memoria_MEM;
        resultado_alu_WB     <= resultado_alu_MEM;
        registro_destino_WB  <= registro_destino_MEM;
    end
end

endmodule

