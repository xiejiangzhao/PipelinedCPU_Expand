module DataMem
(
	input [4:0] RA,
	input [4:0] WA,
	input [31:0] Di,
	input MemWr,
	output [31:0] Do
);
reg [31:0] DataMemory [31:0];
assign Do = DataMemory[RA];
always @(WA,Di,MemWr)
if(MemWr)
	DataMemory[WA] = Di;
endmodule
module mem(clk,addr,dout,din,memwr);
input [9:0] addr;
input clk; 
input [31:0] din;
input memwr;
output [31:0] dout;

reg [7:0] ram[2**6-1:0];

always @(posedge (~clk))
begin
	if(memwr&(~clk))
	begin
	ram[addr]=din[7:0];
	ram[addr+1]=din[15:8];
	ram[addr+2]=din[23:16];
	ram[addr+3]=din[31:24];
	end
	{ram[7],ram[6],ram[5],ram[4]}=32'b0000_0001_0010_0011_0100_0101_0110_0111;
	{ram[11],ram[10],ram[9],ram[8]}=32'b0000_0001_0010_0011_0100_0101_0110_0111;
	{ram[15],ram[14],ram[13],ram[12]}=32'b0000_0001_0010_0011_0100_0101_0110_0111;
	{ram[19],ram[18],ram[17],ram[16]}=32'b0000_0001_0010_0011_0100_0101_0110_0111;
	{ram[23],ram[22],ram[21],ram[20]}=32'b0000_0001_0010_0011_0100_0101_0110_0111;
end
assign dout={ram[addr+3],ram[addr+2],ram[addr+1],ram[addr]};
endmodule