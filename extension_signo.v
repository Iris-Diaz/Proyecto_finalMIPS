`timescale 1ns/1ns
module extension_signo(
    input [15:0] inmediato,
    output reg [31:0] extendido
);

always @(*) begin
    extendido = {{16{inmediato[15]}}, inmediato};
end

endmodule