`timescale 1ns/1ns
module and_zero (
    input branch,
    input cero,
    output wire branch_habilitado
);

assign branch_habilitado = branch & cero;

endmodule