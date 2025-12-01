`timescale 1ns/1ns
module buffer2_ID_EX (
    input clk,
    input reset,

    // Señales de control desde ID
    input reg_escribir_ID,
    input mem_a_reg_ID,
    input mem_escribir_ID,
    input mem_leer_ID,
    input branch_ID,
    input alu_fuente_ID,
    input [1:0] alu_operacion_ID,
    input salto_ID, 

    // Datos desde ID
    input [31:0] pc_plus4_ID,
    input [31:0] dr1_ID,
    input [31:0] dr2_ID,
    input [31:0] inmediato_ext_ID,
    input [31:0] salida_corrimiento_ID,
    input [4:0]  rt_ID,
    input [4:0]  rd_ID,
    input [5:0]  funct_ID,
    input [31:0] jump_address_ID,

    // Salidas hacia EX
    output reg reg_escribir_EX,
    output reg mem_a_reg_EX,
    output reg mem_escribir_EX,
    output reg mem_leer_EX,
    output reg branch_EX,
    output reg alu_fuente_EX,
    output reg salto_EX,
    output reg [1:0] alu_operacion_EX,

    output reg [31:0] pc_plus4_EX,
    output reg [31:0] dr1_EX,
    output reg [31:0] dr2_EX,
    output reg [31:0] inmediato_ext_EX,
    output reg [31:0] salida_corrimiento_EX,
    output reg [4:0]  rt_EX,
    output reg [4:0]  rd_EX,
    output reg [5:0]  funct_EX,
    output reg [31:0] jump_address_EX
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        reg_escribir_EX      <= 0;
        mem_a_reg_EX         <= 0;
        mem_escribir_EX      <= 0;
        mem_leer_EX          <= 0;
        branch_EX            <= 0;
        alu_fuente_EX        <= 0;
        salto_EX             <= 0;
        alu_operacion_EX     <= 2'b00;

        pc_plus4_EX          <= 32'b0;
        dr1_EX               <= 32'b0;
        dr2_EX               <= 32'b0;
        inmediato_ext_EX     <= 32'b0;
        salida_corrimiento_EX<= 32'b0;
        rt_EX                <= 5'b0;
        rd_EX                <= 5'b0;
        funct_EX             <= 6'b0;
        jump_address_EX      <= 32'b0;
    end 
    else begin
        reg_escribir_EX      <= reg_escribir_ID;
        mem_a_reg_EX         <= mem_a_reg_ID;
        mem_escribir_EX      <= mem_escribir_ID;
        mem_leer_EX          <= mem_leer_ID;
        branch_EX            <= branch_ID;
        alu_fuente_EX        <= alu_fuente_ID;
        salto_EX             <= salto_ID;
        alu_operacion_EX     <= alu_operacion_ID;

        pc_plus4_EX          <= pc_plus4_ID;
        dr1_EX               <= dr1_ID;
        dr2_EX               <= dr2_ID;
        inmediato_ext_EX     <= inmediato_ext_ID;
        salida_corrimiento_EX<= salida_corrimiento_ID;
        rt_EX                <= rt_ID;
        rd_EX                <= rd_ID;
        funct_EX             <= funct_ID;
        jump_address_EX      <= jump_address_ID;
    end
end

endmodule


