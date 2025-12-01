`timescale  1ns/1ns
module program_counter(
	input clk_pc,
	input reset,
	input [31:0]pc_in,
	output reg [31:0] pc_out
);
always @(posedge clk_pc or posedge reset)
	begin
		if(reset)
		begin
		pc_out = 32'b0;
		end
		else
		begin
		pc_out=pc_in;
		end
	end
endmodule
