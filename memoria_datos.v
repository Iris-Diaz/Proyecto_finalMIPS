`timescale 1ns/1ns
module memoria_datos(
    input clk,
    input mem_escribir,
    input mem_leer,
    input [31:0] direccion,
    input [31:0] dato_escribir,
    output reg [31:0] dato_leer
);

reg [31:0] memoria [0:255];

initial begin
    $readmemb("datos_memoria.txt", memoria);
end

always @(posedge clk) begin
    if (mem_escribir) begin
        memoria[direccion[7:0]] <= dato_escribir;
    end
end

always @(*) begin
    if (mem_leer) begin
        dato_leer = memoria[direccion[7:0]];
    end else begin
        dato_leer = 32'b0;
    end
end

endmodule