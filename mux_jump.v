`timescale 1ns/1ns
module mux_jump (
    input jump, 
    input [31:0] entrada_branch,
    input [31:0] jump_address,
    output reg [31:0] proximo_pc
);

always @(*) begin
    if (jump) begin
        proximo_pc = jump_address; 
    end
	else begin
        proximo_pc = entrada_branch; // Si es 'BEQ', 'LW', 'SW', o Tipo-R
    end
end

endmodule