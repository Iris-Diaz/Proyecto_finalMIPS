`timescale 1ns/1ns 
module alu_control(
    input [1:0] operacion_alu,
    input [5:0] funcion,
    output reg [3:0] funcion_alu
);

always @(*) begin
    case(operacion_alu)
        2'b00: begin 
            funcion_alu = 4'b0010; // LW/SW -> ADD
        end
        2'b01: begin 
            funcion_alu = 4'b0110; // BEQ -> SUB
        end
        2'b10: begin // Tipo-R
            case(funcion)
                6'b100000: funcion_alu = 4'b0010; // ADD
                6'b100010: funcion_alu = 4'b0110; // SUB
                6'b100100: funcion_alu = 4'b0000; // AND
                6'b100101: funcion_alu = 4'b0001; // OR
                6'b101010: funcion_alu = 4'b0111; // SLT
                default: funcion_alu = 4'b0000;
            endcase
        end
        default: begin
            funcion_alu = 4'b0000;
        end
    endcase
end
endmodule