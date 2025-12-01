`timescale 1ns/1ns
module multi_cuatro (
    input branch_and_zero, 
    input [31:0] pc_mas_4,
    input [31:0] branch_add,
    output reg [31:0] salida_branch_mux
);

always @(*) begin
    if (branch_and_zero) begin
        salida_branch_mux = branch_add; 
    end 
	else begin
        salida_branch_mux = pc_mas_4;    
	end
end
endmodule