module IFetch
(
	input RESET,
	input [31:0] pc_in,
	output [31:0] PC,
	output [31:0] inst
);
InstructionMemory IM (RESET,pc_in[3:0],inst);
assign PC = pc_in + 1'b100;
endmodule

