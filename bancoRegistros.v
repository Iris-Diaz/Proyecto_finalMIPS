`timescale 1ns/1ns 
module bancoRegistros(
    input clk,
    input reg_escribir,
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] rd,
    input [31:0] dato_escribir,
    output reg [31:0] dr1, 
    output reg [31:0] dr2
);

reg [31:0] registros [0:31];

initial begin
    $readmemb("datos2.txt", registros);
end

always @(*) begin
    dr1 = registros[rs];
    dr2 = registros[rt];
end

always @(posedge clk) begin
    if (reg_escribir && rd != 0) begin
        registros[rd] <= dato_escribir;
    end
end

endmodule