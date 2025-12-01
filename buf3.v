`timescale 1ns/1ns
module buffer_EX_MEM (
    input clk,
    input reset,

    // Señales de control desde EX
    input reg_escribir_MEM_ctrl_EX,
    input mem_a_reg_MEM_ctrl_EX,
    input mem_escribir_MEM_ctrl_EX,
    input mem_leer_MEM_ctrl_EX,

    // Señales de branch desde EX
    input branch_habilitado_EX,
    input [31:0] branch_target_EX,

    // Datos desde EX
    input [31:0] resultado_alu_EX,
    input [31:0] dr2_forward_EX,
    input [4:0]  registro_destino_EX,

    // Salidas hacia MEM
    output reg reg_escribir_MEM,
    output reg mem_a_reg_MEM,
    output reg mem_escribir_MEM,
    output reg mem_leer_MEM,

    output reg branch_habilitado_MEM,
    output reg [31:0] branch_target_MEM,

    output reg [31:0] resultado_alu_MEM,
    output reg [31:0] dr2_forward_MEM,
    output reg [4:0]  registro_destino_MEM
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Señales de control
        reg_escribir_MEM     <= 0;
        mem_a_reg_MEM        <= 0;
        mem_escribir_MEM     <= 0;
        mem_leer_MEM         <= 0;

        // Señales de branch
        branch_habilitado_MEM <= 0;
        branch_target_MEM     <= 32'b0;

        // Datos
        resultado_alu_MEM    <= 32'b0;
        dr2_forward_MEM      <= 32'b0;
        registro_destino_MEM <= 5'b0;
    end
    else begin
        // Señales de control a MEM
        reg_escribir_MEM     <= reg_escribir_MEM_ctrl_EX;
        mem_a_reg_MEM        <= mem_a_reg_MEM_ctrl_EX;
        mem_escribir_MEM     <= mem_escribir_MEM_ctrl_EX;
        mem_leer_MEM         <= mem_leer_MEM_ctrl_EX;

        // Señales de branch
        branch_habilitado_MEM <= branch_habilitado_EX;
        branch_target_MEM     <= branch_target_EX;

        // Datos
        resultado_alu_MEM    <= resultado_alu_EX;
        dr2_forward_MEM      <= dr2_forward_EX;
        registro_destino_MEM <= registro_destino_EX;
    end
end

endmodule
