
module PipelineCPU(
	input CLK,
	input RESET,
	output [31:0] pc_r,pc_w,ir_r,
	output [31:0] result2,aa,bb,result5,
	output [3:0] aluop,
	output [31:0] imm32,
	output alusrc,alusrc1,
	output extop1,regdst1,memwr1,branch,memtoreg1,sign1,chsresult1,jump,wrsrc1,mergeop1,regwr1,siftsrc1,
	output [31:0] reg_data,
	output [31:0] din,
	output mergeop,
	output [31:0] data,
	output [1:0] offset,
	output [31:0] data3,out4,
	output wrsrc,
	output [31:0] dt3,
	output [1:0] forwarda,forwardb
);


assign aa=busaa;
assign bb=busbb;
assign offset=result3[1:0];

//the variable
reg [31:0] pc,ir;
wire [31:0] ir_w;
wire [4:0] rs,rd,rt;
wire [15:0] imm16;
wire [31:0] da,db,dw;
wire extop,regdst,chsresult,siftsrc,zero;
wire [1:0] siftop;
wire [31:0]result6;
wire [31:0] busa,busb,busb1,num;
wire [31:0] addr,out0,out1,out2,out3;
wire memwr,regwr;

//the output of controler===the input of r1
wire [3:0] aluop1;
wire [1:0] siftop1;
wire [31:0] da1,db1;
wire [15:0] imm16_1;
//wire branch1,jump1;

//the output of r1====the input of r2
wire memwr2,memtoreg2,sign2,wrsrc2,mergeop2,regwr2,overflow2,branch2,jump2;
wire [4:0] rw2;
wire [31:0] ir2;
wire [4:0] rt1,rs1;
//the output of r2====the input of r3
wire memtoreg3,sign3,regwr3,overflow3;
wire [31:0] result3;
wire [4:0] rw3;
//the output of r3
wire [31:0] data4,result4;
wire [4:0] rw4;
wire memtoreg4,sign4,regwr4,overflow4;


wire [31:0] busaa,busbb,temp1;
forward fd(rs1,rt1,rw3,rw4,regwr3,regwr4,alusrc,forwarda,forwardb);
MUX32_4_1 mux32_4_10(busa,result3,dw,temp1,forwarda,busaa);
MUX32_4_1 mux32_4_11(busb1,result3,dw,temp1,forwardb,busbb);
assign temp1=0;



//the ir
InstRom irom(pc_r,ir_w);
assign ir_r=ir;
assign rs=ir_r[25:21];
assign rt=ir_r[20:16];
assign imm16_1=ir_r[15:0];
Registers regs(CLK,rs,rt,rw4,da1,db1,dw,regwr,reg_data,rw3,dt3);

InstructionDecode ID(ir,extop1,alusrc1,aluop1,regdst1,memwr1,branch,memtoreg1,sign1,chsresult1,jump,wrsrc1,siftop1,mergeop1,regwr1,siftsrc1);
wire memwr11,regwr11;
assign memwr11=memwr1&&(~jump2)&&(~(branch2&&busa[31]));
assign regwr11=regwr1&&(~jump2)&&(~(branch2&&busa[31]));

id_ex_register r1(CLK,extop1,alusrc1,aluop1,regdst1,memwr11,memtoreg1,sign1,chsresult1,wrsrc1,siftop1,mergeop1,regwr11,siftsrc1,imm16_1,da1,db1,rs,rt,branch,jump,
extop,alusrc,aluop,regdst,memwr2,memtoreg2,sign2,chsresult,wrsrc2,siftop,mergeop2,regwr2,siftsrc,imm16,busa,busb,rs1,rt1,branch2,jump2);
SignExtend se(imm16,imm32,extop);
MUX32_2_1 mux32_2_10(busb,imm32,alusrc,busb1);
ALU alu(busaa,busbb,aluop,zero,result5,overflow2);
MUX32_2_1 mux32_2_11(busa,imm16[10:6],siftsrc,num);
sift_32 st(busb,siftop,num,result6);
MUX32_2_1 mux32_2_12(result5,result6,chsresult,result2);
MUX5_2_1 mux5_2_10(rt1,imm16[15:11],regdst,rw2);




ex_mem_register r2(clk,memwr2,memtoreg2,sign2,wrsrc2,mergeop2,regwr2,rw2,result2,overflow2,busb,
memwr,memtoreg3,sign3,wrsrc,mergeop,regwr3,rw3,result3,overflow3,din);
assign addr=result3;
mem m(CLK,addr,data,din,memwr);
merge mg(dt3,data,mergeop,out0,out1,out2,out3);
MUX32_4_1 mux32_4_15(out0,out1,out2,out3,result3[1:0],out4);
MUX32_2_1 mux32_2_16(data,out4,wrsrc,data3);


mem_wr_register r3(clk,data3,memtoreg3,sign3,regwr3,rw3,overflow3,result3,data4,memtoreg4,sign4,regwr4,rw4,overflow4,result4);

MUX32_2_1 mux32_2_17(result4,data4,memtoreg4,dw);

assign regwr=regwr4&(sign4|((~sign4)&(~overflow4)));

wire [31:0] pc_w1,pc_w2,pc_w3,pc_w4,temp;
assign temp={{14{imm16_1[15]}},imm16_1[15:0],2'b00};
assign pc_w1=pc_r+4;
assign pc_w2=pc_r+temp-4;
assign pc_w3={{pc_r[31:28]},ir_r[25:0],2'b00};

MUX32_2_1 mux32_2_18(pc_w1,pc_w3,jump,pc_w4);
MUX32_2_1 mux32_2_19(pc_w4,pc_w2,branch&busa[31],pc_w);

assign pc_r=pc;
//assign ir=ir1;

always @(posedge CLK)
if(RESET)
pc=0;
else
begin
pc=pc_w;
ir=ir_w;
end



endmodule 



module control_harzard(
	input CLK,
	input ctr,
	input reset,
	output state
);
assign state = clear;
reg clear;
always @(posedge CLK)
begin
if(reset)
	clear <= 1'b0;
else
begin
	if(clear==1'b1)
		clear <= 1'b0;
	else
		if(ctr==1'b1)
			clear<=1'b1;
end
end
endmodule

module forward(rs,rt,rd1,rd2,regwr1,regwr2,alusrc,forwarda,forwardb);
input [4:0] rs,rt,rd1,rd2;
input regwr1,regwr2,alusrc;
output [1:0] forwarda,forwardb;

wire ca1,ca2,cb1,cb2;
assign ca1=regwr1&&(rs==rd1);
assign ca2=regwr2&&(rs==rd2);
assign cb1=regwr1&&(rt==rd1)&&(~alusrc);
assign cb2=regwr1&&(rt==rd2)&&(~alusrc);

assign forwarda[1]=ca2&&(~ca1);
assign forwarda[0]=ca1;
assign forwardb[1]=cb2&&(~cb1);
assign forwardb[0]=cb1;
endmodule

module merge (rdata,mdata,mergeop,out0,out1,out2,out3);
input [31:0] rdata,mdata;
input mergeop;
output reg [31:0] out0,out1,out2,out3;

always
begin
	if(mergeop==0)//lwl
	begin
		out0={mdata[7:0],rdata[23:0]};
		out1={mdata[15:0],rdata[15:0]};
		out2={mdata[23:0],rdata[7:0]};
		out3=mdata;
	end
	if(mergeop==1)//lwr
	begin
		out0=mdata;
		out1={rdata[31:24],mdata[31:8]};
		out2={rdata[31:16],mdata[31:16]};
		out3={rdata[31:8],mdata[31:24]};
	end
end

endmodule