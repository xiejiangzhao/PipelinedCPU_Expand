`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/10 11:42:14
// Design Name: 
// Module Name: PC_Control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PC_Control(
    input [31:0] PC_Now,
    input [25:0] J_Addr,
    input [31:0] Extend_Addr,
    input [31:0] Jal_Addr,
    input [1:0] PCSrc,
    output [31:0] PC_next
    );
    wire[31:0] Output1,Output2,Output3;
    wire[31:0] PC4;
    wire[31:0] Merge_Addr;
    assign PC4 = PC_Now+'b100;
    assign Output2=PC4+(Extend_Addr<<2);
    assign Merge_Addr={PC_Now[31:28],J_Addr,1'b0,1'b0};
    Select_32 Selector1(PCSrc[0],PC4,Output2,Output1);
    Select_32 Selector2(PCSrc[0],Jal_Addr,Merge_Addr,Output3);
    assign PC_next=(PCSrc[1]==1'b0 ? Output1 : Output3);
endmodule
