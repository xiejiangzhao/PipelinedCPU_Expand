module ALU
(

	input [31:0] A,B,
	input [3:0] ALUOp,
	output [31:0] Result,
	output Zero,
	output overflow

);

wire [31:0] ADD,SUB,XOR,NOR,SLT,CLO,CLZ,SLLV,SRA,SLTU;
assign {overflow,ADD} = A+B;
assign SUB = A-B;
assign XOR = A^B;
assign NOR = A~^B;
slt s(A,B,SLT);
assign SLTU = (A<B)?32'b1:32'b0;
LeaderA Leader1(1'b1,A,CLO);
LeaderA Leader0(1'b0,A,CLZ);
shifter sllv(A,B,1'b1,1'b1,SLLV);
shifter sra(A,B,1'b0,1'b1,SRA);
function [31:0] MUX;
input [31:0] ADD,SUB,XOR,NOR,SLT,SLTU,CLO,CLZ,SLLV,SRA;
case(ALUOp)
	4'b0000:
		MUX = ADD;
	4'b0001:
		MUX = SUB;
	4'b0010:
		MUX = CLZ;
	4'b0011:
		MUX = CLO;
	4'b0101:
		MUX = SLT;
	4'b0111:
		MUX = SLTU;
	4'b1000:
		MUX = NOR;
	4'b1001:
		MUX = XOR;
	4'b1010:
		MUX = SLLV;
	4'b1011:
		MUX = SRA;
	default:
		MUX = 32'b0;
endcase
endfunction
assign Result = MUX(ADD,SUB,XOR,NOR,SLT,SLTU,CLO,CLZ,SLLV,SRA);
assign Zero = ~(|Result);
endmodule
module LeaderA
(
	input oz,
	input [31:0] A,
	output [31:0] result
);
	wire [31:0] expand;
	wire [31:0] temp_data;
	assign expand = {32{oz}};
	assign temp_data = expand^A;
function [31:0] leader;
input [31:0] temp;
if(temp[31]) leader=5'b00000000000000000000000000000000;
else if(temp[30]) leader=32'b00000000000000000000000000000001;
else if(temp[29]) leader=32'b00000000000000000000000000000010;
else if(temp[28]) leader=32'b00000000000000000000000000000011;
else if(temp[27]) leader=32'b00000000000000000000000000000100;
else if(temp[26]) leader=32'b00000000000000000000000000000101;
else if(temp[25]) leader=32'b00000000000000000000000000000110;
else if(temp[24]) leader=32'b00000000000000000000000000000111;
else if(temp[23]) leader=32'b00000000000000000000000000001000;
else if(temp[22]) leader=32'b00000000000000000000000000001001;
else if(temp[21]) leader=32'b00000000000000000000000000001010;
else if(temp[20]) leader=32'b00000000000000000000000000001011;
else if(temp[19]) leader=32'b00000000000000000000000000001100;
else if(temp[18]) leader=32'b00000000000000000000000000001101;
else if(temp[17]) leader=32'b00000000000000000000000000001110;
else if(temp[16]) leader=32'b00000000000000000000000000001111;
else if(temp[15]) leader=32'b00000000000000000000000000010000;
else if(temp[14]) leader=32'b00000000000000000000000000010001;
else if(temp[13]) leader=32'b00000000000000000000000000010010;
else if(temp[12]) leader=32'b00000000000000000000000000010011;
else if(temp[11]) leader=32'b00000000000000000000000000010100;
else if(temp[10]) leader=32'b00000000000000000000000000010101;
else if(temp[9]) leader=32'b000000000000000000000000000010110;
else if(temp[8]) leader=32'b000000000000000000000000000010111;
else if(temp[7]) leader=32'b000000000000000000000000000011000;
else if(temp[6]) leader=32'b000000000000000000000000000011001;
else if(temp[5]) leader=32'b000000000000000000000000000011010;
else if(temp[4]) leader=32'b000000000000000000000000000011011;
else if(temp[3]) leader=32'b000000000000000000000000000011100;
else if(temp[2]) leader=32'b000000000000000000000000000011101;
else if(temp[1]) leader=32'b000000000000000000000000000011110;
else if(temp[0]) leader=32'b000000000000000000000000000011111;
else leader=32'b000000000000000000000000000100000;
endfunction
assign result = leader(temp_data);
endmodule 


module shifter
(
	input [31:0] source_data,
	input [31:0] num,
	input leftright,
	input arithmeticlogic,
	output [31:0] result
);
	reg [31:0] temp;
	integer i;
	wire [4:0] big_one;
	assign big_one = (num > 5'b11111)?5'b11111:num[4:0];
	always @(source_data,num,leftright,arithmeticlogic)
		begin
			if(leftright)
				temp = source_data << num;
			else
				begin
					if(arithmeticlogic)
						begin
							temp = source_data >> num;
							if(source_data[31])
								for(i=0;i<big_one;i=i+1)
									temp[31-i] = 1'b1;
						end
					else
						temp = source_data >> num;
				end
		end
	assign result = temp;
endmodule

module slt
(
	input [31:0] A,
	input [31:0] B,
	output [31:0] out
);
reg [31:0] temp;
always
begin
	case({A[31],B[31]})
		2'b00:
		temp=(A<B)?32'b0:32'b1;
		2'b01:
		temp=32'b1;
		2'b10:
		temp=32'b0;
		2'b11:
		temp=(A[30:0]<B[30:0])?32'b1:32'b0;
	endcase
end
assign out = temp;
endmodule
