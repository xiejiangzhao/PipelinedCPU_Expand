module MUX5_2_1
(
	input [4:0] A,B,
	input sel,
	output [4:0] result
);
assign result = (sel==1)?B:A;
endmodule

module MUX32_2_1
(
	input [31:0] A,B,
	input sel,
	output [31:0] result
);
assign result = (sel==1)?B:A;
endmodule

module MUX32_4_1
(
	input [31:0] A,B,C,D,
	input [1:0] sel,
	output reg [31:0] result
);
always
begin
	case (sel)
	2'b00:result = A;
	2'b01:result = B;
	2'b10:result = C;
	2'b11:result = D;
	//default: result = A;
	endcase
end
endmodule
