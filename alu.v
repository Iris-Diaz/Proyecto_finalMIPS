`timescale 1ns/1ns
module alu(
    input [31:0] entrada_a,
    input [31:0] entrada_b,
    input [3:0] control_alu,
    output reg [31:0] resultado,
    output cero
);

always @(*) begin
    case(control_alu)
        4'b0000: resultado = entrada_a & entrada_b;      // AND
        4'b0001: resultado = entrada_a | entrada_b;      // OR  
        4'b0010: resultado = entrada_a + entrada_b;      // ADD
        4'b0110: resultado = entrada_a - entrada_b;      // SUB
        4'b0111: resultado = (entrada_a < entrada_b) ? 1 : 0; // SLT
        4'b1100: resultado = ~(entrada_a | entrada_b);   // NOR
        default: resultado = 0;
    endcase
end

assign cero = (resultado == 0);
endmodule