`timescale 1ns/1ns
module ciclo_fetch(
input clk,
input rst_tb,
output [31:0] instruccion_fetch,
output [31:0] pc_plus4
);
wire [31:0] cable1,cable2;

program_counter inst1(
.clk_pc(clk),
.reset(rst_tb),
.pc_in(cable2),
.pc_out(cable1)
);

adicion inst2(
.opIn(cable1),
.opIn2(32'd4),
.opNext(cable2)
);

assign pc_plus4 = cable2;

memoria_instrucciones inst3(
.dir(cable1[7:0]),
.inst(instruccion_fetch)
);
endmodule