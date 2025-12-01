`timescale 1ns/1ns 
module multiuno(
    input sel,
    input [4:0] A,
    input [4:0] B,
    output reg [4:0] S
);

always @(*) begin
    S = sel ? A : B;
end

endmodule
