`timescale 1ns/1ns
module memoria_instrucciones(
	input [7:0] dir,
	output reg [31:0] inst
);
reg [7:0] memoria [0:255]; 

initial begin
    $readmemb("Binario (1).txt", memoria);
end

always @*
	begin
	inst = {memoria[dir], memoria[dir+1], memoria[dir+2], memoria[dir+3]};
	end
endmodule 