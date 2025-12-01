`timescale 1ns/1ns
module multidos(
    input sel2,
    input [31:0] A2,
    input [31:0] B2,
    output reg [31:0] S2
);

always @(*) begin
    S2 = sel2 ? A2 : B2;
end

endmodule
