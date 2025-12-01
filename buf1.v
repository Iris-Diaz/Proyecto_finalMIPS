`timescale 1ns/1ns
module buf1(
    input clk_buf1,
    input reset_buf1,

    input  [31:0] instruccion_in,
    input  [31:0] pc_plus4_in,

    output reg [31:0] instruccion_out,
    output reg [31:0] pc_plus4_out
);

always @(posedge clk_buf1 or posedge reset_buf1) begin
    if (reset_buf1) begin
        instruccion_out <= 32'b0;
        pc_plus4_out    <= 32'b0;
    end
    else begin
        instruccion_out <= instruccion_in;
        pc_plus4_out    <= pc_plus4_in;
    end
end

endmodule

