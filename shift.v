module ShiftLeft2
(
	input [31:0] A,
	output [31:0] result
);
assign result = A << 2;
endmodule

module SignExtend
(
	input [15:0] imm16,
	input EXTOp,
	output reg [31:0] ext
);
always @(imm16,EXTOp)
begin
	if(EXTOp & imm16[15])
		ext = {16'hffff,imm16};
	else
		ext = {16'h0000,imm16};
end
endmodule
module sift_32(iSW,op,num,oLEDG);
input [31:0] iSW;
input [1:0] op;
input [4:0] num;
output [31:0] oLEDG;

//declare the varibles
reg [31:0] a;
reg [4:0] b;
reg [1:0] c;
reg d;
integer i;

always @(iSW or op or num )
begin
a=iSW[31:0];
b=num;
c=op;
d=iSW[31];// save the sign
case(c)
	//logical right sift
	2'b00:
			begin
			a=a>>b;
			end
	//logical left sift	
		
	2'b01:
			begin
			a=a<<b;
			end
			
	//arithmetic right sift		
	2'b10:
			begin
			a=a>>b;
			for(i=0;i<b;i=i+1)
			a[31-i]=d;
			end
			
	//arithmetic left sift
	2'b11:
			begin
			a=a<<b;
			end
endcase
end

assign oLEDG[31:0]=a;

endmodule