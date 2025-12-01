`timescale 1ns/1ns
module adicion(
input [31:0] opIn,
input[31:0] opIn2,
output [31:0]opNext
);
assign opNext= opIn+ opIn2;
endmodule