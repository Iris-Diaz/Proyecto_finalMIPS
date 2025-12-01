`timescale 1ns/1ns
module sumador_branch (
    input [31:0] pc_mas_4,
    input [31:0] sign_extend,
    output [31:0] result_add
);

assign result_add = pc_mas_4 + sign_extend;

endmodule