`timescale 1ns/1ns
module unidad_control(
    input [5:0] codigo_operacion,
    output reg destino_reg,
    output reg branch,
    output reg mem_leer,
    output reg mem_a_reg,
    output reg [1:0] alu_operacion,
    output reg mem_escribir,
    output reg alu_fuente,
    output reg reg_escribir,
    output reg salto
);

always @(*) begin
    case(codigo_operacion)
        6'b000000: begin // Tipo-R
            destino_reg = 1; 
			branch = 0; 
			mem_leer = 0; 
			mem_a_reg = 0; 
            alu_operacion = 2'b10; 
			mem_escribir = 0; 
			alu_fuente = 0; 
			reg_escribir = 1; salto = 0;
        end
        6'b100011: begin // LW
            destino_reg = 0; 
			branch = 0; 
			mem_leer = 1; 
			mem_a_reg = 1; 
            alu_operacion = 2'b00; 
			mem_escribir = 0; 
			alu_fuente = 1; 
			reg_escribir = 1; 
			salto = 0;
        end
        6'b101011: begin // SW
            destino_reg = 0; 
			branch = 0; 
			mem_leer = 0; 
			mem_a_reg = 0; 
            alu_operacion = 2'b00; 
			mem_escribir = 1; 
			alu_fuente = 1; 
			reg_escribir = 0; 
			salto = 0;
        end
        6'b000100: begin // BEQ
            destino_reg = 0; 
			branch = 1; 
			mem_leer = 0; 
			mem_a_reg = 0; 
            alu_operacion = 2'b01; 
			mem_escribir = 0; 
			alu_fuente = 0; 
			reg_escribir = 0; 
			salto = 0;
        end
        6'b000010: begin // J
            destino_reg = 0; 
			branch = 0; 
			mem_leer = 0; 
			mem_a_reg = 0; 
            alu_operacion = 2'b00;
			mem_escribir = 0; 
			alu_fuente = 0; 
			reg_escribir = 0; 
			salto = 1;
        end
        default: begin
            destino_reg = 0; 
			branch = 0; 
			mem_leer = 0; 
			mem_a_reg = 0; 
            alu_operacion = 2'b00; 
			mem_escribir = 0; 
			alu_fuente = 0; 
			reg_escribir = 0; 
			salto = 0;
        end
    endcase
end
endmodule
